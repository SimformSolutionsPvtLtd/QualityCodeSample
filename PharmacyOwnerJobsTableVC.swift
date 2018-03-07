//
//  listVC.swift
//  Demo
//
//  Created by Pradeep Chakoriya on 17/09/15.
//  Copyright (c) 2015 Pradeep Chakoriya Ltd All rights reserved.
//

import UIKit
import DGElasticPullToRefresh
class PharmacyOwnerJobsTableVC: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var tblView: UITableView!
    // MARK: - Variables
    var pageNo : Int        = 1
    var totalPageCount :Int = 0
    var isBusyFetching:Bool = false
    var dataSource:TableViewDataSource?
    var pageSize : Int      = 30

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set up dataSource for tableview
        self.setUpDataSource()
        
        //addPullToRefresh
        self.addPullToRefresh()
        
        //API call
        self.getPostedJobs()
    }
    func addPullToRefresh()
    {
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor.whiteColor()
        tblView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            self?.pageNo = 1
            self?.getPostedJobs()
            self?.tblView.dg_stopLoading()
            }, loadingView: loadingView)
        tblView.dg_setPullToRefreshFillColor(colors.kSkyColor)
        tblView.dg_setPullToRefreshBackgroundColor(UIColor.whiteColor())
    }
    deinit {
        if tblView != nil
        {
            tblView.dg_removePullToRefresh()
        }
    }
    
    func setUpDataSource()
    {
        
        self.dataSource = TableViewDataSource(items: [OwnerCompletedJobs](), cellIdentifier: "OwnerCompletedJobCell", configureBlock: { (cell, item) -> () in
            if let actualCell = cell as? OwnerCompletedJobCell {
                if let actualItem = item as? OwnerCompletedJobs {
                    actualCell.configureForItem(actualItem)
                }
            }
            }, paginationBlock: { (index) -> () in
                print("pagination")
                if self.pageNo < self.totalPageCount && !self.isBusyFetching
                {
                    self.pageNo++
                    self.getPostedJobs() //append new data in datasource
                }
        })
        
        //finally, set the tableview datasource
        self.tblView.dataSource = self.dataSource
    }
    
    func getPostedJobs()
    {
        let params = ["pageNumber" : pageNo , "pageSize" : pageSize , "isCompleted" : false]
        if !mainInstance.connected()
        {
            SVProgressHUD.dismiss()
            return
        }
        SVProgressHUD.show()
        self.isBusyFetching = true
        mgr.fetchPharmacyOwnerPostedJobs(params as [String : AnyObject]) { (responseObject, result) -> Void in
        self.isBusyFetching = false
            SVProgressHUD.dismiss()
            if result == APIResult.APISuccess
            {
                if self.pageNo == 1
                {
                    self.dataSource?.items.removeAll()
                }
                if let tempTotal : Int = responseObject?.valueForKey("pageCount") as? Int
                {
                    self.totalPageCount = tempTotal
                }
                if let arrTemp : [AnyObject] = responseObject?.valueForKey("job") as? [AnyObject]
                {
                    for var i : Int = 0 ; i < arrTemp.count ; i++
                    {
                            let json:OwnerCompletedJobs = OwnerCompletedJobs.Populate(arrTemp.objectAtIndex(i) as! [String : AnyObject])
                            self.dataSource?.items.append(json)
                    }
                }
                self.tblView.reloadData()
            }
            else if result == APIResult.APIError
            {
                if self.pageNo > 1
                {
                    self.pageNo--
                }
                mainInstance.checkForStatus(responseObject!)
            }
            else
            {
                if self.pageNo > 1
                {
                    self.pageNo--
                }
                mainInstance.showSomethingWentWrong()
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension PharmacyOwnerJobsTableVC: DZNEmptyDataSetSource ,DZNEmptyDataSetDelegate
{
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        
        let strTitle : String = "You have no job posted yet"
        let finalString = NSMutableAttributedString(string: strTitle, attributes: constant.textAttrib)
        return finalString
    }
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "logo_medium")
    }
    func emptyDataSetShouldAllowScroll(scrollView: UIScrollView) -> Bool {
        return true
    }
}
//MARK : - uitableview delegates -
extension PharmacyOwnerJobsTableVC : UITableViewDelegate
{

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 190
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if let job : OwnerCompletedJobs = self.dataSource?.items[indexPath.row] as? OwnerCompletedJobs
        {
            objJobDetails.strJobid = job.postedJobId.toString
            self.showViewController(objJobDetails, sender: nil)
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 10
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 0.01
    }
}
