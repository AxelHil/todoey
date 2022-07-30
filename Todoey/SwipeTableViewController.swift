//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Axel Hil on 26/07/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0
        
        //Navigation Bar Setup
        
        let navigationBarAppearance = UINavigationBarAppearance()

        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationBarAppearance.backgroundColor = .systemBlue

        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        
       
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
        
        cell.delegate = self
        
        cell.contentConfiguration = cell.defaultContentConfiguration()
        
        return cell
        
    }
   
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
            self.destroy(at: indexPath)
            
        }

        deleteAction.image = UIImage(named: "delete-icon2")

        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        
            var options = SwipeOptions()
        
            options.expansionStyle = .destructive
   
            return options
        }
    
    
    func destroy(at indexPath: IndexPath) {
        
    }

  
}
