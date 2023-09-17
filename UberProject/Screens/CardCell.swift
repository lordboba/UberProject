//
//  CardCell.swift
//  UberProject
//
//  Created by Emma Shen on 9/17/23.
//

import UIKit

class CardCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var icon1: UIImageView!
    @IBOutlet weak var icon2: UIImageView!
    @IBOutlet weak var icon3: UIImageView!
    @IBOutlet weak var icon4: UIImageView!
    @IBOutlet weak var icon5: UIImageView!
    @IBOutlet weak var timeLabel2: UILabel!
    @IBOutlet weak var priceLabel2: UILabel!
    @IBOutlet weak var emissionLabel2: UILabel!
    // Set up cell
    func configure(modeIcons: UIImage, times: String, prices: String, emissions: String) {
        // Generate images through icons 1 - 5 
        icon1.image = modeIcons
        timeLabel2.text = times
        priceLabel2.text = prices
        emissionLabel2.text = emissions
        
        cardView.layer.shadowColor = UIColor.gray.cgColor
        cardView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        cardView.layer.shadowOpacity = 1.0
        cardView.layer.masksToBounds = false
        cardView.layer.cornerRadius = 2.0
        
        
    }
}
