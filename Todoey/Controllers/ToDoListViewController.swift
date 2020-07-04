
import UIKit

class ToDoListViewController: UITableViewController {

    var toDoItems = [
        ToDoList("Run vac", false),
        ToDoList("Mop", false),
        ToDoList("Clean Bathroom", false),
        ToDoList("Do Laundry", false),
        ToDoList("Mop", false)
    ]
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let items = defaults.array(forKey: "ToDoListArray") as? [ToDoList] {
            toDoItems = items
        }
    }
    
    //MARK: - Table view delegate for number of rows in table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems.count
    }
    
    //MARK: - Table view delegate for items in each cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = toDoItems[indexPath.row].ToDoListItemName
        
        //Swift ternary -  Value = Condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = toDoItems[indexPath.row].Checked == true ? .checkmark : .none
        return cell
    }
    
    //MARK: - Table view delegate for when cell row is clicked
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        toDoItems[indexPath.row].Checked = !toDoItems[indexPath.row].Checked
        
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
                self.toDoItems.append(ToDoList(safeString, false))
                self.defaults.set(self.toDoItems, forKey: "ToDoListArrary")
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
    
}

