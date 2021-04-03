//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import ChameleonFramework;

class TodoListViewController:  SwipeTableViewController{
    @IBOutlet weak var navBarTitle: UINavigationItem!
    
    @IBOutlet var searchBar: UISearchBar!
    //    var itemArray = [Item](); // madeForCoreData
    var toDoItems : Results<ItemRealm>?
    let realm = try! Realm();
    
    var selectedCategory : CategoryRealm?
    {
        didSet{
            loadRealmItems()
        }
    }
    
    
    //    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist"); // path for codable
    //    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext; // madeForCoreData
    
    
    
    //    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self;
        tableView.separatorStyle = .none;
        
//        navBarTitle.title = "My " + String((selectedCategory?.name.capitalized)!);
//
//        navigationController?.navigationBar.barTintColor = UIColor(hexString: selectedCategory!.cellColor)
//        navigationController?.navigationBar.backgroundColor = UIColor(hexString: selectedCategory!.cellColor)
//
//        navigationController?.navigationBar.tintColor = ContrastColorOf(UIColor(hexString: selectedCategory!.cellColor)!, returnFlat: true)
        
      
        
        
        //        tableView.delegate = self;
        // Do any additional setup after loading the view.
        
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask));
        
        //        loadItems();
        
        //        let item1 = Item();
        //        item1.title = "JimJim";
        //        itemArray.append(item1);
        //
        //        let item2 = Item();
        //        item2.title = "JeffJeff";
        //        itemArray.append(item2);
        //
        //        let item3 = Item();
        //        item3.title = "IdanDan"
        //        itemArray.append(item3);
        
        //        loadItems();
        //        if let items = defaults.array(forKey: "friendsListArray") as? [Item ] {
        //            itemArray = items;
        //        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let safeColorHex = selectedCategory?.cellColor {

            guard (navigationController?.navigationBar) != nil else {fatalError("Navigation controller does not exist")}
                
            configureNavigationBar(largeTitleColor: .white, backgoundColor: UIColor(hexString: safeColorHex)!, tintColor: ContrastColorOf(UIColor(hexString: safeColorHex)!, returnFlat: true), title: "My " + String((selectedCategory?.name.capitalized)!), preferredLargeTitle: true)
                
            

