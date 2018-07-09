//
//  TodosTableViewController.swift
//  ToDos
//
//  Created by Ronnie Voss on 7/6/15.
//  Copyright (c) 2015 Ronnie Voss. All rights reserved.
//

import UIKit

class TodosTableViewController: UITableViewController, UITextFieldDelegate {

    var incomplete: [Todo] = []
    var complete: [Todo] = []
    var sectionNames: [String] = ["Incomplete items", "Completed items"]
    
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func addTodo(_ sender: AnyObject) {
        
        let todoItem = Todo(itemName: self.textField.text!)
        
        if todoItem.itemName != "" {
            self.incomplete.append(todoItem)
            self.textField.text = ""
            self.saveItems()
            self.tableView.reloadData()
            self.textField.resignFirstResponder()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadItems()
        self.textField.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNames.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionNames[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return incomplete.count
        } else {
            return complete.count
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //var selectedItem = indexPath.section == 0 ? incomplete : complete
            if indexPath.section == 0 {
                incomplete.remove(at: indexPath.row)
            } else {
                complete.remove(at: indexPath.row)
            }
            //print(selectedItem[indexPath.row].itemName)
            self.saveItems()
            self.tableView.deleteRows(at: [indexPath], with: .right)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tappedItem = indexPath.section == 0 ? incomplete[indexPath.row] : complete[indexPath.row]
        //tappedItem.completed = !tappedItem.completed
        if indexPath.section == 0 {
            incomplete.remove(at: indexPath.row)
            complete.append(tappedItem)
        } else {
            complete.remove(at: indexPath.row)
            incomplete.append(tappedItem)
        }
        saveItems()
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) 
        
        if indexPath.section == 0 {
            cell.textLabel?.text = incomplete[indexPath.row].itemName
            cell.accessoryType = .none
        } else {
            cell.textLabel?.text = complete[indexPath.row].itemName
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    // MARK: Private Helpers
    func loadItems() {
        let pathComplete = self.pathForCompleteItems()
        let pathIncomplete = self.pathForIncompleteItems()
        
        if let completeItems = NSKeyedUnarchiver.unarchiveObject(withFile: pathComplete) as? [Todo] {
            self.complete = completeItems
        }
        if let incompleteItems = NSKeyedUnarchiver.unarchiveObject(withFile: pathIncomplete) as? [Todo] {
            self.incomplete = incompleteItems
        }
    }
    
    func saveItems() {
        let pathComplete = self.pathForCompleteItems()
        let pathIncomplete = self.pathForIncompleteItems()
        
        if NSKeyedArchiver.archiveRootObject(self.complete, toFile: pathComplete) {
            print("Successfully saved Completed Items")
        } else {
            print("Saving failed")
        }
        if NSKeyedArchiver.archiveRootObject(self.incomplete, toFile: pathIncomplete) {
            print("Successfully saved Incomplete Items")
        } else {
            print("Saving failed")
        }
    }
    
    fileprivate func pathForCompleteItems() -> String {
        let documentsDirectory: AnyObject? = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first as AnyObject
        return documentsDirectory!.appendingPathComponent("completeItems")
    }
    
    fileprivate func pathForIncompleteItems() -> String {
        let documentsDirectory: AnyObject? = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first as AnyObject
        return documentsDirectory!.appendingPathComponent("incompleteItems")
    }

}
