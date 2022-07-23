//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Andres Court on 20/7/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categoriesResults: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadCategories()
    }
    
    //MARK: - Delete Data from Swipe
    override func updateModel(at indexPath: IndexPath) {
        if let categoryToDelete = self.categoriesResults?[indexPath.row]{
            do {
                try self.realm.write({
                    self.realm.delete(categoryToDelete)
                })
            } catch {
                print("Error deleting category, \(error)")
            }
        }
    }
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: K.categoryAlert.title, message: K.categoryAlert.message, preferredStyle: .alert)
        alert.addTextField { alertTextField in
            alertTextField.placeholder = K.categoryAlert.placeholder
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: K.todoeyAlert.action, style: .default) { action in
            //            what will happen once the user clicks the Add Item button on our UIAlert
            if textField.text == ""{
                return
            }
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.save(category: newCategory)
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.categoriesResults?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categoriesResults?[indexPath.row].name ?? "No Categories Added yet"
        
        return cell
    }
    
    //MARK: - Table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.categoryView.goToItems, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoriesResults?[indexPath.row]
        }
    }
    
    //MARK: - Data manipulation methods
    
    func loadCategories(){
        categoriesResults = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    func save(category: Category){
        do{
            try realm.write({
                realm.add(category)
            })
        } catch {
            print("Error saving category \(error)")
        }
        self.tableView.reloadData()
    }
}


