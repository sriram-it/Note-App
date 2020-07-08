//
//  Category.swift
//  NoteApp
//
//  Created by Arunkumar Nachimuthu on 2020-06-22.
//  Copyright © 2020 user176097. All rights reserved.
//

import Foundation

class Category: Codable {
    var id: String
    var name: String
    var user_id: String
    
    init(id:String, name: String, user_id: String) {
        self.id = id
        self.name = name
        self.user_id = user_id
    }
    
}
