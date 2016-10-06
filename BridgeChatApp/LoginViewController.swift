//
//  LoginViewController.swift
//  BridgeChatApp
//
//  Login Page
//
//  Created by Sumeet on 03/10/16.
//  Copyright © 2016 com.bridgeLabz. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController
{
    //outlet of UITextField for username
    @IBOutlet weak var mUserName: UITextField!
    
    //outlet of UITextField for password
    @IBOutlet weak var mPassword: UITextField!
    
    //making object of Controller
    let controllerObj = Controller()
    
    //creating variable for storing user names
    var userNameList = [String]()
    
    //creating variabe for storing user keys
    var userKeyWithNameList = [String : String]()
    
    //creating reference variable for Firbase Database
    var mRef : FIRDatabaseReference?
    
    //making object of RestCall
    var restCallObj = RestCall()
    
    //creating variable for storing user key
    var mUserKey : String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //calling method to get user deatils
        self.getUserDetails()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //getting user details
    func getUserDetails()
    {
        controllerObj.getUserNames({ (Result,Result1) -> Void in
            self.userNameList.append(Result)
            self.userKeyWithNameList.updateValue(Result1, forKey: Result)
        })
    }
    
    //checking username exits or not
    @IBAction func signInPressed(sender: UIButton)
    {
        for name in userNameList
        {
            if mUserName.text == name
            {
                //getting reference of firebase database
                mRef = restCallObj.getReferenceFirebase()
                
                //getting key of logined user
                mUserKey = userKeyWithNameList[name]
                
                //setting status of user as online
                self.mRef!.child("Users").child(mUserKey!).child("status").setValue("online")
                
                //goto admin list page
                performSegueWithIdentifier("gotoadminListViewController", sender: self)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        //checking with identifier
        if (segue.identifier == "gotoadminListViewController")
        {
            //getting selected row
            let selectedUserName = mUserName.text
            
            // initialize new view controller and cast it as your view controller
            let destination = segue.destinationViewController as! AdminListViewController
            
            //passing value here
            destination.mSelectedUser = selectedUserName
            destination.mSelectedUserKey = mUserKey
        }
    }
    
}
