//
//  RestaurantCell.swift
//  RestaurantFinder
//
//  Created by Pasan Premaratne on 5/5/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit

class RestaurantCell: UITableViewCell {
    @IBOutlet weak var restaurantTitleLabel: UILabel!
    @IBOutlet weak var restaurantCheckinLabel: UILabel!
    @IBOutlet weak var restaurantCategoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(title: String, checkinCount: String, category: String){
        restaurantTitleLabel.text = title
        restaurantCheckinLabel.text = checkinCount
        restaurantCategoryLabel.text = category
    }
}
