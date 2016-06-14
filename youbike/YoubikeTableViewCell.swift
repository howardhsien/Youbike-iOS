//
//  YoubikeTableViewCell.swift
//  week_3_part_3
//
//  Created by howard hsien on 2016/4/25.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import UIKit

class YoubikeTableViewCell: UITableViewCell {
    //MARK: Properties
    weak var delegate: CellDelegation?
    @IBOutlet weak var stationLocationLabel: UILabel!
    @IBOutlet weak var stationAreaLabel: UILabel!
    @IBOutlet weak var remainingNumberLabel: UILabel!
 //   @IBOutlet weak var leftLabel: UILabel!
    var station :YoubikeStation = YoubikeStation(
        youbikeLocation: "",
        youbikeAreas: "",
        youbikeRemaining: 0,
        stationLongitude: 0.0,
        stationLatitude: 0.0,
        stationID: ""
    )
    @IBOutlet weak var viewMapButton: UIButton!
    
    override func layoutSubviews() {
        super.layoutSubviews()

        viewMapButton.layer.cornerRadius = 4
        viewMapButton.layer.borderWidth = 1
        viewMapButton.layer.borderColor = UIColor.ybkDarkSalmonColor().CGColor
        viewMapButton.contentEdgeInsets = UIEdgeInsetsMake(3, 9, 3, 9)
        viewMapButton.addTarget(self, action: "viewMap:", forControlEvents: UIControlEvents.TouchUpInside)
        
        //add baseline
        let baseline = UIView()
        baseline.frame = CGRectMake(0, 120, 2500 , 2)
        baseline.backgroundColor = UIColor(red: 166.0/255.0, green: 145.0/255.0, blue: 84.0/255.0, alpha: 1.0)
        self.contentView.addSubview(baseline)
       
        
    }
    func viewMap(sender: UIButton!){
        delegate?.cell(self, viewMap: sender)        
    }
    func updateUIFromStation(){
        stationLocationLabel.text = station.youbikeLocation
        stationAreaLabel.text = station.youbikeAreas
        remainingNumberLabel.text = String(station.youbikeRemaining)
    }
    
    //when it is in TableMapController, the button need to be hidden
    func hideButton(){
        viewMapButton.hidden = true

    }

}



