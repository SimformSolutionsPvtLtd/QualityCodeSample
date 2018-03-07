//
//  APIManager.swift
//  Demo
//
//  Created by Pradeep Chakoriya on 17/09/15.
//  Copyright (c) 2015 Pradeep Chakoriya Ltd All rights reserved.
//

import Foundation
 


// we need a custom serializer for AFNetworking to be able to get at response data after an error (particularly for registration errors)
class TJJSONResponseSerializer: AFJSONResponseSerializer {
    
    
}

enum APIResult : NSInteger
{
    case success = 0,fail,error
}

class APIManager {
    
    //service complition block
    typealias ServiceComplitionBlock = ([String: AnyObject]? ,APIResult)  -> Void
    
    // static properties get lazy evaluation and dispatch_once_t for free
    struct Static {
        static let instance = APIManager()
    }
    
    // this is the Swift way to do singletons
    class var apiManager: APIManager {
        return Static.instance
    }
    
    // NB: include trailing slashes in Fill In Rx endpoint strings!
    private struct APIConstants {

        // URL construction
        static let FillInRxBaseUrl       = Bundle.main.infoDictionary!["MY_API_BASE_URL_ENDPOINT"] as! String

        // NSUserDefaults persistence keys
        static let appTokenKey           = "appTokenKey"


       //endpoint identifiers
        static let loginUserEndpoint     = "User/LoginUser"
        static let forgotPassEndpoint    = "User/ForgotPassword"
        static let signUpUserEndpoint    = "User/SingupUser"

        static let getNewsEndPoint       = "News/GetNews"
        static let getNewsDetailEndPoint = "News/GetNewsDetails"
    }
    
    
    // needed for all AFNetworking requests
    let manager            = AFHTTPRequestOperationManager()
    
    // needed for session token persistence
    let userDefaults       = UserDefaults.standard
    
    // we get a session token on login from application
    var sessionToken: String? {
        get {
            return userDefaults.objectForKey(APIConstants.appTokenKey) as? String ?? ""
        }
        
        set (newValue) {
            if newValue != nil {
                userDefaults.setObject(newValue, forKey: APIConstants.appTokenKey)
                userDefaults.synchronize()
            }
        }
    }
    

    
    init()
    {
       
    }
    func clearSession()
    {
        // this is tantamount to a 'logout' from the user's perspective
        self.sessionToken = nil
        
        userDefaults.removeObjectForKey(APIConstants.PharmacyTokenKey)
    }
    
    // MARK: - Helper functions
    func makePharmacyURL(endpoint: String) -> String
    {
        // NB: include trailing slashes in Fill In Rx URL strings!
        let url = "\(APIConstants.FillInRxBaseUrl)/\(endpoint)/"
        return url
    }

    //MARK: - User api call -
    func loginUser(dic :[String: AnyObject],successClosure: ServiceComplitionBlock)
    {
        let url = makePharmacyURL(APIConstants.loginUserEndpoint)
        self.postDatadicFromUrl(url as String , dic: dic as [String: AnyObject]) { (data, result) -> Void in
            successClosure(data, result)
        }
    }
    func logOut(successClosure: ServiceComplitionBlock)
    {
       let url = makePharmacyURL(APIConstants.logOutEndpoint)
        let dic = [String: AnyObject]()
        self.postJsondicFromUrl(url as String, dic: dic as [String: AnyObject], block: { (data, result) -> Void in
            successClosure(data, result)
        })
    }
    func forgotPassword(dic :[String: AnyObject],successClosure: ServiceComplitionBlock)
    {
        let url = makePharmacyURL(APIConstants.forgotPassEndpoint)
        self.postDatadicFromUrl(url as String , dic: dic as [String: AnyObject]) { (data, result) -> Void in
            successClosure(data, result)
        }
    }

    //MARK: - News api call -
    func getNewsDetail(dic :[String: AnyObject],successClosure: ServiceComplitionBlock)
    {
        let url = makePharmacyURL(APIConstants.getNewsDetailEndPoint)
        self.postJsondicFromUrl(url as String , dic: dic as [String: AnyObject]) { (data, result) -> Void in
            successClosure(data, result)
        }
    }
    func getNews(dic :[String: AnyObject],successClosure: ServiceComplitionBlock)
    {
        let url = makePharmacyURL(APIConstants.getNewsEndPoint)
        self.postJsondicFromUrl(url as String , dic: dic as [String: AnyObject]) { (data, result) -> Void in
            successClosure(data, result)
        }
    }


    
    
    //MARK: - POST methods -
    private func postJsondicFromUrl(url : String, dic :[String: AnyObject] , block: ServiceComplitionBlock)
    {
        if let sessionStr:String = sessionToken // Add Authorization header
        {
            let tokenString:String = "bearer \(sessionStr)"
            manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
            manager.responseSerializer.acceptableContentTypes = ["application/json"]
            manager.requestSerializer = AFJSONRequestSerializer()
            manager.requestSerializer.setValue(tokenString, forHTTPHeaderField: "Authorization")
        }
        
        QL1(url)
        QL1(dic)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        // no parameters, no returns - could check 200 status? TBD
        
        manager.POST(url, parameters: dic, success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
            let responseDict = responseObject as! Dictionary<String, AnyObject>
            QL2(responseDict)
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            if responseDict["status"] as! Int == 1
            {
                block(responseObject as? [String: AnyObject] , APIResult.success)
            }
            else
            {
                block(responseObject as? [String: AnyObject] , APIResult.error)
            }
            }, failure: {
                (operation: AFHTTPRequestOperation!, error: NSError!) in
                 UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                let errorDict = ["error": error]
                QL4(error.description)
                block(errorDict as [String: AnyObject] , APIResult.fail)
        })
    }

    
    //MARK: - get methods -
    private func getDatadicFromUrl(url : String, dic :[String: AnyObject] , block: ServiceComplitionBlock)
    {

        if let sessionStr:String = sessionToken // Add Authorization header
        {
            let tokenString:String = "bearer \(sessionStr)"
            manager.requestSerializer.setValue(tokenString, forHTTPHeaderField: "Authorization")
        }
        
        QL1(url)
        QL1(dic)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        // no parameters, no returns - could check 200 status? TBD
        
        manager.GET(url, parameters: dic, success: {
               (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
               let responseDict = responseObject as! Dictionary<String, AnyObject>
            QL2(responseDict)
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
               if responseObject["status"] as! Int == 1
               {
                   block(responseObject as? [String: AnyObject] , APIResult.success)
               }
               else
               {
                   block(responseObject as? [String: AnyObject] , APIResult.error)
               }
        
               }, failure: {
                   (operation: AFHTTPRequestOperation!, error: NSError!) in
                 UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                let errorDict = ["error": error]
                QL4(error.description)
                   block(errorDict as [String: AnyObject] , APIResult.fail)
           })
    }
    
    //MARK: - name methods -
    func createProfileImageName() -> String?
    {
        //        2015-10-08T20:00:00Z
        let date = NSDate().timeIntervalSince1970
        let time = Double(date)
        return "profile_" + String(time) + ".png"
    }
}
