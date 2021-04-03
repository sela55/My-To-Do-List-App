//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Sela Shabtai on 18/12/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import ChameleonFramework

class CategoryViewController:  SwipeTableViewController {
    
    let realm = try! Realm();
    
    //    var categories = [Category](); made for core Data
    
    var categories : Results<CategoryRealm>?
    
    //    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext; // relevant for core data
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        tableView.separatorStyle = .none;
        
        //        loadItems();
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        configureNavigationBar(largeTitleColor: .white, backgoundColor: .systemBlue, tintColor: .white, title: "Home", preferredLargeTitle: true);
        
        
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath);
        //
        //        let category = categories?[indexPath.row];
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath);
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added";
        
        //        print(UIColor.randomFlat().hexValue())
        
        
        
        cell.backgroundColor = UIColor(hexString: categories![indexPath.row].cellColor);
        
        
        
        return cell;
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self);
        tableView.deselectRow(at: indexPath, animated: true);

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let safeIndexPath = tableView.indexPathForSelectedRow {
            
            destinationVC.selectedCategory = categories?[safeIndexPath.row]
            
        }
    }
    
    //    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //        if editingStyle == UITableViewCell.EditingStyle.delete {
    //            deleteItem(selectedIndexToDelete: indexPath);
    ////            categories.remove(at: indexPath.row) // relevant only for core data
    //            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
    //        }
    //    }
    
    //MARK: - Add New Item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a new Category", message: "", preferredStyle: .alert);
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil);
        let action = UIAlertAction(title: "Add Category", style: .default, handler:  { (action) in
            if let safeCategory = textField.text // make sure its not nil
            {
                if safeCategory.isEmpty == false // make sure its not an empty text...
                {
                    //                    let newCategory = Category(context: self.context); // making new NSObject for core data
                    
                    let newCategory = CategoryRealm();
                    
                    newCategory.name = safeCategory;
                    newCategory.cellColor = UIColor.randomFlat().hexValue()
                    //                    self.categories.append(newCategory); //relevant only for core data
                    
                    self.saveItems(category: newCategory);
                }
            }
        })
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category";
            textField = alertTextField;
        }
        
        alert.addAction(cancel);
        alert.addAction(action);
        
        present(alert, animated: true, completion: nil);
    }
    
    
    //Mark: - Data Manipulation Methods
    
    func saveItems(category: CategoryRealm)  {
        do {
            //            try context.save(); // save method with core data, no paramater in the function is required
            try realm.write{
                realm.add(category)
                //                realm.add(category) //save method with realm
            }
        } catch  {
            print("Error saving item context \(error)");
        }
        
        tableView.reloadData();
        
    }
    
    func loadCategories() {
        categories = realm.objects(CategoryRealm.self)
        
        tableView.reloadData()
    }
    
    //    func loadItems(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
    //        do {
    //            categories = try context.fetch(request);
    //        } catch {
    //            print("Error loading item context \(error)");
    //        }
    //
    //        tableView.reloadData();
    //    }
    //MARK: - Delete Data From Swipe
    override func updateModel(at indexPath: IndexPath) {
        
        if let item = self.categories?[indexPath.row] {
            do{
                try realm.write{
                    realm.delete(item)
                }
            }
            catch {
                print("Error deleting category, \(error)");
            }
        }
    }
    
    func deleteItem(selectedIndexToDelete indexPath : IndexPath) {
        
        //        context.delete(categories[indexPath.row])
        //        saveItems()
        
    }
    
    
}