//            navBar.backgroundColor  = UIColor(hexString: safeColorHex);
//            navBar.barTintColor = UIColor(hexString: safeColorHex);
//            searchBar.barTintColor = UIColor(hexString: safeColorHex);
            
            
            
        }
    }
    
    //MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath);
        
        
        //let message = itemArray[indexPath.row];
        
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath);
        
        if let item = toDoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title;
    
            if let safeColor = UIColor(hexString: selectedCategory!.cellColor)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(toDoItems!.count))
            {
                cell.backgroundColor = safeColor;
                cell.textLabel?.textColor = ContrastColorOf(safeColor, returnFlat: true);

                
            }
            
            cell.accessoryType = item.done == true ? .checkmark : .none;
        } else {
            cell.textLabel?.text = "No items added";
        }
        
        //        if item.done == true
        //        {
        //            cell.accessoryType = .checkmark;
        //        }else
        //        {
        //            cell.accessoryType = .none;
        //        }
        
        return cell;
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row] {
            do{
                try realm.write{
                    item.done = !item.done;
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        tableView.reloadData();
        
        //        toDoItems?[indexPath.row].done = !(toDoItems[indexPath.row].done);
        //        saveItems();
        
        
        tableView.deselectRow(at: indexPath, animated: true);
        
    }
    
    //    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    
    //
    ////            deleteItem(selectedIndexToDelete: indexPath); //usefull for coredata
    ////            itemArray.remove(at: indexPath.row)
    //            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
    //
    //        }
    //    }
    
    //MARK: - Add New Item
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField();
        
        let alert = UIAlertController(title: "Add New friend Item", message: "", preferredStyle: .alert);
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil);
        
        let action = UIAlertAction(title: "Add Friend", style: .default, handler: { (action) in
            if let realFriend = textField.text
            {
                if realFriend.isEmpty == false
                {
                    //                    let newItem = Item(); //for codable solution: not relavent for CoreData
                    
                    //                    let newItem = Item(context: self.context);
                    //
                    //                    newItem.title = textField.text!;
                    //                    newItem.done = false;
                    //                    newItem.parentCategory = self.selectedCategory;
                    //
                    //                    self.itemArray.append(newItem);
                    if let currentCategory = self.selectedCategory{
                        do{
                            try self.realm.write{
                                let newRealmItem = ItemRealm();
                                newRealmItem.title = realFriend.capitalized
                                newRealmItem.dateCreated = Date()
                                currentCategory.items.append(newRealmItem);
                                
                                //                                newRealmItem.dateCreated = dateTimeString;
                                
                                //                            self.realm.add(newRealmItem);
                            }
                        }catch{
                            print("couldn't add realm item")
                        }
                        self.tableView.reloadData();
                    }
                    
                    //                    newRealmItem.parentCategory = self.selectedCategory.;             
                    //                    self.saveItems() only valid to core data
                    //                    self.defaults.set(self.itemArray, forKey: "friendsListArray");
                }
            }
        })
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new friend";
            textField = alertTextField;
        }
        
        alert.addAction(cancel);
        alert.addAction(action);
        
        
        present(alert, animated: true, completion: nil);
        
    }
    
    //    func saveItems() {
    ////        let encoder = PropertyListEncoder();
    //
    //        do{
    ////            let data = try encoder.encode(itemArray);
    ////            try data.write(to: dataFilePath!);
    //
    //           try context.save()
    //
    //        } catch {
    ////            print("Error encoding item array \(error)");
    //            print("Error saving item context \(error)");
    //        }
    //
    //        tableView.reloadData();
    //    }
    
    //    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
    //
    //        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
    //
    //        if let additionalPredicate = predicate {
    //            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate , additionalPredicate]);
    //        } else {
    //            request.predicate = categoryPredicate;
    //        }
    //
    //
    //        //method to load data from CoreData data type
    //
    //        do{
    //            itemArray = try context.fetch(request);
    //        }
    //        catch {
    //            print("Error loading item context \(error)");
    //
    //        }
    //
    //        tableView.reloadData();
    //
    //        //    method to load data from Codable data type
    //        //        if let data = try? Data(contentsOf: dataFilePath!) {
    //        //            let decoder = PropertyListDecoder();
    //        //            do{
    //        //            itemArray = try decoder.decode([Item].self, from: data);
    //        //            } catch {
    //        //                print("Error decoding item array \(error)");
    //        //            }
    //        //        }
    //
    //    }
    
    func loadRealmItems() {
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true);
    }
    
    func deleteItem(selectedIndexToDelete indexPath : IndexPath) {
        
        //        context.delete(itemArray[indexPath.row])
        //        saveItems()
        
    }
    //
    //MARK: - Delete Data From Swipe
    override func updateModel(at indexPath: IndexPath) {
        if let item = self.toDoItems?[indexPath.row] {
            do{
                try realm.write {
                    realm.delete(item)
                }
            }catch{
                print("Error deleting item, \(error)");
            }
        }
    }
    
    
}




//MARK: - Serch bar methods

extension TodoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        
        
        
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true);
        
        
        
        //        let request : NSFetchRequest<Item> = Item.fetchRequest();
        //
        //        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!);
        //
        //        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        //
        //        loadItems(with: request, predicate: predicate );
        
        //        request.sortDescriptors = [sortDescriptor];
        
        //        do{
        //            itemArray = try context.fetch(request);
        //        }
        //        catch {
        //            print("Error loading item context \(error)");
        //        }
        
        tableView.reloadData();
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            
            loadRealmItems();
            
            //            loadItems();
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder();
            }
            
        }
    }
}


extension UIViewController {
func configureNavigationBar(largeTitleColor: UIColor, backgoundColor: UIColor, tintColor: UIColor, title: String, preferredLargeTitle: Bool) {
    if #available(iOS 13.0, *) {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: largeTitleColor]
        navBarAppearance.titleTextAttributes = [.foregroundColor: largeTitleColor]
        navBarAppearance.backgroundColor = backgoundColor

        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.compactAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance

        navigationController?.navigationBar.prefersLargeTitles = preferredLargeTitle
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = tintColor
        navigationItem.title = title

    } else {
        // Fallback on earlier versions
        navigationController?.navigationBar.barTintColor = backgoundColor
        navigationController?.navigationBar.tintColor = tintColor
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.title = title
    }
}}
