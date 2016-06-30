//
//  YoubikeCollectionViewCell.swift
//  youbike
//
//  Created by howard hsien on 2016/5/16.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import UIKit

class YoubikeCollectionViewCell: UICollectionViewCell {
 
 
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var remainingBikesLabel: UILabel!
    
    @IBOutlet weak var stationNameLabel: UILabel!
    
    @IBOutlet weak var separatorLine: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUpStyle()
    }
    
    func setUpStyle(){
        view.backgroundColor = UIColor.ybkPaleTwoColor()
        
        remainingBikesLabel.textColor = UIColor.ybkDarkSalmonColor()
        separatorLine.backgroundColor = UIColor.ybkSandBrownColor()
        stationNameLabel.textColor = UIColor.ybkBrownishColor()
    }
    
    func setRemainingBikes(number: Int){
        remainingBikesLabel.text = String(number)
    }
    
    func setStationName(name: String){
        stationNameLabel.text = name
    }
}
