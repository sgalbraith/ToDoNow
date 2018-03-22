//
//  ViewController.swift
//  ToDoNow
//
//  Created by Scott P Galbraith on 3/10/18.
//  Copyright © 2018 SIBOC Sports, LLC. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController {
    
//    var itemArray = ["Create Crypto","Make Mead","iOS Class", "Acquire Land", "Gain a Business"]
    var todoItems: Results<Item>?
    let realm = try! Realm()
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
      //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadItems()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let colorHex = selectedCategory?.bgColor {
            
            title = selectedCategory?.name
            
            guard let navbar = navigationController?.navigationBar else {
                fatalError("Navigation Controller does not exist.")
            }
            
            if let navbarColor = UIColor(hexString: colorHex) {
            navbar.barTintColor = navbarColor
            searchBar.barTintColor = navbarColor
            navbar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor(contrastingBlackOrWhiteColorOn: navbarColor, isFlat:true)]
            navbar.tintColor = UIColor(contrastingBlackOrWhiteColorOn: navbarColor, isFlat:true)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let originalColor = UIColor.flatWhite() else {
            fatalError("No default color available")
        }
        navigationController?.navigationBar.barTintColor = originalColor
        navigationController?.navigationBar.tintColor = UIColor.flatBlack()
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.flatBlack()]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            
            if let color = UIColor(hexString: selectedCategory!.bgColor)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn:color, isFlat:true)
            }
            
            //ternary
            // value = condition ? valueIfTrue : valueIfFalse
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added yet"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    //realm.delete(item)
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status \(error)")
            }
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        // new alert controller
        let alert = UIAlertController(title: "Add New ToDo", message: "", preferredStyle: .alert)
        
        // action on alert controller
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        //newItem.bgColor = currentCategory.bgColor
                        currentCategory.items.append(newItem)
                    }
                } catch {
                        print("Error saving new item, \(error)")
                    }
                    
                }
                self.tableView.reloadData()
            }
        
        // add textfield to UIAlert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        }
    
    
    //if called without param,default is all items
    func loadItems() {

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        self.tableView.reloadData()
    }
    
    //MARK: - Delete Data from Model
    override func updateModel(at indexPath: IndexPath) {
        if let item = self.todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(item)
                    
                }
            } catch {
                print("Error deleting List Item \(error)")
            }
        }
    }
    
}

//MARK: - Search Bar Methods

extension ToDoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[CD] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }


        }
    }

}

