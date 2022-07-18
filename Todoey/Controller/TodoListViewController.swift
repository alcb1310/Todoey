//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    var itemsArray: [Item] = []
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(K.itemsPListFile)
    
    //    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do {
                try itemsArray = decoder.decode([Item].self, from: data)
            } catch {
                print(error)
            }
        }
        
        //        if let items = userDefaults.array(forKey: K.userDefaultsKey) as? [Item]{
        //            itemsArray = items
        //        }
    }
    
    func saveItems() {
        //            self.itemsArray.append(textField.text!)
        //            self.userDefaults.set(self.itemsArray, forKey: K.userDefaultsKey)
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(self.itemsArray)
            try data.write(to: self.dataFilePath!)
        } catch {
            print("Error encoding item array \(error)")
        }
    }
    
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itemsArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath)
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        saveItems()
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemsArray[indexPath.row].done = !itemsArray[indexPath.row].done
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: K.todoeyAlert.title, message: K.todoeyAlert.message, preferredStyle: .alert)
        alert.addTextField { alertTextField in
            alertTextField.placeholder = K.todoeyAlert.placeholder
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: K.todoeyAlert.action, style: .default) { action in
            //            what will happen once the user clicks the Add Item button on our UIAlert
            if textField.text == ""{
                return
            }
            
            let newItem = Item()
            newItem.title = textField.text!
            self.itemsArray.append(newItem)
            
            self.saveItems()
            self.tableView.reloadData()
            //            This was my soluition
            //            if let newTodoItem = alert.textFields?[0].text {
            //                print(newTodoItem)
            //            }
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}


