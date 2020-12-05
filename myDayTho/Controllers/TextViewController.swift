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
    
    var thoughts: Though? {
        didSet {
            navigationItem.title = thoughts?.title
            loadText()
            
        }
        
    }
    
    // MARK: - IBOutlets

    @IBOutlet weak var textView: UITextView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadText()
        print("viewDidLoad Done")
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let newStirngText = Textes(context: self.context)
        newStirngText.textString = textView.text
        textArray.append(newStirngText)
        
        saveText()
        print("Done")
        
    }
    
    // MARK: - Public Methods
    
    func saveText() {
        do {
            try context.save()
            
        } catch {
            print("Error with saving text \(error)")
            
        }
        
    }
    
    func loadText() {
        do {
           textArray = try context.fetch(Textes.fetchRequest())
            
        } catch {
            print("Error with fetching text")
            
        }
        
    }
    
    
}
