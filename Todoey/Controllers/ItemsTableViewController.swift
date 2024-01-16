//
//  ItemsTableViewController.swift
//  Todoey
//
//  Created by Carlos Henrique Matos Borges on 13/01/24.
//

import UIKit
import CoreData

class ItemsTableViewController: UITableViewController {
    var items = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let addtionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addtionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            items = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    func createAddItemAlert() -> UIAlertController {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let safeTitle = textField.text {
                if(!safeTitle.isEmpty) {
                    let newItem = Item(context: self.context)
                    newItem.title = textField.text
                    newItem.done = false
                    newItem.parentCategory = self.selectedCategory
                    self.items.append(newItem)
                    self.saveItems()
                }

            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        return alert
    }
    
    func saveItems() {
        do {
          try context.save()
        } catch {
           print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        present(createAddItemAlert(), animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
       
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemsReusableCell", for: indexPath)
        let currentItem = items[indexPath.row]
        cell.textLabel?.text = currentItem.title
        cell.accessoryType = currentItem.done ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentItem = items[indexPath.row]
        let currentCell = tableView.cellForRow(at: indexPath)
        currentItem.done = !currentItem.done
        currentCell?.accessoryType = currentItem.done ? .checkmark : .none
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
