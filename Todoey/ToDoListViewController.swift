import UIKit

class ToDoListViewController: UITableViewController {
    
   
    var listItemArray = [Item]()
    var dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let navigationBarAppearance = UINavigationBarAppearance()
        
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationBarAppearance.backgroundColor = .systemBlue
        
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        
        loadDataFromDB()
    }

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
        writeDataToDB(for: listItemArray)
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadRows(at: [indexPath], with: .none)
        
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
                self.listItemArray.append(Item(for: coelText))
            
                self.writeDataToDB(for: self.listItemArray)
                self.tableView.reloadData()
            }
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
    func writeDataToDB(for items: [Item]) {
        
        let encoder = PropertyListEncoder()
        
        do {
          let encodedData = try encoder.encode(items)
            try encodedData.write(to: dataFilePath!)
        } catch {
            print("Failure encoding error \(error)")
        }
        
    }
    
    func loadDataFromDB() {
        
        
        if let coelData = try? Data(contentsOf: dataFilePath!) {
            
            let decoder = PropertyListDecoder()
            
            do {
                listItemArray = try decoder.decode([Item].self, from: coelData)
            } catch {
                print("Unable to load data \(error)")
            }
        
        }
    }
    
    
    
}

