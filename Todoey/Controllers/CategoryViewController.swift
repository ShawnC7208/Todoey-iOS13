//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Shawn Chandwani on 7/7/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    var categories: Results<ToDoCategory>?
    
    //File patch for local storage on device
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories added yet"
        return cell
    }
    
    //MARK: - Table View Delegates
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        //Add Alert pop up
        let alert = UIAlertController(title: "Add new Category Item", message: "", preferredStyle: .alert)
        //Add a TextField to our alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Category"
            textField = alertTextField
        }
        //Create Action which is a "button" or item that executes when clicked
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            if let safeString = textField.text {
                let newItem = ToDoCategory()
                newItem.name = safeString
                self.save(category: newItem)
            }
        }
        //Add the action to our alert
        alert.addAction(action)
        //Present our alert
        present(alert, animated: true, completion: nil)
    }
    
    //Save to local storage
    func save(category: ToDoCategory) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("error saving category: \(error)")
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func loadData() {
        categories = realm.objects(ToDoCategory.self)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
