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

class LoginViewController: UIViewController,UITextFieldDelegate
{    
    //outlet of UITextField for username
    @IBOutlet weak var mUserName: UITextField!
    
    //outlet of UITextField for password
    @IBOutlet weak var mPassword: UITextField!
    
    //making object of Controller
    let controllerObj = Controller()
    
    //creating variable for storing user names
    var mUserNameList = [String]()
    
    //creating variabe for storing user keys
    var mUserKeyWithNameList = [String : String]()
    
    //creating reference variable for Firbase Database
    var mRef : FIRDatabaseReference?
    
    //making object of RestCall
    var restCallObj = RestCall()
    
    //creating variable for storing user key
    var mUserKey : String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //setting textfield delegates
        self.mUserName.delegate = self
        self.mPassword.delegate = self
        
        //adding tap gesture
        addTapGesture()
        
        //setting background image
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundImage")!)
        
        //calling method to get user deatils
        self.getUserDetails()
        
        //adding observer for notification when keyboard appears
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MessageInboxViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        //adding observer for notification when keyboard disappears
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MessageInboxViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)

    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //creating tap gesture recognizer
    func addTapGesture()
    {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(MessageInboxViewController.tap(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    //dismiss keyboard on tap
    func tap(gesture: UITapGestureRecognizer)
    {
        mUserName.resignFirstResponder()
        mPassword.resignFirstResponder()
    }
    
    //dismiss keyboard
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        mUserName.resignFirstResponder()
        mPassword.resignFirstResponder()
        return true
    }
    
    
    //move view to up when keyboard appears
    func keyboardWillShow(notification: NSNotification)
    {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()
        {
            if view.frame.origin.y == 0
            {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    //keyboard disappears view back to position
    func keyboardWillHide(notification: NSNotification)
    {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()
        {
            if view.frame.origin.y != 0
            {
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    //getting user details
    func getUserDetails()
    {
        controllerObj.getUserNames({ (Result,Result1) -> Void in
            self.mUserNameList.append(Result)
            self.mUserKeyWithNameList.updateValue(Result1, forKey: Result)
        })
    }
    
    //checking username exits or not
    @IBAction func signInPressed(sender: UIButton)
    {
        for name in mUserNameList
        {
            if mUserName.text == name
            {
                //getting reference of firebase database
                mRef = restCallObj.getReferenceFirebase()
                
                //getting key of logged user
                mUserKey = mUserKeyWithNameList[name]
                
                //setting status of user as online
                self.mRef!.child("Users").child(mUserKey!).child("status").setValue("online")
                
                //goto admin list page
                performSegueWithIdentifier("gotoMessageInboxController", sender: self)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        //checking with identifier
        if (segue.identifier == "gotoMessageInboxController")
        {
            //getting selected row
            let selectedUserName = mUserName.text
            
            // initialize new view controller and cast it as your view controller
            let destination = segue.destinationViewController as! MessageInboxViewController
            
            destination.mSelectedUserName = selectedUserName
        }
    }
}
