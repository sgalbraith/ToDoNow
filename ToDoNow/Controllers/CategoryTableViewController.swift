//
//  CategoryTableViewController.swift
//  ToDoNow
//
//  Created by Scott P Galbraith on 3/15/18.
//  Copyright © 2018 SIBOC Sports, LLC. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryTableViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
        
        navigationController?.navigationBar.barTintColor = UIColor.flatWhite()
        navigationController?.navigationBar.tintColor = UIColor.flatBlack()
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.flatBlack()]

    }
       
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        
        if let color = UIColor(hexString: categories?[indexPath.row].bgColor ?? "1D9BF6") {
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories added yet"
        cell.backgroundColor = color
        cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn:color, isFlat:true)
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows
        return categories?.count ?? 1
    }
    
    
    
    
    //MARK: - Data Manipulation Methods
    
     func loadCategories() {
    
        categories = realm.objects(Category.self).sorted(byKeyPath: "name", ascending: true)
        
    }
    
    func save(category: Category)  {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
        self.tableView.reloadData()
    }

    //MARK: - Delete Data from Model
    override func updateModel(at indexPath: IndexPath) {
        if let item = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(item)

                }
            } catch {
                print("Error deleting Category \(error)")
            }
        }
    }

    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        // new alert controller
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        // action on alert controller
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            // what will happen once the user clicks the Add Category button on the UIAlert
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.bgColor = UIColor(randomFlatColorOf:.light).hexValue()
            
            self.save(category: newCategory)
            
            
        }
        // add textfield to UIAlert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a new category"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
//MARK: - TabelView Delegate Methods (waht happens when you click on a table item)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
}


