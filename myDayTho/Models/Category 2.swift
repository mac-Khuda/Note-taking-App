//
//  Category.swift
//  myDayTho
//
//  Created by Volodymyr Khuda on 08.12.2020.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let thoughts = List<Thought>()
}
