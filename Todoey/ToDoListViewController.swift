import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    
    
    var listItemArray = [Item]()
    
//    var dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var context: NSManagedObjectContext?
    

    override func viewDidLoad() {
        super.viewDidLoad()
       
        context = appDelegate.persistentContainer.viewContext
    
        
        //Navigation Bar setup
        let navigationBarAppearance = UINavigationBarAppearance()
        
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationBarAppearance.backgroundColor = .systemBlue
        
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        
        loadDataFromDB()
    }

    //Table View and Cells render
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItemArray.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
   
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListItemCell")
        
        var content = cell?.defaultContentConfiguration()
        
        content?.text = listItemArray[indexPath.row].title
        cell?.contentConfiguration = content
        
        cell?.accessoryType = self.listItemArray[indexPath.row].checked ? .checkmark : .none
        
        return cell!

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
  
        self.listItemArray[indexPath.row].checked = !self.listItemArray[indexPath.row].checked
        
//        context?.delete(listItemArray[indexPath.row])
//        self.listItemArray.remove(at: indexPath.row)
       
        writeDataToDB()
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadRows(at: [indexPath], with: .none)
        
    }
   
    //Add Task Button
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add New Item", message: nil, preferredStyle: .alert)
        
        alert.addTextField {
            textField in
            textField.placeholder = "ToDo Item"
        }
        
        let action = UIAlertAction(title: "Add Item", style: .default) {
            action in
            
            if let coelText = alert.textFields?[0].text {
                
                let newItem = Item(context: self.context!)
                
                newItem.title = coelText
                newItem.checked = false
                
                self.listItemArray.append(newItem)
            
                self.writeDataToDB()
                self.tableView.reloadData()
            }
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
    //Create data in DB
    func writeDataToDB() {
        
        if context!.hasChanges {
            do {
                try context?.save()
            } catch {
                let nsError = error as NSError
                print(nsError)
               
            }
        }

    }
    
    //Load Data from DB
    func loadDataFromDB(for request: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item") ) {
        
        //        let request: NSFetchRequest<Item> = Item.fetchRequest()
      
        do {
            listItemArray = try context!.fetch(request)
            
        } catch {
            print("Error fetching data with \(error)")
        }
        
    }
    
}
//MARK: - Search button functionality
extension ToDoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadDataFromDB(for: request)
        
        tableView.reloadData()
        
    }
}
