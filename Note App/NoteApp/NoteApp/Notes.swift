//
//  Notes.swift
//  NoteApp
//
//  Created by user176097 on 6/8/20.
//  Copyright © 2020 user176097. All rights reserved.
//

import Foundation
import UIKit
let notesObj = Notes();

class Notes {
    var notesArray = [Note] ();

    init() {
        
        var dateComponents = DateComponents()
        let userCalendar = Calendar.current
        
        dateComponents.year = 2001
        dateComponents.month = 3
        dateComponents.day = 13
        let date1 = userCalendar.date(from: dateComponents)!
        
        dateComponents.year = 2007
        dateComponents.month = 5
        dateComponents.day = 27
        let date2 = userCalendar.date(from: dateComponents)!
        
        
        dateComponents.year = 2016
        dateComponents.month = 6
        dateComponents.day = 21
        let date3 = userCalendar.date(from: dateComponents)!
        
        dateComponents.year = 2016
        dateComponents.month = 6
        dateComponents.day = 7
        let date4 = userCalendar.date(from: dateComponents)!
        
        dateComponents.year = 2016
        dateComponents.month = 7
        dateComponents.day = 18
        let date5 = userCalendar.date(from: dateComponents)!
        
        /*self.notesArray.append(Note(id: 1001,title: "Personal Notes", category: "Personal", note: "askdbsakjbdkjsab", location: "Toronto, ON", images: ["nt1"], audio: "", createdDate: date3));
        self.notesArray.append(Note(title: "Travel", category: "Personal", note: "askdbsakjbdkjsab", location: "Toronto, ON", images: ["nt2"], audio: "", createdDate: date4));
        self.notesArray.append(Note(title: "Animation", category: "Study", note: "Animation is a method in which figures are manipulated to appear as moving images. In traditional animation, images are drawn or painted by hand on transparent celluloid sheets to be photographed and exhibited on film. Today, most animations are made with computer-generated imagery (CGI). Computer animation can be very detailed 3D animation, while 2D computer animation can be used for stylistic reasons, low bandwidth or faster real-time renderings. Other common animation methods apply a stop motion technique to two and three-dimensional objects like paper cutouts, puppets or clay figures.", location: "Toronto, ON", images: ["nt4"], audio: "", createdDate: Date()));
        self.notesArray.append(Note(title: "Meeting", category: "Work", note: "Contemporary business and science treat as a project (or program) any undertaking, carried out individually or collaboratively and possibly involving research or design, that is carefully planned (usually by a project team[citation needed]) to achieve a particular aim.[1] An alternative view sees a project managerially as a sequence of events: a set of interrelated tasks to be executed over a fixed period and within certain cost and other limitations.[2] A project may be a temporary (rather than permanent) social system (work system), possibly constituted by teams (within or across organizations) to accomplish particular tasks under time constraints.[3] A project may be a part of wider programme management[citation needed] or an ad hoc structure. Note that open-source software projects (for example) may lack defined team-membership, precise planning and time-limited durations.", location: "Toronto, ON", images: [], audio: "", createdDate: date2));
        self.notesArray.append(Note(title: "Car", category: "Personal", note: "askdbsakjbdkjsab", location: "Scarborough, ON", images: ["nt5"], audio: "", createdDate: date5));
        self.notesArray.append(Note(title: "Dinner", category: "Family", note: "askdbsakjbdkjsab", location: "Markam, ON", images: [], audio: "", createdDate: date1)); */
    }
    
}
