//
//  ProfileViewController.swift
//  youbike
//
//  Created by howard hsien on 2016/5/9.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import SafariServices

class ProfileViewController: UIViewController,SFSafariViewControllerDelegate{
    
   
    @IBOutlet weak var opaqueView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var panelView: UIView!
    private let panelViewRoundedLayer = CAShapeLayer()
    private let panelShadowViewShadowLayer = CAShapeLayer()
    @IBOutlet weak var fbPageButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavbarStyle()
        setUpViewColor()
        setUpImage()
        setUpNameLabel()
        setUpFBButton()
    }
    //panelView need to be set up after viewDidLayoutSubview
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupPanelView()
    }
    
//MARK: set up UI

    func setUpFBButton(){
        let whiteButtonFilterView = UIView()
        whiteButtonFilterView.frame = CGRectMake(0, 0, fbPageButton.frame.width, fbPageButton.frame.height/2)
        fbPageButton.addSubview(whiteButtonFilterView)
        whiteButtonFilterView.backgroundColor = UIColor.whiteColor()
        whiteButtonFilterView.alpha = 0.1
        whiteButtonFilterView.userInteractionEnabled = false
        fbPageButton.addTarget(self, action: "openFBPage", forControlEvents: .TouchUpInside)
        fbPageButton.backgroundColor = UIColor.ybkDenimBlueColor()
        fbPageButton.setTitle("Facebook Page", forState: UIControlState.Normal)
        fbPageButton.setTitleColor(UIColor.ybkWhiteColor(), forState: UIControlState.Normal)
        fbPageButton.titleLabel?.font = UIFont.ybkTextStyleFBLoginButtonFont(20)
        fbPageButton.layer.cornerRadius = 10.0
        
    }
    
    private func setupPanelView() {
        
        panelViewRoundedLayer.removeFromSuperlayer()
        panelShadowViewShadowLayer.removeFromSuperlayer()
        
        let roundedPath = UIBezierPath(
            roundedRect: panelView.bounds,
            byRoundingCorners: [ .BottomLeft, .BottomRight ],
            cornerRadii: CGSize(width: 20.0, height: 20.0)
        )
        
        //---------try to use layer.shadow API---------
        panelViewRoundedLayer.path = roundedPath.CGPath
        panelViewRoundedLayer.frame = panelView.bounds
        panelViewRoundedLayer.masksToBounds = true
        panelViewRoundedLayer.fillColor = UIColor.ybkPaleTwoColor().CGColor
        panelView.layer.insertSublayer(panelViewRoundedLayer, atIndex: 0)
        panelView.backgroundColor = UIColor.clearColor()
        
        // set shadow
        panelView.layer.shadowColor = UIColor.blackColor().CGColor
        panelView.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        panelView.layer.shadowOpacity = 0.3
        panelView.layer.shadowRadius = 2.0
        panelView.layer.shadowPath = roundedPath.CGPath
    }
    
    func setUpNameLabel() {
        nameLabel.textColor = UIColor.ybkCharcoalGreyColor()
        nameLabel.text = String(NSUserDefaults.standardUserDefaults().valueForKey("name")!)
    }
    
    func setUpImage(){
        profileImageView.layer.cornerRadius = CGRectGetWidth(self.profileImageView.frame)/2.0
        profileImageView.clipsToBounds = true
        opaqueView.layer.cornerRadius = CGRectGetWidth(self.opaqueView.frame)/2.0
        opaqueView.clipsToBounds = true
        
        coverImageView.image = UIImage(named: "background-profile")
        let userProfileImageUrl = String(NSUserDefaults.standardUserDefaults().valueForKey("picture")!)
        guard let nsUrl = NSURL(string: userProfileImageUrl) else{ return }
        // ImageDownloader is in helper
        ImageDownloader.sharedInstance().downloadImageWithCompletionHandler(nsUrl){
            [unowned self](data:NSData?) in
            guard let data = data else{ return }
            self.profileImageView.image = UIImage(data: data)
        }
        
    }
    
    func setUpNavbarStyle(){
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.ybkPaleGoldColor()]
        navigationController?.navigationBar.barTintColor = UIColor.ybkCharcoalGreyColor()
    }
    
    func setUpViewColor(){
        view.backgroundColor = UIColor(patternImage: UIImage(named : "pattern-wood")!)
        panelView.backgroundColor = UIColor.ybkPaleTwoColor()
    }


//MARK: open facebook page
    func openFBPage(){
      
        if let linkUrl = NSUserDefaults.standardUserDefaults().valueForKey("link"){
            let stringUrl = String(linkUrl)

            if #available(iOS 9.0, *){
                let sfvc = SFSafariViewController(URL: NSURL(string: stringUrl)!)
                sfvc.delegate = self
                self.presentViewController(sfvc, animated: false, completion: nil)
            }
            else{
                UIApplication.sharedApplication().openURL(NSURL(string: stringUrl)!)
            }
        }
    }
    

    

//MARK: FB logout action
    @IBAction func FBLogoutAction(sender: AnyObject) {
        let fbManager = FBSDKLoginManager()
        fbManager.logOut()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        UIView.transitionWithView(appDelegate.window!, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
            () -> Void in
            appDelegate.window?.rootViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController")
            }, completion: nil)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
