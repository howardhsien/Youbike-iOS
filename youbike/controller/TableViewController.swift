//
//  TableViewController.swift
//  youbike
//
//  Created by howard hsien on 2016/5/17.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import UIKit
import UILoadControl
//import FZURefresh

class TableViewController: UITableViewController, CellDelegation {
    
    var stationModel = YoubikeManager.sharedInstance().stationModel
    
    
    class func controller() -> TableViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TableViewController") as! TableViewController
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "cell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "YoubikeTableViewCell")
        stationModel.getYoubikeDataWithCompletionHandlerAndJWT(stationModel.youbikeURL,completion: {[unowned self] in
            self.tableView.reloadData()
            })
        tableView.dataSource = self
        tableView.delegate = self
        tableView.loadControl = UILoadControl(target: self, action: #selector(loadMore(_:)))
//The following comment uses FZURefresh
        
//        self.tableView.toLoadMore({
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), {
//                self.stationModel.getNextData({
//                    self.tableView.reloadData()
//                    self.tableView.doneRefresh()
//
//                    print("after done Refresh")
//                })
//            })
//        })
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    //MARK: load more
    @objc private func loadMore(sender: AnyObject?){
        print("new load more")
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), {
            self.stationModel.getNextStationPageData({
                [weak self] in
                self?.tableView.loadControl?.endLoading()
                self?.tableView.reloadData()
            })
            
        })
    }



    // MARK: - Table view data source
    //---------------------------------------TableView ------------------------------------------------
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 122.0
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stationModel.stations.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "YoubikeTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! YoubikeTableViewCell
        
        // Configure the cell...
        cell.station = stationModel.stations[indexPath.row]
        cell.updateUIFromStation()
        cell.delegate = self

        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//        let mapViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MapView") as! MapViewController
//        let station = stationModel.stations[indexPath.row]
//        mapViewController.setCellExist(true)
//        mapViewController.setVariable(station)
//        mapViewController.cell.updateUIFromStation()
//        
//        self.navigationController?.pushViewController(mapViewController, animated: true)
//
        
        
        let tableMapController = self.storyboard?.instantiateViewControllerWithIdentifier("TableMap") as! TableMapController
        let station = stationModel.stations[indexPath.row]
        YoubikeManager.sharedInstance().commentModel.getCommentData(station.stationID){
//            [unowned self] in
            tableMapController.commentDidLoad(station)
        }

        
        self.navigationController?.pushViewController(tableMapController, animated: true)
        

        
    }
    
    //MARK: press button (pure map)
    func cell(cell: YoubikeTableViewCell, viewMap sender: AnyObject?){
        
        let mapViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MapView") as! MapViewController
        mapViewController.setVariable(cell.station)
        mapViewController.setCellExist(false)
        self.navigationController?.pushViewController(mapViewController, animated: true)
    }
    
    func dataDidFinishFetching() {
        tableView.reloadData()
    }

}

//MARK: implement UIScrollViewDelegate
extension TableViewController {
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        scrollView.loadControl?.update()
    }
}

//MARK: cellDelegation (for view map)
protocol CellDelegation: class{
    func cell(cell: YoubikeTableViewCell, viewMap sender: AnyObject?)
}