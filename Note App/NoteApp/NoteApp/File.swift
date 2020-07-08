//
//  File.swift
//  NoteApp
//
//  Created by Arunkumar Nachimuthu on 2020-06-22.
//  Copyright © 2020 user176097. All rights reserved.
//

import Foundation


import UIKit

//class File: UITableViewController {
//    var image:[String] = ["1", "2"]
//
//    var au:[String] = ["1", "2"]
//
//    var vi:[String] = ["1", "2"]
//    var i = 0
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 6
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        //0..1
//        if indexPath.row < image.count {
//            //cell = image[i]
//            //i += 1
//        }
//        //2..3
//        if indexPath.row < (image.count + au.count) {
//            //cell = au[image.count-i.r]
//            // i +=1
//        }
//        //4..5
//        if indexPath.row < (image.count + au.count + vi.count) {
//            //cell = vi[image.count + au.count -i.r]
//            // i +=1
//        }
//
//
//
//    }
//
//
   
//}

class File: Codable{
    
    var name: String
    var job: String
    
    init(name:String, job:String) {
        self.name = name
        self.job = job
    }
}
