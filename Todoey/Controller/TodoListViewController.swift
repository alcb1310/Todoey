//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let colorHex = selectedCategory?.color{
            title = selectedCategory!.name
            guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist")}
            guard let navBarTintColor = UIColor(hexString: colorHex) else {fatalError("Color not valid")}
            
            navBar.backgroundColor = navBarTintColor
            searchBar.barTintColor = navBarTintColor
            navBar.tintColor = ContrastColorOf(navBarTintColor, returnFlat: true)
            navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navBarTintColor, returnFlat: true)]
        }
    }
    
    //MARK: - Delete Data from Swipe
    override func updateModel(at indexPath: IndexPath) {
        if let todoItemToDelete = self.todoItems?[indexPath.row]{
            do {
                try self.realm.write({
                    self.realm.delete(todoItemToDelete)
                })
            } catch {
                print("Error deleting item, \(error)")
            }
        }
    }
    
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = todoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)){
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.boldSystemFont(ofSize: 20)
                ]
                let attributedString = NSAttributedString(string: cell.textLabel!.text!, attributes: attributes)
                cell.textLabel?.attributedText = attributedString
            }
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write({
                    item.done = !item.done
                })
            } catch {
                print("Error saving done status, \(error)")
            }
        }
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
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write({
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    })
                } catch {
                    print("Error saving new item, \(error)")
                }
            }
            
            self.tableView.reloadData()
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func loadItems(){
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
}

//MARK: - Search bar methods

extension TodoListViewController: UISearchBarDelegate{

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request, predicate: predicate)
//
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
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
