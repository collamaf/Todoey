//
//  ViewController.swift
//  Todoey
//
//  Created by Francesco Collamati on 20/10/2018.
//  Copyright © 2018 Francesco Collamati. All rights reserved.
//

import UIKit

class TodoListViewViewController: UITableViewController {

	var itemArray = ["Find Mike", "Buy Eggs", "Destroy Demogorgon"]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	//MARK - Tableview Datasource Methods
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return itemArray.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
		cell.textLabel?.text = itemArray[indexPath.row]
		return cell
	}
	
	//MARK - TableView Delegate Methods
	
	override	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//		print(itemArray[indexPath.row])
		
		if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
			tableView.cellForRow(at: indexPath)?.accessoryType = .none
		} else {
			tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
		}
		
		tableView.deselectRow(at: indexPath, animated: true)

	}
	
	//MARK - Add New Items
	
	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		
		var textField = UITextField()
		
		let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
		
		let action = UIAlertAction(title: "Add Item", style: .default) { (UIAlertAction) in
			print("Success")
			print(textField.text!)
			self.itemArray.append(textField.text ?? "New Item")
			self.tableView.reloadData()
		}
		
		alert.addTextField { (alertTextField) in
			alertTextField.placeholder = "Create new item"
			textField=alertTextField
//			print(alertTextField.text)
		}
		
		alert.addAction(action)

		present(alert, animated: true, completion: nil)
	}
	
}

