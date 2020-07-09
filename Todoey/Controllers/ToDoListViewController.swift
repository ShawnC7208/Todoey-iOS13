
import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    let realm = try! Realm()
    
    var toDoItems: Results<ToDoList>?
    var selectedCategory: ToDoCategory? {
        didSet {
            loadData()
        }
    }
    
    //File patch for local storage on device
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        searchBar.delegate = self
    }
    
    //MARK: - Table view delegate for number of rows in table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    //MARK: - Table view delegate for items in each cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.toDoListItemName
            //Swift ternary -  Value = Condition ? valueIfTrue : valueIfFalse
            cell.accessoryType = item.checked == true ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added"
        }
        
        return cell
    }
    
    //MARK: - Table view delegate for when cell row is clicked
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.checked = !item.checked
                }
            } catch {
                print("Error saving done status")
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Item action button pressed
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        //Add Alert pop up
        let alert = UIAlertController(title: "Add new ToDoey Item", message: "", preferredStyle: .alert)
        //Add a TextField to our alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
        }
        //Create Action which is a "button" or item that executes when clicked
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let safeString = textField.text {
                
                if let currentCategory = self.selectedCategory {
                    do {
                        try self.realm.write {
                            let newItem = ToDoList()
                            newItem.toDoListItemName = safeString
                            newItem.checked = false
                            newItem.dateCreated = Date()
                            currentCategory.toDoList.append(newItem)
                        }
                    }
                    catch {
                        print("error saving list item: \(error)")
                    }
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        //Add the action to our alert
        alert.addAction(action)
        //Present our alert
        present(alert, animated: true, completion: nil)
    }
    
    func loadData() {
        toDoItems = selectedCategory?.toDoList.sorted(byKeyPath: "toDoListItemName", ascending: true)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

//MARK: - Search bar delegate
extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        toDoItems = toDoItems?
            .filter("toDoListItemName CONTAINS[cd] %@", searchBar.text!)
            .sorted(byKeyPath: "toDoListItemName", ascending: true)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

