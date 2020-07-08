//
//  WithoutImageTableViewCell.swift
//  NoteApp
//
//  Created by user176097 on 6/10/20.
//  Copyright © 2020 user176097. All rights reserved.
//

import UIKit

class WithoutImageTableViewCell: UITableViewCell {

    
    @IBOutlet weak var nTitle: UILabel!
    @IBOutlet weak var nCategory: UILabel!
    @IBOutlet weak var nLocation: UILabel!
    @IBOutlet weak var nCreatedDate: UILabel!
    @IBOutlet weak var nCell: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nCell.layer.shadowColor = UIColor.black.cgColor
        nCell.layer.shadowOpacity = 1
        nCell.layer.shadowOffset = .zero
        nCell.layer.shadowRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
