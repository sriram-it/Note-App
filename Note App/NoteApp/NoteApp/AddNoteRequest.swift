//
//  AddNoteRequest.swift
//  NoteApp
//
//  Created by user176097 on 6/23/20.
//  Copyright © 2020 user176097. All rights reserved.
//

import Foundation

class NoteFormatInServer: Codable {
    

      var created_date: String
      var updated_date: String
      var title: String
      var content: String
      var category_id: String
      var location: String
      var secured: String
      var image: String
      var audio: String
      var video: String
      var email: String
    
    init(created_date: String, updated_date: String, title: String, content: String, category_id :String, location:String, secured: String, image:String, audio: String, video: String, email: String) {
        self.created_date = created_date
        self.updated_date = updated_date
        self.title = title
        self.content = content
        self.category_id = category_id
        self.location = location
        self.secured = secured
        self.image = image
        self.audio = audio
        self.video = video
        self.email = email
    }
}

