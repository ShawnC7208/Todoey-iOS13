
import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var toDoItems = [ToDoList]()
    var selectedCategory: ToDoCategory? {
        didSet {
            loadData()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //File patch for local storage on device
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        searchBar.delegate = self
    }
    
    //MARK: - Table view delegate for number of rows in table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems.count
    }
    
    //MARK: - Table view delegate for items in each cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = toDoItems[indexPath.row].toDoListItemName
        
        //Swift ternary -  Value = Condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = toDoItems[indexPath.row].checked == true ? .checkmark : .none
        return cell
    }
    
    //MARK: - Table view delegate for when cell row is clicked
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        toDoItems[indexPath.row].checked = !toDoItems[indexPath.row].checked
        saveData()
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
                let newItem = ToDoList(context: self.context)
                newItem.toDoListItemName = safeString
                newItem.checked = false
                newItem.parentCategory = self.selectedCategory
                self.toDoItems.append(newItem)
                self.saveData()
            }
        }
        //Add the action to our alert
        alert.addAction(action)
        //Present our alert
        present(alert, animated: true, completion: nil)
    }
    //Save to local storage
    func saveData() {
        do {
            try self.context.save()
        } catch {
            print("error saving context: \(error)")
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func loadData(with request: NSFetchRequest<ToDoList> = ToDoList.fetchRequest(), predicate: NSPredicate? = nil) {
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES[cd] %@", selectedCategory!.name!)

        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }
        else {
            request.predicate = categoryPredicate
        }
        
        do {
            toDoItems = try context.fetch(request)
        }
        catch {
            print("error fetching context: \(error)")
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

//MARK: - Search bar delegate
extension ToDoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<ToDoList> = ToDoList.fetchRequest()
        let predicate = NSPredicate(format: "toDoListItemName CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "toDoListItemName", ascending: true)]
        loadData(with: request, predicate: predicate)
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

