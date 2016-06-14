//
//  CollectionViewController.swift
//  youbike
//
//  Created by howard hsien on 2016/5/16.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import UIKit
import UILoadControl

private let reuseIdentifier = "CollectionCell"

//MARK: TODO: need to handle the grid layouts in different sizes
class CollectionViewController: UICollectionViewController {
    let loadDelaySeg  = 1.0
    var stationModel  = YoubikeManager.sharedInstance().stationModel
    class func controller() -> CollectionViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CollectionViewController") as! CollectionViewController
        
    }

  
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        collectionView?.loadControl = UILoadControl(target: self, action: "loadMore:")
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.reloadData()
    }
    
    
//MARK: loadMore
    @objc private func loadMore(sender: AnyObject?) {
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(loadDelaySeg * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.stationModel.getNextStationPageData({
                self.collectionView?.loadControl!.endLoading()
                self.collectionView?.reloadData()
            })

        }
    }
    
    
 
//MARK: CollectionView Delegate
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stationModel.stations.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! YoubikeCollectionViewCell
        // Configure the cell
        cell.setStationName(self.stationModel.stations[indexPath.row].youbikeLocation)
        cell.setRemainingBikes(self.stationModel.stations[indexPath.row].youbikeRemaining)
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}

//MARK: implement UIControl
extension CollectionViewController {
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        scrollView.loadControl?.update()
    }
}