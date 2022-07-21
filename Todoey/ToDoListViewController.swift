import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    
    let localRealm = try! Realm()
    
    var itemList: Results<Item>?

    var selectedCategory: CategoryItem? {
        didSet{
           loadDataFromDB()
        }
    }
    
    override func viewDidLoad() {
        
      
        super.viewDidLoad()
        
        //Navigation Bar setup
        let navigationBarAppearance = UINavigationBarAppearance()
        
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationBarAppearance.backgroundColor = .systemBlue
        
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
    
       
    }

   //MARK: - Table View and Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList?.count ?? 1
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
   
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListItemCell")

        var content = cell?.defaultContentConfiguration()
        
        if let coelTitle = itemList?[indexPath.row].title {
            
            content?.text = coelTitle
            
            cell?.accessoryType = self.itemList![indexPath.row].checked ? .checkmark : .none
        } else {
            
            content?.text = "No Items Added Yet"
        }
        
        cell?.contentConfiguration = content
        
        return cell!

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
 
    //MARK: - Swipe action config
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let contextAction = UIContextualAction(style: .destructive, title: "Delete") { action, sourceView, completionHandler in
            
            try! self.localRealm.write({
                self.localRealm.delete(self.itemList![indexPath.row])

            })
            
            completionHandler(true)
            self.tableView.reloadData()
        }
        
        let swipeActionsConfiguration = UISwipeActionsConfiguration(actions: [contextAction])
        
        return swipeActionsConfiguration
        
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
        
        present(alert, animated: true)
    }
    
    //Load Data from DB
    func loadDataFromDB() {
        
        itemList = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

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
