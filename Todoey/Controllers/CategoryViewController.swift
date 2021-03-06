//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Francesco Collamati on 02/11/2018.
//  Copyright © 2018 Francesco Collamati. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
	
	let realm = try! Realm()
	
	var categories : Results<Category>?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		loadCategories()
		tableView.separatorStyle = .none
		
	}
	
	//MARK: - TableView DataSource Methods
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return categories?.count ?? 1
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = super.tableView(tableView, cellForRowAt: indexPath)
		if let category = categories?[indexPath.row] {
			cell.textLabel?.text = category.name
			guard let categoryColor = UIColor(hexString: category.color) else {fatalError()}
			cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
			cell.backgroundColor = categoryColor
		}
		return cell
	}
	
	//MARK: - TableView Delegate Methods
	
	override	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: "goToItems", sender: self)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let destinationVC = segue.destination as! TodoListViewViewController
		
		if let indexPath = tableView.indexPathForSelectedRow {
			destinationVC.selectedCategory = categories?[indexPath.row]
			
		}
		
	}
	
	//MARK: - Data Manipulation Methods
	func saveCategories(category: Category) {
		do {
			try realm.write {
				realm.add(category)
			}
		} catch {
			print("Error saving category, \(error)")
		}
		self.tableView.reloadData()
	}
	
	
	//	func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
	func loadCategories() {
		
		categories = realm.objects(Category.self)
		
		tableView.reloadData()
		
	}
	
	//MARK: - Delete Data From Swipe
	
	override func updateModel(at indexPath: IndexPath) {
		if let categoryForDeletion = self.categories?[indexPath.row] {
			do {
				try self.realm.write {
					self.realm.delete(categoryForDeletion)
				}
			} catch {
				print("Error removing category, \(error)")
			}
		}
	}
	
	
	//MARK: - Add New Categories
	
	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		
		var textField = UITextField()
		let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
		let action = UIAlertAction(title: "Add", style: .default) { (action) in
			
			let newCategory = Category()
			newCategory.name = textField.text!
			newCategory.color = UIColor.randomFlat.hexValue()
			//			self.categories.append(newCategory)
			self.saveCategories(category: newCategory)
		}
		
		alert.addTextField { (alertTextField) in
			alertTextField.placeholder = "Create new Category"
			textField=alertTextField
		}
		
		alert.addAction(action)
		present(alert, animated: true, completion: nil)
		
		
		
	}
	
	
	
	
}


