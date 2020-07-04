
import UIKit

class ToDoListViewController: UITableViewController {

    var toDoItems = [ToDoList]()
    
    //File patch for local storage on device
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
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
                self.toDoItems.append(ToDoList(safeString, false))
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
        let encoder = PropertyListEncoder()
        do {
            //Encode the to do items using PropertyListEncoder
            let data = try encoder.encode(toDoItems)
            //Wirite encoded data to file path
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding data \(error)")
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func loadData() {
        let decoder = PropertyListDecoder()
        do {
            //Get contents of locally stored file as Data type
            if let data = try? Data(contentsOf: dataFilePath!) {
                //Decode data using PropertyListDecoder into object\
                toDoItems = try decoder.decode([ToDoList].self, from: data)
            }
        } catch {
            print("Error encoding data \(error)")
        }
    }
}

