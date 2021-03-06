//
//  InfoCell.swift
//  MeetingPoint
//
//  Created by Alphonse on 15/01/2020.
//  Copyright © 2020 Alphonse. All rights reserved.
//

import UIKit

class InfoCell: UITableViewCell {
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var pictoView: UIImageView!
    
    var info: AnyObject! {
        didSet {
            infoLabel.text = "\(self.info!)"
        }
    }
    var picto: UIImage! {
        didSet {
            pictoView.image = self.picto
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
