//
//  Note.swift
//  NoteApp
//
//  Created by user176097 on 6/8/20.
//  Copyright © 2020 user176097. All rights reserved.
//

import Foundation
import UIKit

class Note {
    var id: String
    var title: String;
    var category: String;
    var note: String;
    var location: String;
    var images: [String];
    var audio: String
    var createdDate: Date
    
    init (id: String, title:String, category:String, note:String, location: String, images: [String], audio: String, createdDate: Date) {
        self.id = id
        self.title = title;
        self.category = category;
        self.note = note;
        self.location = location;
        self.images = images;
        self.audio = audio
        self.createdDate = createdDate;
    }
}
