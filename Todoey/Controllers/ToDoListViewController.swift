
import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = ["Run vac", "Mop", "Clean Bathroom", "Do Laundry"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Table view delegate for number of rows in table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK: - Table view delegate for items in each cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    //MARK: - Table view delegate for when cell row is clicked
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Item action button pressed
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //Add Alert pop up
        let alert = UIAlertController(title: "Add new ToDoey Item", message: "", preferredStyle: .alert)
        //Add a TextField to our alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
        }
        //Create Action which is a "button" or item that executes when clicked
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //Get text fields array
            if let textField = alert.textFields {
                //Get text from first and only text field
                if let safeText = textField[0].text {
                    //Add text field to array and reload table view
                    self.itemArray.append(safeText)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
        //Add the action to our alert
        alert.addAction(action)
        //Present our alert
        present(alert, animated: true, completion: nil)
    }
    
}

