//
//  ViewController.swift
//  Todoey
//
//  Created by Francesco Collamati on 20/10/2018.
//  Copyright © 2018 Francesco Collamati. All rights reserved.
//

import UIKit

class TodoListViewViewController: UITableViewController {
	
	var itemArray = [Item] ()
	//["Find Mike", "Buy Eggs", "Destroy Demogorgon"]
	
	let defaults = UserDefaults.standard
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view, typically from a nib.
		
		let newItem = Item()
		newItem.title = "Find Make"
		itemArray.append(newItem)
		
		let newItem2 = Item()
		newItem2.title = "Buy Eggos"
		itemArray.append(newItem2)
		
		let newItem3 = Item()
		newItem3.title = "Destroy Demogorgon"
		itemArray.append(newItem3)
		
		if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
			itemArray=items
		}

		
	}
	
	//MARK - Tableview Datasource Methods
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return itemArray.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
		
		let item = itemArray[indexPath.row]

		cell.textLabel?.text = item.title

		cell.accessoryType = item.done ? .checkmark : .none
		
		return cell
	}
	
	//MARK - TableView Delegate Methods
	
	override	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		//		print(itemArray[indexPath.row])
		
		itemArray[indexPath.row].done = !itemArray[indexPath.row].done
		
		tableView.reloadData()
		
		tableView.deselectRow(at: indexPath, animated: true)
		
	}
	
	//MARK - Add New Items
	
	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		
		var textField = UITextField()
		
		let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
		
		let action = UIAlertAction(title: "Add Item", style: .default) { (UIAlertAction) in
			
			let newItem = Item()
			newItem.title = textField.text!
			self.itemArray.append(newItem)
			
			self.defaults.setValue(self.itemArray, forKey: "TodoListArray")
			
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
