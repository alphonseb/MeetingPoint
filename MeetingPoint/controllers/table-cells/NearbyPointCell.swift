//
//  NearbyPointCell.swift
//  MeetingPoint
//
//  Created by Alphonse on 15/01/2020.
//  Copyright © 2020 Alphonse. All rights reserved.
//

import UIKit
import AlamofireImage

class NearbyPointCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var nearbyPoint: NearbyPoint! {
        didSet {
            nameLabel.text = self.nearbyPoint.name
            if let imgUrl = self.nearbyPoint.imageUrl {
                imgView.af_setImage(withURL: imgUrl)
            } else {
                imgView.image = UIImage(named: "bar_default")
            }
            if let price = self.nearbyPoint.priceLevel {
                switch price {
                case 1:
                    priceLabel.text = "€"
                case 2:
                    priceLabel.text = "€€"
                case 3:
                    priceLabel.text = "€€€"
                default:
                    priceLabel.text = ""
                }
            } else {
                priceLabel.text = "Pas d'information de prix"
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageView?.contentMode = .scaleAspectFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
