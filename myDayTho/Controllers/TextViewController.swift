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
    
    var textArray = [Textes]()
    
    var previousThoughtRowNumber: Int = 0
    
    var thoughts: Though? {
        didSet {
            navigationItem.title = thoughts?.title
            textForLabel = (thoughts?.textOfThough)!
            print("DidSet")
            previousThoughtRowNumber = Int(thoughts!.rowNumber)
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
        print("Done")
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ThoughtsTableViewController
        destinationVC.thoughtsArray[previousThoughtRowNumber].textOfThough = textLabel.text
        
    }
    
    // MARK: - Public Methods
    
//    func saveText() {
//        do {
//            try context.save()
//
//        } catch {
//            print("Error with saving text \(error)")
//
//        }
//
//    }
//
//    func loadText() {
//        do {
//           textArray = try context.fetch(Textes.fetchRequest())
//
//        } catch {
//            print("Error with fetching text")
//
//        }
//
//        textForLabel = textArray[0].textString!
//
//    }
    
}
