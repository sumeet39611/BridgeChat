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
    var adminNameList = [String]()
    
    //creating variable for storing admin status
    var adminStatusList = [String]()
    
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
        
//        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLineEtched
        
        //hiding back button
        self.navigationItem.setHidesBackButton(true, animated:true);

        //calling method to get admin details
        self.getAdminDetails()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //getting admin details
    func getAdminDetails()
    {
        controllerObj.getAdminNames({ (Result,Result1) -> Void in
            self.adminNameList.append(Result)
            self.adminStatusList.append(Result1)
            
            //reloading tableview
            self.tableView.reloadData()
        })
    }
    
    //returning no. of rows
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return adminNameList.count
    }
    
    //getting each cell information
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellForAdmin", forIndexPath: indexPath) as! CustomCellAdminList
        
        //setting admin name
        cell.mAdminNames.text = adminNameList[indexPath.row]
        
        //setting admin status
        cell.mAdminStatus.text = adminStatusList[indexPath.row]
        
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
            let selectedAdmin = adminNameList[selectedRowIndex.row]
            
            //getting selected admin status
            let selectedAdminStatus = adminStatusList[selectedRowIndex.row]
            
            // initialize new view controller and cast it as your view controller
            let destination = segue.destinationViewController as! MessageInboxViewController
            
            //passing selected user name,admin name and admin status
            destination.mSelectedAdminName = selectedAdmin
            destination.mSelectedUserName = mSelectedUser
            destination.mSelectedAdminStatus = selectedAdminStatus
            
        }
    }
    
    @IBAction func logoutPressed(sender: UIBarButtonItem)
    {
        //getting reference of firebase database
        mRef = restCallObj.getReferenceFirebase()
        
        //setting status of user as offline
        self.mRef!.child("Users").child(mSelectedUserKey!).child("status").setValue("offline")
        
        //goto home page
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    
    

}
