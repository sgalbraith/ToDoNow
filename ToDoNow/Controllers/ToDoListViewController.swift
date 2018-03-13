//
//  ViewController.swift
//  ToDoNow
//
//  Created by Scott P Galbraith on 3/10/18.
//  Copyright © 2018 SIBOC Sports, LLC. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
//    var itemArray = ["Create Crypto","Make Mead","iOS Class", "Acquire Land", "Gain a Business"]
    var itemArray = [Item]()
    
    // user defaults
   // let defaults = UserDefaults.standard
    //global datafile path
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        print(dataFilePath)
        
        
        loadItems()
        
//        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
//            itemArray = items
//        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //ternary
        // value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done ? .checkmark : .none
        
        
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
//        cell.addGestureRecognizer(tapGesture)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped: \(indexPath.row)")
        print("The title of the row clicked is \(itemArray[indexPath.row].title)")
        
        //if selected again (already has a checkmark), remove checkmark
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }
//        // otherwise add checkmark
//        else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Declare tableViewTapped here:
//    @objc func tableViewTapped() {
//        print("You tapped it")
 //   }
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        // new alert controller
        let alert = UIAlertController(title: "Add New ToDo", message: "", preferredStyle: .alert)
        
        // action on alert controller
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            // what will happen once the user clicks the Add Item button on the UIAlert
            
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            print("You entered: \(newItem)")
            
            self.saveItems()
            
//            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            
        }
        // add textfield to UIAlert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
            
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        }
    
    //Mark = Model Manipuation Methods
    
    func saveItems()  {
        
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
        self.tableView.reloadData()
    }
    
   func loadItems() {
    if let data = try? Data(contentsOf: dataFilePath!) {
        let decoder = PropertyListDecoder()
        do {
            itemArray = try decoder.decode([Item].self, from: data)
        } catch {
            print("Error decoding item, \(error)")
        }
    }
    
    
    }
    
}

