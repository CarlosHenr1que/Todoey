//
//  ItemsTableViewController.swift
//  Todoey
//
//  Created by Carlos Henrique Matos Borges on 13/01/24.
//

import UIKit
import CoreData
import ChameleonFramework
import RealmSwift

class ItemsTableViewController: SwipeTableViewController {
    var items: Results<Item>?
    var realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = selectedCategory?.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let backgroundColor = UIColor(hexString: selectedCategory!.color)!
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
    
    func loadItems() {
        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
        
    }
    
    func createAddItemAlert() -> UIAlertController {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let safeTitle = textField.text {
                if(!safeTitle.isEmpty) {
                    do {
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = textField.text!
                            newItem.done = false
                            self.selectedCategory?.items.append(newItem)
                        }
                    } catch {
                        print("Error saving new items, \(error)")
                    }
                    self.tableView.reloadData()
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
        
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        present(createAddItemAlert(), animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
       
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let currentItem = items![indexPath.row]
        cell.textLabel?.text = currentItem.title
        cell.accessoryType = currentItem.done ? .checkmark : .none
        
        if let color = UIColor(hexString: selectedCategory!.color)!.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(items!.count)) {
            cell.backgroundColor = color
            cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentItem = items![indexPath.row]
        let currentCell = tableView.cellForRow(at: indexPath)
        currentItem.done = !currentItem.done
        currentCell?.accessoryType = currentItem.done ? .checkmark : .none
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func updateModel(at indexPath: IndexPath) {
        let currentItem = items![indexPath.row]
        do {
            try realm.write {
                realm.delete(currentItem)
            }
        } catch {
            print("Error while deleting item")
        }
        tableView.reloadData()
    }
}
