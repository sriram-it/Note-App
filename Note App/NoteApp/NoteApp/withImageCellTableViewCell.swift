//
//  NoteImageCellTableViewCell.swift
//  NoteApp
//
//  Created by user176097 on 6/9/20.
//  Copyright © 2020 user176097. All rights reserved.
//

import UIKit

class withImageCellTableViewCell: UITableViewCell {

    
    @IBOutlet weak var ntitle: UILabel!
    @IBOutlet weak var nCategory: UILabel!
    @IBOutlet weak var nLocation: UILabel!
    @IBOutlet weak var nCreatedDate: UILabel!
    @IBOutlet weak var nImage: UIImageView!
    @IBOutlet weak var nCellView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        nCellView.layer.shadowColor = UIColor.black.cgColor
        nCellView.layer.shadowOpacity = 1
        nCellView.layer.shadowOffset = .zero
        nCellView.layer.shadowRadius = 10
    }

   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
