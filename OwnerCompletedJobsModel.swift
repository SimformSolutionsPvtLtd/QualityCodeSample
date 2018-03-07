//
//  OwnerCompletedJobsModel.swift
//  Demo
//
//  Created by Pradeep Chakoriya on 17/09/15.
//  Copyright (c) 2015 Pradeep Chakoriya Ltd All rights reserved.
//

import Foundation

class OwnerCompletedJobs
{
    var postedJobId:Int        = 0
    var title:String           = ""
    var date:String            = ""
    var from:String            = ""
    var to:String              = ""
    var postedOn:String        = ""
    var minPay:Int             = 0
    var maxPay:Int             = 0
    var isImunizable:Bool      = false
    var request:Int            = 0
    var status:Int             = 0
    var hiredPharmacist:String = ""
    var ratings:Int            = 0

    //MARK: - Populate variables -
    func Populate(dictionary:[String : AnyObject]) {
        postedJobId         = dictionary["postedJobId"] as! Int
        title               = dictionary["title"] as! String
        date                = dictionary["date"] as! String
        from                = dictionary["from"] as! String
        to                  = dictionary["to"] as! String
        postedOn            = dictionary["postedOn"] as! String
        minPay              = dictionary["minPay"] as! Int
        maxPay              = dictionary["maxPay"] as! Int
        isImunizable        = dictionary["isImunizable"] as! Bool
        request             = dictionary["request"] as! Int
        status              = dictionary["status"] as! Int
        hiredPharmacist     = dictionary["hiredPharmacist"] as! String
        ratings             = dictionary["ratings"] as! Int
    }
    
    class func Populate(dictionary:[String : AnyObject]) -> OwnerCompletedJobs
    {
        let result = OwnerCompletedJobs()
        result.Populate(dictionary)
        return result
    }
    
}
extension OwnerCompletedJobs
{
    func getDurationDate() -> String
    {
        return self.getProperDurationDate(date)
    }
    func getPostedDate() -> String
    {
        return self.getProperPostedDate(postedOn)
    }
    private func getProperDurationDate(strDate:String) -> String
    {
        let formate = DateFormatter()
        formate.dateFormat = "MM/dd/yyyy"
        if let date = formate.dateFromString(strDate)
        {
            formate.dateFormat =  "MMM d, yyyy" //Jun 1, 2010
            return formate.stringFromDate(date)
        }
        return strDate
    }
    private func getProperPostedDate(strDate:String) -> String
    {
        let formate = DateFormatter()
        formate.dateFormat = "MM/dd/yyyy"
        if let date = formate.dateFromString(strDate)
        {
            formate.dateFormat = "MMM dd yyyy" //Jun 01 2010
            return formate.stringFromDate(date).uppercaseString
        }
        return strDate.uppercaseString
    }
}


