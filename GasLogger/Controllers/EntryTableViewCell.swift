//
//  EntryTableViewCell.swift
//  GasLogger
//
//  Created by Gene Crucean on 1/4/16.
//  Copyright © 2016 Dagger Dev. All rights reserved.
//

import UIKit


class EntryTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var mileageLabel: UILabel!
    @IBOutlet weak var mpgLabel: UILabel!
    @IBOutlet weak var gallonsLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        dateLabel.textColor = StyleKit.white
        mileageLabel.textColor = StyleKit.white
        mpgLabel.textColor = StyleKit.white
        gallonsLabel.textColor = StyleKit.white
        priceLabel.textColor = StyleKit.white
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
