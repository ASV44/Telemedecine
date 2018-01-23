//
//  DoctorListCell.swift
//  LAB5
//
//  Created by Hackintosh on 1/13/18.
//  Copyright © 2018 Hackintosh. All rights reserved.
//

import UIKit

class DoctorListCell: UITableViewCell {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var domainLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func layoutSubviews() {
        self.contentView.backgroundColor = UIColor(red: 240 / 250,
                                                   green: 240 / 250,
                                                   blue: 240 / 250,
                                                   alpha: 1)
        
        cardView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(),
                                                 components: [1.0, 1.0, 1.0, 0.9])
        cardView.layer.masksToBounds = false
        cardView.layer.cornerRadius = 5.0
        cardView.layer.shadowOffset = CGSize(width: -1, height: 1)
        cardView.layer.shadowOpacity = 0.5
        cardView.backgroundColor = UIColor.white
    }
    
    func setAdsress(_ address: String) {
        let textWithIcon = StaticUtil.getAtributedString(string: address, icon: .locationIcon)
        locationLabel.attributedText = textWithIcon
    }
    
    func setRating(_ rating: Double) {
        let ratingValue = String(rating)
        let textWithIcon = StaticUtil.getAtributedString(string: ratingValue, icon: .starIcon)
        ratingLabel.attributedText = textWithIcon
    }
}
