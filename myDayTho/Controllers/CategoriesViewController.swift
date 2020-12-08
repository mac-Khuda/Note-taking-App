//
//  CategoriesViewController.swift
//  myDayTho
//
//  Created by Volodymyr Khuda on 03.12.2020.
//

import UIKit
import RealmSwift

class CategoriesViewController: UITableViewController {
    
    // MARK: - Public Properties
    let realm = try! Realm()
    var categories: Results<Category>?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()
        
    }
    
    // MARK: - IBActions
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Category", message: "Add category of your list", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add category", style: .default) { (alert) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.saveCategory(object: newCategory)
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Category name"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - Public Methods
    
    func saveCategory(object: Object) {
        do {
            try realm.write() {
                realm.add(object)
            }
            
        } catch {
            print("Error with saving category \(error)")
            
        }
        
        self.tableView.reloadData()
        
    }
    
    func loadCategory() {
        categories = realm.objects(Category.self)
        
        self.tableView.reloadData()
        
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name
        } else {
            cell.textLabel?.text = "You didn't add categories yet"
        }
        
        return cell
    }
    
    // MARK: - Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToThoughts", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ThoughtsTableViewController
        
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
            
        }
        
    }
    
}

// MARK: - SearchBar Delegate Methods

extension CategoriesViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        categories = categories?.sorted(byKeyPath: "name", ascending: true)
        
        tableView.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadCategory()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
                
            }
        }
    }
    
}
