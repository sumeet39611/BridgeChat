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

class MessageInboxViewController: UIViewController, UITableViewDelegate,UITableViewDataSource
{
    //outlet of tableView
    @IBOutlet weak var tableView: UITableView!
    
    //outlet of UITextField
    @IBOutlet weak var mTextMessage: UITextField!
    
    //outlet of UILabel for status
    @IBOutlet weak var mStatus: UILabel!
    
    //creating variable for Selected admin name
    var mSelectedAdminName : String?
    
    //creating variable for Selected admin status
    var mSelectedAdminStatus : String?
    
    //creating variable for Selected user name
    var mSelectedUserName : String?
    
    //making object of RestCall
    let restCallObj = RestCall()
    
    //making object of Controller
    let controllerObj = Controller()
    
    //creating reference variable for Firbase Database
    var mRef : FIRDatabaseReference?
    
    //creating variable flag
    var mFlag = 0
    
    //creating variable for storing user messages
    var mUserMessageList = [Int: String]()
    
    //creating variable for storing admin messages
    var mAdminMessageList = [Int: String]()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //creating tableview cell dynamically
        self.tableView.estimatedRowHeight = 21
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        //calling method to get admin details
        self.getAdminDetails()
       
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.updateAdminStatus), name: "StatusNotification", object:nil)
        
        //adding observer for notification to get message of admin chat
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.getMessagesDetails), name: "AdminNotify", object: nil)
    }
    
    //getting admin details
    func getAdminDetails()
    {
        mUserMessageList.removeAll()
        mAdminMessageList.removeAll()
        
        controllerObj.getAdminNames({ (Result,Result1) -> Void in
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
        }
        else if mSelectedAdminStatus == "offline"
        {
            mSelectedAdminStatus = "online"
        }
        mStatus.text = mSelectedAdminStatus
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        // Add a background view to the table view
        let backgroundImage = UIImage(named: "backgroundImage")
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
        
        //setting admin name
        self.title = mSelectedAdminName
        
        controllerObj.getMessage(mSelectedAdminName!, userName: mSelectedUserName! , callback: { (Result,Result1) -> Void in
            
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
        if let message = mUserMessageList[indexPath.row]
        {
//            cell.mChatLabel.textAlignment = .Right
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
            cell.mAdminChatLabel.backgroundColor = UIColor.lightGrayColor()
            cell.mAdminChatLabel.textColor = UIColor.cyanColor()
            cell.mAdminChatLabel.text = message
            cell.mChatLabel.text = ""
            cell.mChatLabel.hidden = true
            cell.mAdminChatLabel.hidden = false
        }
        return cell
    }

    //sending user messages on node
    @IBAction func sendPressed(sender: UIButton)
    {
        if mTextMessage.text?.characters.count != 0
        {
            //getting reference of firebase database
            mRef = restCallObj.getReferenceFirebase()

            //making node as adminName and userName combine to push user message
            mRef?.child("\(mSelectedAdminName!)\(mSelectedUserName!)").childByAutoId().child("userMsg").setValue(mTextMessage.text)
            
            //clearing text field
            mTextMessage.text = ""
        }
    }
}
