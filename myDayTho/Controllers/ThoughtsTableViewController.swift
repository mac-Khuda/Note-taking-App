//
//  ThoughtsTableViewController.swift
//  myDayTho
//
//  Created by Volodymyr Khuda on 03.12.2020.
//

import UIKit
import RealmSwift

class ThoughtsTableViewController: SwipeCellTableViewController {
    
    // MARK: - Public Propeties
    
    let realm = try! Realm()
    
    var thoughts: Results<Thought>?
    
    var selectedCategory: Category? {
        didSet {
            loadThoughts()
            
        }
        
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 50.0
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadThoughts()
        
    }
    
    // MARK: - IBActions
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new thought", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add thought", style: .default) { (alert) in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write() {
                        let newThought = Thought()
                        
                        let now = Date()
                        
                        newThought.title = textField.text!
                        newThought.textOfThought = ""
                        newThought.dateCreated = now
                        
                        currentCategory.thoughts.append(newThought)
                    }
                } catch {
                    print("Error adding new thought \(error)")
                }
            }

            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Best day in my life"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - Data Manipulation Methods
    
    func loadThoughts() {
        
        thoughts = selectedCategory?.thoughts.sorted(byKeyPath: "dateCreated", ascending: true)
        
        self.tableView.reloadData()
        
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let thoughtForDeletion = thoughts?[indexPath.row] {
            do {
                try realm.write() {
                    realm.delete(thoughtForDeletion)
                }
            } catch {
                print("Error with deleting thought \(error)")
            }
        }
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return thoughts?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let though = thoughts?[indexPath.row] {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm E, d MMM y"
            let date = formatter.string(from: though.dateCreated)
            
            cell.textLabel?.text = though.title
            cell.detailTextLabel?.text = date
        }
        
        return cell
        
    }
    
    // MARK: - TableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToText", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TextViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.thoughtTextVC = thoughts?[indexPath.row]
            
        }
    }
    
}

extension ThoughtsTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        thoughts = thoughts?.filter("title CONTAINS[cd] %@", searchBar.text!)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadThoughts()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
                
            }
        }
        
    }
    
}
