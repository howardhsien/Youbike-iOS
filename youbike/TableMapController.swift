//
//  TableMapController.swift
//  youbike
//
//  Created by howard hsien on 2016/5/20.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import UIKit
import MapKit
import UILoadControl

enum MapTableSection : Int {
    case StationInfoSection
    case MapSection
    case CommentSection
}

class TableMapController: UITableViewController {

    //MARK: declare cell identifier
    let topCellReuseIdentifier = "YoubikeTableViewCell"
    let mapCellReuseIdentifier = "mapCell"
    let commentCellReuseIdentifier = "CommentCell"
    //first letter identifier :capital case
    //             xib        :lower case
  
    var station:YoubikeStation? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCellNib()

        tableView.loadControl = UILoadControl(target: self, action: #selector(loadMore(_:)))
        self.edgesForExtendedLayout = UIRectEdge.None
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 144
        
        
    }
    func setCellNib(){
        let nib = UINib(nibName: "cell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: topCellReuseIdentifier)
        
        let nibComment = UINib(nibName: "commentCell", bundle: nil)
        self.tableView.registerNib(nibComment, forCellReuseIdentifier: commentCellReuseIdentifier)
        
    }
    
    func setNavBarStyle(){
        self.navigationController?.navigationBar.tintColor = UIColor.ybkPaleGoldColor()
        if let station = station{
            self.title = station.youbikeLocation
        }

    }

    func commentDidLoad(station:YoubikeStation){
        self.station = station
        tableView.reloadData()
        setNavBarStyle()
    }
    
    //MARK: load more
    @objc private func loadMore(sender: AnyObject?){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), {
            guard let station = self.station else{ return }
            YoubikeManager.sharedInstance().commentModel.getCommentData(station.stationID){
                [weak self] in
                self?.tableView.loadControl?.endLoading()
                self?.tableView.reloadData()
            }
        })
    }

    

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return YoubikeManager.sharedInstance().commentModel.comments.count
            
        default:
            return 0
        }
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch MapTableSection(rawValue: indexPath.section)! {
        case .StationInfoSection: return 122
        case .MapSection: return 250
        case .CommentSection: return UITableViewAutomaticDimension
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //should make mapview cell

        switch MapTableSection(rawValue: indexPath.section)!{
        case .StationInfoSection:
            let cell = tableView.dequeueReusableCellWithIdentifier(topCellReuseIdentifier, forIndexPath: indexPath) as! YoubikeTableViewCell
            if let station = self.station{
                cell.station = station
                cell.updateUIFromStation()
                cell.hideButton()
            }
            return cell
        
        case .MapSection:
            let cell = tableView.dequeueReusableCellWithIdentifier(mapCellReuseIdentifier, forIndexPath: indexPath) as! MapCell
            cell.station = station
            cell.setUpMapview()
            return cell
            
        case .CommentSection:
            let cell = tableView.dequeueReusableCellWithIdentifier(commentCellReuseIdentifier, forIndexPath: indexPath) as! CommentViewCell
            cell.setComment(YoubikeManager.sharedInstance().commentModel.comments[indexPath.row])
            cell.commentDidLoad()
            return cell
            
            

        }
    }
// MARK: header of tableView
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch MapTableSection(rawValue: section)! {
        case .CommentSection:
            let commentHeaderView = UIView(frame: CGRectMake(0,0,self.view.frame.width,28))
            commentHeaderView.backgroundColor = UIColor.ybkCharcoalGreyColor()
            let commentLabel = UILabel()
            commentLabel.text = "comment"
            commentLabel.font = UIFont(name: "SFUIText-Regular", size: 12)
            commentHeaderView.addSubview(commentLabel)
            commentLabel.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 7, left: 20, bottom: 7, right: 100))
            commentLabel.textColor = UIColor.ybkPaleGoldColor()
            return commentHeaderView
        default:
            return nil
        }
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch MapTableSection(rawValue: section)! {
        case .CommentSection:
            return 28
        default:
            return 0
        }
        
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


//MARK: implement UIScrollViewDelegate
extension TableMapController {
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        scrollView.loadControl?.update()
    }
}
