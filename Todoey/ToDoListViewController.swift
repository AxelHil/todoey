import UIKit

class ToDoListViewController: UITableViewController {
    
    var listItemArray = ["ToDoItem1", "ToDoItem2", "ToDoItem3"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navigationBarAppearance = UINavigationBarAppearance()
        
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationBarAppearance.backgroundColor = .systemBlue
        
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        
        // Do any additional setup after loading the view.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItemArray.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListItemCell")
        var content = cell?.defaultContentConfiguration()
        
        content?.text = listItemArray[indexPath.row]
        
        cell?.contentConfiguration = content
        
        return cell!

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.cellForRow(at: indexPath)?.accessoryType = tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark ? .none : .checkmark
       
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add New Item", message: nil, preferredStyle: .alert)
        
        alert.addTextField {
            textField in
            textField.placeholder = "ToDo Item"
        }
        
        let action = UIAlertAction(title: "Add Item", style: .default) {
            action in
            
            
            if let coelText = alert.textFields?[0].text {
                self.listItemArray.append(coelText)
                
                self.tableView.reloadData()
            }
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
}

