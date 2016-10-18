//
//  MessageInboxViewController.swift
//  BridgeChatApp
//
//  showing Chat conversations
//
//  Created by Sumeet on 03/10/16.
//  Copyright © 2016 com.bridgeLabz. All rights reserved.
//

import UIKit
import Firebase

class MessageInboxViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate
{
    //outlet of tableView
    @IBOutlet weak var tableView: UITableView!
    
    //outlet of UITextField
    @IBOutlet weak var mTextMessage: UITextField!
    
    //outlet of UILabel for status
    @IBOutlet weak var mStatus: UILabel!
    
    //outlet of UIButton for send button
    @IBOutlet weak var mSendButton: UIButton!
    
    //creating variable for Selected admin name
    var mSelectedAdminName : String?
    
    //creating variable for Selected admin status
    var mSelectedAdminStatus : String?
    
    //creating variable for Selected user name
    var mSelectedUserName : String?
    
    //making object of RestCall
    let mRestCallObj = RestCall()
    
    //making object of Controller
    let mControllerObj = Controller()
    
    //creating reference variable for Firbase Database
    var mRef : FIRDatabaseReference?
    
    //creating variable flag as a key to store messages
    var mFlag = 0
    
    //creating variable for storing user messages
    var mUserMessageList = [Int: String]()
    
    //creating variable for storing admin messages
    var mAdminMessageList = [Int: String]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //set delegates
        self.mTextMessage.delegate = self
        mTextMessage.autocorrectionType = UITextAutocorrectionType.No
        
        //no status
        mStatus.text = ""
        
        //adding tap gesture
        addTapGesture()
        
        //making circular corner for send button
        mSendButton.layer.cornerRadius = 8.0
        mSendButton.clipsToBounds = true
        
        //creating tableview cell dynamically
        self.tableView.estimatedRowHeight = 21
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        //calling method to get admin details
        self.getAdminDetails()
       
        //adding observer for notification to get any change in admin status
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.updateAdminStatus), name: "StatusNotification", object:nil)
        
        //adding observer for notification to get admin
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.getMessagesDetails), name: "AdminNotify", object: nil)
     
        //adding observer for notification when keyboard appears
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MessageInboxViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        //adding observer for notification when keyboard disappears
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MessageInboxViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
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
        mTextMessage.resignFirstResponder()
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
    
    //keyboard disappears then view back to its original position
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

    //back button action
    @IBAction func backButtonPressed(sender: UIBarButtonItem)
    {
        navigationController?.popViewControllerAnimated(true)
    }

    //getting admin details
    func getAdminDetails()
    {
        mControllerObj.getAdminNames({ (Result,Result1) -> Void in
            self.mSelectedAdminName = Result
            self.mSelectedAdminStatus = Result1
            
                NSNotificationCenter.defaultCenter().postNotificationName("AdminNotify", object: nil)
        })
    }
    
    //updated admin status
    func updateAdminStatus()
    {
        if mSelectedAdminStatus == "online"
        {
            mSelectedAdminStatus = "offline"
            mStatus.textColor = UIColor.redColor()
        }
        else
        {
            mSelectedAdminStatus = "online"
            mStatus.textColor = UIColor.greenColor()
        }
        mStatus.text = mSelectedAdminStatus
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        // Add a background view to the table view
        let backgroundImage = UIImage(named: "chatBackground")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
    }
   
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    //getting message details
    func getMessagesDetails()
    {
        //setting status of admin
        mStatus.text = mSelectedAdminStatus
        mStatus.textColor = UIColor.greenColor()
        
        //setting admin name
        self.title = mSelectedAdminName

        mControllerObj.getMessage(mSelectedAdminName!, userName: mSelectedUserName! , callback: { (Result,Result1) -> Void in
            
            if Result1 == 0
            {
                //getting user message
                self.mUserMessageList.updateValue(Result, forKey: self.mFlag)
                self.mFlag += 1
            }
            else
            {
                //getting admin message
                self.mAdminMessageList.updateValue(Result, forKey: self.mFlag)
                self.mFlag += 1
            }
           
            //reloading tableview
            self.tableView.reloadData()
            
            //scroll tableview to last
            self.scrollToLastRow()
        })
    }
    
    //getting no. of rows
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return mUserMessageList.count + mAdminMessageList.count
    }
    
    //getting each cell information
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellForChat", forIndexPath: indexPath) as! CustomCellChat
        cell.backgroundColor = UIColor.clearColor()
        
        //making circular corner for label
        cell.mChatLabel.layer.cornerRadius = 4.0;
        cell.mChatLabel.clipsToBounds = true
        cell.mAdminChatLabel.layer.cornerRadius = 4.0;
        cell.mAdminChatLabel.clipsToBounds = true
        
        if let message = mUserMessageList[indexPath.row]
        {
            cell.mChatLabel.backgroundColor = UIColor.lightTextColor()
            cell.mChatLabel.textColor = UIColor.magentaColor()
            cell.mChatLabel.text = message
            cell.mAdminChatLabel.text = ""
            cell.mAdminChatLabel.hidden = true
            cell.mChatLabel.hidden = false
        }
        else if let message = mAdminMessageList[indexPath.row]
        {
            cell.mAdminChatLabel.textAlignment = .Left
            cell.mAdminChatLabel.backgroundColor = UIColor.lightTextColor()
            cell.mAdminChatLabel.textColor = UIColor.brownColor()
            cell.mAdminChatLabel.text = message
            cell.mChatLabel.text = ""
            cell.mChatLabel.hidden = true
            cell.mAdminChatLabel.hidden = false
        }
        return cell
    }

    //auto scrolling for tableview
    func scrollToLastRow()
    {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastSectionLastRow = tableView.numberOfRowsInSection(lastSectionIndex) - 1
        let indexPath = NSIndexPath(forRow:lastSectionLastRow, inSection: lastSectionIndex)
        self.tableView?.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.None, animated: false)
    }
    
    //sending user messages on node
    @IBAction func sendPressed(sender: UIButton)
    {
        if mTextMessage.text?.characters.count != 0
        {
            //getting reference of firebase database
            mRef = mRestCallObj.getReferenceFirebase()

            //making node as adminName and userName combined to push user message
            mRef?.child("\(mSelectedAdminName!)\(mSelectedUserName!)").childByAutoId().child("userMsg").setValue(mTextMessage.text)
            
            //clearing text field
            mTextMessage.text = ""
        }
    }
}
