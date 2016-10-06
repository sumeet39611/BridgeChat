//
//  RegisterViewController.swift
//  BridgeChatApp
//
//  Sign Up page
//
//  Created by Sumeet on 03/10/16.
//  Copyright © 2016 com.bridgeLabz. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController
{
    //outlet of UITextField for username
    @IBOutlet weak var mUserNameText: UITextField!
    
    //outlet of UITextField for password
    @IBOutlet weak var mPasswordText: UITextField!
    
    //outlet of UITextField for confirm password
    @IBOutlet weak var mConfirmPasswordText: UITextField!
    
    //creating reference variable for Firbase Database
    var mRef : FIRDatabaseReference?

    //creating variable for storing user key
    var mKey : String?
    
    //creating object for RestCall
    let restCallObj = RestCall()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //registering user deatils in firebase
    @IBAction func signUpPressed(sender: UIButton)
    {
        //checking fields are empty or not
        if ((mUserNameText.text?.characters.count != 0) && (mPasswordText.text?.characters.count != 0) && (mConfirmPasswordText.text?.characters.count != 0))
        {
            //getting reference of firebase database
            mRef = restCallObj.getReferenceFirebase()
            
            //generating user key
            mKey = mRef?.childByAutoId().key
            
            //storing user data in firebase database
            self.mRef!.child("Users").child(mKey!).child("username").setValue(mUserNameText.text)
            
            self.mRef!.child("Users").child(mKey!).child("status").setValue("offline")
            
            
            //goto login page
            performSegueWithIdentifier("gotoLoginFromRegister", sender: self)
        }
        else
        {
            //displaying alert message
            displayMyAlertMessage("Please entered username and password")
        }
    }
    
    //creating alert message
    func displayMyAlertMessage(errorMessage : String)
    {
        //making alert controller with specific message
        let myAlert = UIAlertController(title: "Alert", message: errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        //making OK action
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        
        //adding action to alert
        myAlert.addAction(okAction)
        
        //adding alert to register view
        self.presentViewController(myAlert, animated: true, completion: nil)
    }

}
