//
//  ViewController.swift
//  Toodoo
//
//  Created by Bhushan Joshi on 2018-07-11.
//  Copyright © 2018 Bhushan Joshi. All rights reserved.
//

import UIKit

class ToodooViewController: UITableViewController {

    var itemArray = [Item]()
    let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //to check for the userDefaults and update the item array. i.e set item arrays value to that in defaults.
//        if let items = defaults.array(forKey: "ToDoListArray") as? [String]{
//            itemArray = items
//        }
        print(dataFilePath)
        loadData()
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
         // Dispose of any resources that can be recreated.
    }
    
    
    //MARK - TABLEVIEW DATASOURCE METHODS
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TooDooItemCell", for: indexPath)
        
        
        let item = itemArray[indexPath.row]
        
        
        cell.textLabel?.text = item.itemTitle
        
        
        //ternary operator
        //value = condition? : valueifTrue : valueifFalse
        
        cell.accessoryType = item.itemDone == true ? .checkmark : .none
        //OR
        //cell.accessoryType = item.itemDone ? .checkmark : .none
        
//        if item.itemDone == true{
//            cell.accessoryType = .checkmark
//        }
//        else{
//            cell.accessoryType = .none
//        }
        
        return cell
    }
    
    
    //MARK - TABLEVIEW DELEGATE METHODS

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //keep the row de selected so it looks good
        tableView.deselectRow(at: indexPath, animated: true)
        //add checkmark and remove if already added.
        
        
        itemArray[indexPath.row].itemDone = !itemArray[indexPath.row].itemDone
        
        //now we are using models for checking the accesory type.
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
//           tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }
//        else{
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        
        saveItem()
    }
    
    //MARK - ADD NEW ITEMS
    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        let alert =  UIAlertController(title: "Add New Todoo Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add new Item", style: .default) { (action) in
            //what will happen when user clicks the + button .
            
            let newAddedItem = Item()
            newAddedItem.itemTitle = textField.text!
            
            self.itemArray.append(newAddedItem)
            
            
//          self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            
        self.saveItem()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    //MARK - Model Manupulation Methods i.e ENCODING AND DECODING THE DATA FROM ITEM.PLIST.
    func saveItem() {
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
            
        }
        catch{
            print("Error encoding item array \(error)")
        }
        
        
        self.tableView.reloadData()
    }
    
    func loadData() {
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
            try itemArray = decoder.decode([Item].self, from: data)
            }
            catch{
                print("Error decoding item array \(error)")
            }
        }
        
        
        
    }
    
    
}

