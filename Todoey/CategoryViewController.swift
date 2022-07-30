//
//  TableViewController.swift
//  Todoey
//
//  Created by Axel Hil on 6/07/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: SwipeTableViewController {
    
    let localRealm = try! Realm()
    
    var categories: Results<CategoryItem>?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    
        loadDataFromDB()
       
    }

    // MARK: - Table view data source
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return categories?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        var content = cell.contentConfiguration as! UIListContentConfiguration
        
        content.text = categories?[indexPath.row].title ?? "No Category Added Yet"
        
        cell.contentConfiguration = content
        
        return cell
        
    }
    
    //MARK: - Segue setup
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        performSegue(withIdentifier: "ToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let indexPath = tableView.indexPathForSelectedRow {

            let destinationVC = segue.destination as! ToDoListViewController

            destinationVC.selectedCategory = categories?[indexPath.row]
        }

    }
    
    // MARK: - Add new category button

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add New Category", message: nil, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Category Item"
        }
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            
            if alert.textFields![0].text != "" {
                
                let newCategoryItem = CategoryItem()
                
                newCategoryItem.title = alert.textFields![0].text
                
                self.writeDataToDB(newCategoryItem)
                
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
    

    //MARK: - CRUD Database Setup
    func writeDataToDB(_ category: CategoryItem) {
        try! localRealm.write({
            localRealm.add(category)
        })
    }
    
    func loadDataFromDB() {
        categories = localRealm.objects(CategoryItem.self)
    }
    
    override func destroy(at indexPath: IndexPath) {
        
        try! self.localRealm.write({
            self.localRealm.delete(self.categories![indexPath.row].items)
            self.localRealm.delete(self.categories![indexPath.row])
            
        })
        
    }
    
}
