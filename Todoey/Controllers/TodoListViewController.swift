//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Francesco Collamati on 20/10/2018.
//  Copyright © 2018 Francesco Collamati. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class TodoListViewViewController: SwipeTableViewController {
	
	var todoItems : Results<Item>?
	let realm = try! Realm()
	
	@IBOutlet weak var searchBar: UISearchBar!
	
	var selectedCategory : Category? {
		didSet{
			loadItems()
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.separatorStyle = .none
		
	}
	
	
	override func viewWillAppear(_ animated: Bool) {
		title = selectedCategory?.name
		guard let colorHex = selectedCategory?.color else {fatalError()}
		updateNavBar(withHexCode: colorHex)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		updateNavBar(withHexCode: "1D9BF6")
	}
	
	func updateNavBar(withHexCode colourHexCode: String) {
		guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist.")}
		guard let navBarColor=UIColor(hexString: colourHexCode) else {fatalError()}
		
		navBar.barTintColor = navBarColor
		navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
		navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
		searchBar.barTintColor = navBarColor
	}
	
	//MARK - Tableview Datasource Methods
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return todoItems?.count ?? 1
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		//		let cell = super.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		
		let cell = super.tableView(tableView, cellForRowAt: indexPath)
		
		if let item = todoItems?[indexPath.row] {
			cell.textLabel?.text = item.title
			
			if let colour = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat((todoItems!.count))) {
				cell.backgroundColor = colour
				cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
			}
			
			cell.accessoryType = item.done ? .checkmark : .none
		} else {
			cell.textLabel?.text="No Items Added"
		}
		
		return cell
	}
	
	//MARK - TableView Delegate Methods
	
	override	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		if let item = todoItems?[indexPath.row] {
			do {
				try realm.write {
					//					realm.delete(item)
					item.done = !item.done
				}
			} catch {
				print("Error saving done status, \(error)")
			}
		}
		
		tableView.reloadData()
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	//MARK - Add New Items
	
	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		
		var textField = UITextField()
		let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
		let action = UIAlertAction(title: "Add Item", style: .default) { (UIAlertAction) in
			
			if let currentCategory = self.selectedCategory {
				do  {
					try self.realm.write {
						let newItem = Item()
						newItem.title = textField.text!
						
						newItem.dateCreated = Date()
						currentCategory.items.append(newItem)
					}
				} catch {
					print("Erorr saving new items, \(error)")
				}
			}
			
			self.tableView.reloadData()
			
			//			self.saveItems()
		}
		
		alert.addTextField { (alertTextField) in
			alertTextField.placeholder = "Create new item"
			textField=alertTextField
		}
		
		alert.addAction(action)
		present(alert, animated: true, completion: nil)
	}
	
	
	
	
	//	func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
	func loadItems() {
		todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
		
		tableView.reloadData()
		
	}
	
	override func updateModel(at indexPath: IndexPath) {
		if let itemForDeletion = self.todoItems?[indexPath.row] {
			do {
				try self.realm.write {
					self.realm.delete(itemForDeletion)
				}
			} catch {
				print("Error removing item, \(error)")
			}
		}
	}
	
}

//MARK: - Search bar methods


extension TodoListViewViewController: UISearchBarDelegate {
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		
		todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
		tableView.reloadData()
	}
	
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		if searchBar.text?.count == 0 {
			loadItems()
			
			DispatchQueue.main.async {
				searchBar.resignFirstResponder()
			}
			
			
			
		}
	}
	
	
	
}

