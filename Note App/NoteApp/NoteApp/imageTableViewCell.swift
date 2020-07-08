//
//  imageTableViewCell.swift
//  NoteApp
//
//  Created by user176096 on 6/21/20.
//  Copyright © 2020 user176097. All rights reserved.
//

import UIKit

class imageTableViewCell: UITableViewCell {

    @IBOutlet weak var attachedImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
