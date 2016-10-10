//
//  AdminListViewController.swift
//  BridgeChatApp
//
//  Showing Admin List
//
//  Created by Sumeet on 03/10/16.
//  Copyright © 2016 com.bridgeLabz. All rights reserved.
//

import UIKit
import Firebase

class AdminListViewController: UIViewController , UITableViewDelegate, UITableViewDataSource
{
    //making object of Controller
    let controllerObj = Controller()
    
    //creating variable for storing admin names
    var mAdminNameList = [String]()
    
    //creating variable for storing admin status
    var mAdminStatusList = [String]()
    
    //outlet of UITableView
    @IBOutlet weak var tableView: UITableView!
    
    //creating variable for storing login user
    var mSelectedUser : String?
    
    //creating reference variable for Firbase Database
    var mRef : FIRDatabaseReference?
    
    //making object of RestCall
    var restCallObj = RestCall()
    
    //creating variable for storing user key
    var mSelectedUserKey : String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    
        //hiding back button
        self.navigationItem.setHidesBackButton(true, animated:true);

        //calling method to get admin details
        self.getAdminDetails()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.updateChildInfo), name: "MyNotification", object:nil)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //getting admin details
    func getAdminDetails()
    {
        controllerObj.getAdminNames({ (Result,Result1) -> Void in
            self.mAdminNameList.append(Result)
            self.mAdminStatusList.append(Result1)
            
            //reloading tableview
            self.tableView.reloadData()
        })
    }
    
    //returning no. of rows
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return mAdminNameList.count
    }
    
    //getting each cell information
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellForAdmin", forIndexPath: indexPath) as! CustomCellAdminList
        
        //setting admin name
        cell.mAdminNames.text = mAdminNameList[indexPath.row]
        
        //setting admin status
        //cell.mAdminStatus.text = mAdminStatusList[indexPath.row]
        
        cell.mImageView.layer.cornerRadius = cell.mImageView.frame.height/2
        
        
        if mAdminStatusList[indexPath.row] == "online"
        {
            cell.mImageView.backgroundColor = UIColor.greenColor()
        }
        else if mAdminStatusList[indexPath.row] == "offline"
        {
            cell.mImageView.backgroundColor = UIColor.redColor()
        }
        
        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        //checking with identifier
        if (segue.identifier == "gotoMessageInboxViewController")
        {
            //getting selected row
            let selectedRowIndex = self.tableView.indexPathForSelectedRow!
            
            //getting selected admin
            let selectedAdmin = mAdminNameList[selectedRowIndex.row]
            
            //getting selected admin status
            let selectedAdminStatus = mAdminStatusList[selectedRowIndex.row]
            
            // initialize new view controller and cast it as your view controller
            let destination = segue.destinationViewController as! MessageInboxViewController
            
            //passing selected user name,admin name and admin status
            destination.mSelectedAdminName = selectedAdmin
            destination.mSelectedUserName = mSelectedUser
            destination.mSelectedAdminStatus = selectedAdminStatus
        }
    }
    
    //on click of logout button
    @IBAction func logoutPressed(sender: UIBarButtonItem)
    {
        //getting reference of firebase database
        mRef = restCallObj.getReferenceFirebase()
        
        //setting status of user as offline
        self.mRef!.child("Users").child(mSelectedUserKey!).child("status").setValue("offline")
        
        //goto home page
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    // updating child on any change
    func updateChildInfo(notification: NSNotification)
    {
        let adminName = notification.userInfo?["success"] as! String
        var index = 0
        for name in mAdminNameList
        {
            if adminName == name
            {
                break
            }
            index += 1
        }
        
        //updating admin status
        if mAdminStatusList[index] == "online"
        {
            mAdminStatusList[index] = "offline"
        }
        else if mAdminStatusList[index] == "offline"
        {
            mAdminStatusList[index] = "online"
        }
        
        //reloading tableview
        tableView.reloadData()
    }

}
