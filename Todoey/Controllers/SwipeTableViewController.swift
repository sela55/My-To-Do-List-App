//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Sela Shabtai on 19/01/2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit

class SwipeTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 100;
    }
        

    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let message = itemArray[indexPath.row];
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath);
        

        return cell;
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        
        if editingStyle == UITableViewCell.EditingStyle.delete {
            updateModel(at: indexPath);

            print("DeleteCell")
            }
            
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            
        }
    
    func updateModel(at indexPath: IndexPath) {
        //Update Our Data Model
    }
    }
    



