//
//  TextViewController.swift
//  myDayTho
//
//  Created by Volodymyr Khuda on 03.12.2020.
//

import UIKit

class TextViewController: UIViewController {
    
    // MARK: - Public Properties
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var previousThoughtRowNumber: Int = 0
    
    var thoughts: Though? {
        didSet {
            navigationItem.title = thoughts?.title
            
            textForLabel = (thoughts?.textOfThough)!
            print("DidSet")
            previousThoughtRowNumber = Int(thoughts!.rowNumber)
            
            ThoughtsTableViewController.newTextOfThought = thoughts
        }
        
    }
    
    var textForLabel = ""
    
    // MARK: - IBOutlets

    @IBOutlet weak var textLabel: UITextView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad Done")
        textLabel.text = textForLabel
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        ThoughtsTableViewController.newTextOfThought?.textOfThough = textLabel.text
        ThoughtsTableViewController.thoughtsArray[previousThoughtRowNumber].textOfThough = textLabel.text
        saveText()
        print("viewWillDisappear")
        
    }
    
    // MARK: - Public Methods
    
    func saveText() {
        do {
            try context.save()

        } catch {
            print("Error with saving text \(error)")

        }

    }
    
}
