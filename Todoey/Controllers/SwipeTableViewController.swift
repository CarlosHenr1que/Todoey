//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Carlos Henrique Matos Borges on 16/01/24.
//

import Foundation
import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeCellKit.SwipeActionsOrientation) -> [SwipeCellKit.SwipeAction]? {
        guard orientation == .right else { return nil }
        let deleteAction = SwipeAction(style: .default, title: "Delete", handler: {action, indexPath in
            self.updateModel(at: indexPath)
        })
        
        return [deleteAction]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        return cell
    }
    
    func updateModel(at indexPath: IndexPath) {
        
    }
}
