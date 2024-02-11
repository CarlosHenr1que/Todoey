//
//  CategoriesViewController.swift
//  Todoey
//
//  Created by Carlos Henrique Matos Borges on 14/01/24.
//

import UIKit
import SwipeCellKit
import ChameleonFramework
import RealmSwift

class CategoriesViewController: SwipeTableViewController {
    var categories: Results<Category>?
    let realm = try! Realm()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        tableView.separatorStyle = .none
        print(Realm.Configuration.defaultConfiguration.fileURL)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let backgroundColor = UIColor.link
        navigationController?.navigationBar.backgroundColor = backgroundColor
        setStatusBarColor(backgroundColor)
    }
    
    func setStatusBarColor(_ color: UIColor) {
        if #available(iOS 13.0, *) {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first else {
                return
            }
            
            let statusBar = UIView(frame: windowScene.statusBarManager?.statusBarFrame ?? CGRect.zero)
            statusBar.backgroundColor = color
            window.addSubview(statusBar)
        } else {
            UIApplication.shared.statusBarStyle = preferredStatusBarStyle
        }
    }
       
    func createAddItemAlert() -> UIAlertController {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
            if let safeTitle = textField.text {
                if(!safeTitle.isEmpty) {
                    let newCategory = Category()
                    newCategory.name = textField.text!
                    newCategory.color = UIColor.randomFlat().hexValue()
                    self.saveCategories(category: newCategory)
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
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        present(createAddItemAlert(), animated: true)
    }
    
    func saveCategories(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let currentCategory = categories?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(currentCategory)
                }
                tableView.reloadData()
            } catch {
                print("Error deleting category")
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 0
    }
           
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let currentItem = categories![indexPath.row]
        cell.textLabel?.text = currentItem.name
        let color = UIColor(hexString: currentItem.color)!
        cell.backgroundColor = color
        cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ItemsTableViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destination.selectedCategory = categories![indexPath.row]
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

}
