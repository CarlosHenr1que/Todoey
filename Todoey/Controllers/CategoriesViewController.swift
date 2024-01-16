//
//  CategoriesViewController.swift
//  Todoey
//
//  Created by Carlos Henrique Matos Borges on 14/01/24.
//

import UIKit

class CategoriesViewController: UITableViewController {
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }
    
    func createAddItemAlert() -> UIAlertController {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
            if let safeTitle = textField.text {
                if(!safeTitle.isEmpty) {
                    let newCategory = Category(context: self.context)
                    newCategory.name = textField.text
                    self.categories.append(newCategory)
                    self.saveCategories()
                    self.tableView.reloadData()
                }

            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        return alert
    }
    
    func loadItems() {
        let request = Category.fetchRequest()
        do {
            categories = try context.fetch(request)
            tableView.reloadData()
        } catch {
            print("Error while fething categories")
        }
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        present(createAddItemAlert(), animated: true)
    }
    
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error saving category \(error)")
        }
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
       
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryReusableCell", for: indexPath)
        let currentItem = categories[indexPath.row]
        cell.textLabel?.text = currentItem.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ItemsTableViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destination.selectedCategory = categories[indexPath.row]
        }
    }

}
