//
//  CommentViewCell.swift
//  youbike
//
//  Created by howard hsien on 2016/5/20.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import UIKit
import UILoadControl


class CommentViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!

    @IBOutlet weak var commentText: UILabel!

    var comment:Comment?

    override func layoutSubviews() {
        setStyle()
    
    }
    
    func setStyle(){
         backgroundColor = UIColor.ybkPaleTwoColor()
        nameLabel.textColor = UIColor.ybkDarkSalmonColor()
        timeLabel.textColor = UIColor.ybkSandBrownColor()
        commentText.backgroundColor = UIColor.ybkPaleTwoColor()
        commentText.textColor = UIColor.ybkSandBrownColor()
       
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setComment(comment:Comment){
        self.comment = comment
    }
    
    func commentDidLoad() {
        self.nameLabel.text = comment?.userName
        self.commentText.text = comment?.text
        self.timeLabel.text = comment?.createdTime
        guard let picUrl_string = comment?.userPicUrl else{ return }
        guard let picUrl_NSURL = NSURL(string:picUrl_string) else { return }
        ImageDownloader.sharedInstance().downloadImageWithCompletionHandler(picUrl_NSURL){
            [unowned self](data:NSData?) in
            guard let data = data else{ return }
            self.profileImage.image = UIImage(data: data)
        }
        
        //downloadImage(NSURL(string:(comment?.userPicUrl)!)!)
    }
    


    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
