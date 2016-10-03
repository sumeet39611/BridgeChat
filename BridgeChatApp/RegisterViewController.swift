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
    var ref : FIRDatabaseReference?

    //creating variable for storing user key
    var key : String?
    
    //creating object for RestCall
    let restCallObj = RestCall()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //registering user deatils in firebase
    @IBAction func signUpPressed(sender: UIButton)
    {
        //checking fields are empty or not
        if ((mUserNameText.text?.characters.count != 0) && (mPasswordText.text?.characters.count != 0) && (mConfirmPasswordText.text?.characters.count != 0))
        {
            //getting reference of firebase database
            ref = restCallObj.getReferenceFirebase()
            
            //generating user key
            key = ref?.childByAutoId().key
            
            //storing data in firebase database
            self.ref!.child("Users").child(key!).child("username").setValue(mUserNameText.text)
            
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
