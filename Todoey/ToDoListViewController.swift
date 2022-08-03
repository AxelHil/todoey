import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController {
    
    let localRealm = try! Realm()
    
    var itemList: Results<Item>?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory: CategoryItem? {
        didSet{
           loadDataFromDB()
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let coelColour = selectedCategory?.colour {
           
            let colour = UIColor(hexString: coelColour)
            let contrastColour = ContrastColorOf(colour!, returnFlat: true)
            
            navigationItem.title = selectedCategory!.title
        
            navigationController?.navigationBar.tintColor = contrastColour
            navigationItem.rightBarButtonItem?.tintColor = contrastColour
           
            let navigationBarAppearance = UINavigationBarAppearance()
            
            navigationBarAppearance.backgroundColor = colour
            navigationBarAppearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: contrastColour]
            
            navigationController?.navigationBar.standardAppearance = navigationBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
            
            searchBar.barTintColor = colour
            searchBar.searchTextField.backgroundColor = .white
                    
        }
      
    }

   //MARK: - Table View and Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList?.count ?? 1
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        var content = cell.contentConfiguration as! UIListContentConfiguration
        
        if let coelTitle = itemList?[indexPath.row].title {
            
            content.text = coelTitle
            
            let color = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(itemList!.count))
            
            cell.backgroundColor = color
            
            content.textProperties.color = ContrastColorOf(color!, returnFlat: true)
            
            cell.accessoryType = self.itemList![indexPath.row].checked ? .checkmark : .none
            
            
        } else {
            
            content.text = "No Items Added Yet"
        }
        
        cell.contentConfiguration = content
        
        return cell

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
        do {
            
            try localRealm.write({
                
                self.itemList![indexPath.row].checked = !self.itemList![indexPath.row].checked
                
            })
            
        } catch {
            
            print("Error updating \(error)")
            
        }

        tableView.deselectRow(at: indexPath, animated: true)
        
        tableView.reloadRows(at: [indexPath], with: .none)
        
    }
 
   
    //MARK: - Add item button
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add New Item", message: nil, preferredStyle: .alert)
        
        alert.addTextField {
            textField in
            textField.placeholder = "ToDo Item"
        }
        
        let action = UIAlertAction(title: "Add Item", style: .default) {
            action in
            
            if alert.textFields?[0].text != "" {
                
                let newItem = Item()
                newItem.title = alert.textFields![0].text
                newItem.date = (Date()).timeIntervalSince1970
             
                do {
                    try self.localRealm.write({
                        self.selectedCategory!.items.append(newItem)
                    })
                } catch {
                    print(error)
                }
                
                self.tableView.reloadData()
            }
            
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true) {
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOutside)))
        }
    }
    
    @objc func dismissOnTapOutside() {
        self.dismiss(animated: true)
       
    }
    
    //Load Data from DB
    func loadDataFromDB() {
        
        itemList = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

    }
    
    override func destroy(at indexPath: IndexPath) {
        
        try! self.localRealm.write({
           
            self.localRealm.delete(self.itemList![indexPath.row])
            
        })
        
    }
    
}


//MARK: - Search button functionality
extension ToDoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        itemList = itemList!.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "date", ascending: false)
    
        tableView.reloadData()
        
    }
     
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()

            }

            loadDataFromDB()
            tableView.reloadData()
        }
    }
}
