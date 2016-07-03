//
//  ViewController.swift
//  week_3_part_6

//
//  Created by howard hsien on 2016/4/25.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import UIKit
import PureLayout

class ViewController: UIViewController{
    
    @IBOutlet weak var refreshButton : UIBarButtonItem!
    @IBOutlet weak var viewModeSegmentControl: UISegmentedControl!
    var stationModel = YoubikeManager.sharedInstance().stationModel

    private lazy var collectionViewController: CollectionViewController = { [unowned self] in
        
        let controller = CollectionViewController.controller()
//delegate not needed yet
//when I need the delegate, implement the protocol and uncomment the following line
//        controller.delegate = self
        
        self.addChildViewController(controller)
        self.didMoveToParentViewController(controller)
        return controller
        }()
    
    private lazy var tableViewController: TableViewController = { [unowned self] in
        
        let controller = TableViewController.controller()
        
        //        controller.delegate = self
        self.refreshButton.target = controller
        self.refreshButton.action = #selector(TableViewController.refreshPage)
        self.addChildViewController(controller)
        self.didMoveToParentViewController(controller)
        return controller
        }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewModeBar()
        setupNavBar()
        prepareView()
        
     }
    //setup navbar color
    func setupNavBar(){
        self.navigationController?.navigationBar.barTintColor = UIColor.ybkCharcoalGreyColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.ybkPaleGoldColor()]

    }
    
    //prepare for displaying the right scene
    func prepareView(){
        tableViewController.tableView.removeFromSuperview()
        view.addSubview(tableViewController.tableView)
        self.edgesForExtendedLayout = UIRectEdge.None
    }
    
    
    func setViewModeBar() {
        viewModeSegmentControl.tintColor = UIColor.ybkPaleGoldColor()
        viewModeSegmentControl.addTarget(self, action: #selector(ViewController.changeViewMode(_:)), forControlEvents: .ValueChanged)
        
    }
    
    //MARK:- Change View Mode
    @objc func changeViewMode(sender: UISegmentedControl) {
        tableViewController.view.removeFromSuperview()
        collectionViewController.view.removeFromSuperview()
        
        switch ViewMode(rawValue: sender.selectedSegmentIndex)! {
        case .ListView:
            view.addSubview(tableViewController.view)
            tableViewController.view.autoPinEdgesToSuperviewEdges()
        case .GridView:
            view.addSubview(collectionViewController.view)
            collectionViewController.view.autoPinEdgesToSuperviewEdges()
           
        }
    }
    
    //when entering mapview, the tabBar will be hidden, so we show the tabBar again here
    override func viewWillAppear(animated: Bool) {
        tabBarController!.tabBar.hidden = false
    }

}

//MARK: enum of view mode
enum ViewMode: Int{
    case ListView
    case GridView
}



