//
//  Thought.swift
//  myDayTho
//
//  Created by Volodymyr Khuda on 08.12.2020.
//

import Foundation
import RealmSwift

class Thought: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var textOfThought = ""
    @objc dynamic var dateCreated: Date = Date()
    var parentCategory = LinkingObjects(fromType: Category.self, property: "thoughts")
}
