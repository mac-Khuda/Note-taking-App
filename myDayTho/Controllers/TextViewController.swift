//
//  TextViewController.swift
//  myDayTho
//
//  Created by Volodymyr Khuda on 03.12.2020.
//

import UIKit
import RealmSwift

class TextViewController: UIViewController {
    
    // MARK: - Public Properties
    
    let realm = try! Realm()
        
    var textForLabel = ""
    
    var thoughtTextVC: Thought? {
        didSet {
            navigationItem.title = thoughtTextVC?.title
          
            textForLabel = thoughtTextVC!.textOfThought
           
        }
        
    }
    
    
    // MARK: - IBOutlets

    @IBOutlet weak var textLabel: UITextView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textLabel.text = textForLabel
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if thoughtTextVC?.textOfThought != textLabel.text {
            
            do {
                try realm.write() {
                    thoughtTextVC?.dateCreated = Date()
                    thoughtTextVC?.textOfThought = textLabel.text
                    
                }
            } catch {
                print("Error saving text of thought")
            }
            
        }
        
    }
    
}
