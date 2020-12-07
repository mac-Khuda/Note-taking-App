//
//  ThoughtsTableViewController.swift
//  myDayTho
//
//  Created by Volodymyr Khuda on 03.12.2020.
//

import UIKit
import CoreData

class ThoughtsTableViewController: UITableViewController {
    
    // MARK: - Public Propeties
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    static var thoughtsArray = [Though]()
    
    static var newTextOfThought: Though?
    
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

    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadThoughts()
        
    }
    
    // MARK: - IBActions
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new thought", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add thought", style: .default) { (alert) in
            let newThought = Though(context: self.context)
            
            let now = Date()
            
            newThought.title = textField.text!
            newThought.parentCategory = self.selectedCategory
            newThought.textOfThough = ""
            newThought.date = now
            
            ThoughtsTableViewController.thoughtsArray.append(newThought)
            self.saveThoughts()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Best day in my life"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - Public Methods
    
    func saveThoughts() {
        do {
            try context.save()
            
        } catch {
            print("Error with saving thought \(error)")
            
        }
        
        self.tableView.reloadData()
        
    }
    
    func loadThoughts(with request: NSFetchRequest<Though> = Though.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let addtitionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addtitionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            ThoughtsTableViewController.thoughtsArray = try context.fetch(request)
        } catch {
            print("Error with loading thoguths \(error)")
            
        }
        
        self.tableView.reloadData()
        
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ThoughtsTableViewController.thoughtsArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ThoughtsCell", for: indexPath)
        let though = ThoughtsTableViewController.thoughtsArray[indexPath.row]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm E, d MMM y"
        let date = formatter.string(from: though.date!)
        
        cell.textLabel?.text = though.title
        cell.detailTextLabel?.text = date
        
        return cell
        
    }
    
    // MARK: - TableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ThoughtsTableViewController.thoughtsArray[indexPath.row].rowNumber = Int64(indexPath.row)
        performSegue(withIdentifier: "goToText", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TextViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.thoughts = ThoughtsTableViewController.thoughtsArray[indexPath.row]
            
        }
    }

}

extension ThoughtsTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Though> = Though.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadThoughts(with: request, predicate: predicate)
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
