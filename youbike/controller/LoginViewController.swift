//
//  LoginViewController.swift
//  youbike
//
//  Created by howard hsien on 2016/5/10.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

class LoginViewController: UIViewController {
   
    
    @IBOutlet weak var FBLoginButton: UIButton!
    
    @IBOutlet weak var whiteButtonFilterView: UIView!
    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var logoImage: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLoggedIn()
        setupBackground()
        setupPageStyle()
        setupLoginButton()

    }
    
    //login page hide status bar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func checkLoggedIn(){
        if (FBSDKAccessToken.currentAccessToken()==nil){
            print("not logged in")
            //not logged in -> remain in the loggin page
          
        }
        else{
            print("logged in")
                       //
        }

    }
    
    func setupLoginButton() {
        whiteButtonFilterView.userInteractionEnabled = false
        FBLoginButton.backgroundColor = UIColor.ybkDenimBlueColor()
        FBLoginButton.setTitle("Log in with Facebook", forState: UIControlState.Normal)
        FBLoginButton.setTitleColor(UIColor.ybkWhiteColor(), forState: UIControlState.Normal)
        FBLoginButton.titleLabel?.font = UIFont.ybkTextStyleFBLoginButtonFont(20)
        FBLoginButton.layer.cornerRadius = 10.0
        
    }
    
    func setupBackground(){
        guard let backgroundImage = UIImage(named: "pattern-wood.png") else {
            print("backgroundImage in LoginPageViewController is nil")
            return
        }
        self.view.backgroundColor = UIColor(patternImage: backgroundImage)
    }
    
    func setupPageStyle(){
        logoLabel.textColor = UIColor.ybkCharcoalGreyColor()
        
        //set logo to be rounded
        logoImage.layer.cornerRadius = CGRectGetWidth(self.logoImage.frame)/2.0
        logoImage.layer.masksToBounds = false
        logoImage.layer.borderWidth = 1
        logoImage.clipsToBounds = true
        logoImage.backgroundColor = UIColor.ybkPaleColor()
        logoImage.layer.borderColor = UIColor.ybkCharcoalGreyColor().CGColor
        
    }
  
    @IBAction func fbLogin(sender: AnyObject) {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
       
        fbLoginManager.logInWithReadPermissions(["email"], fromViewController: self) { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result
                if(fbloginresult.isCancelled){
                    print("fbLogin is cancelled")
                }
                else if(fbloginresult.grantedPermissions.contains("email"))
                {
            //        print(result)
                    self.getAndSaveFBUserData()
                    let tabBarController = self.storyboard?.instantiateViewControllerWithIdentifier("TabBarController") as! TabBarController
                    self.presentViewController(tabBarController, animated: false, completion: nil)
                }
            }
        }
    }
    
    func getAndSaveFBUserData(){
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "name, link, picture.type(large), email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if (error == nil){
                    print(result)
                    let userDefaults = NSUserDefaults.standardUserDefaults()
                    userDefaults.setValue(result["name"], forKey: "name")
                    userDefaults.setValue(result["email"], forKey: "email")
                    userDefaults.setValue(result["link"], forKey: "link")
                    if let pictureObject = result["picture"]{
                        let pictureData = pictureObject!["data"]
                        if let pictureUrl = pictureData!!["url"]{
                            userDefaults.setValue(pictureUrl, forKey:"picture" )
                        }
                    }
                }
                else{
                    print(error)
                }
            })
        }
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
