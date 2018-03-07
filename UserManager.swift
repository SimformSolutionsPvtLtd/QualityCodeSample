//
//  UserManager.swift
//  Demo
//
//  Created by Pradeep Chakoriya on 17/09/15.
//  Copyright (c) 2015 Pradeep Chakoriya Ltd All rights reserved.
//


import Foundation
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotificaiton = "userDidLogoutNotification"
let refreshUserDataNotification = "refreshUserDataNotification"

private struct TJUserConstants {
    
    // NSUserDefaults persistence keys
    static let userIdKey              = "userIdKey"
    static let EmailKey               = "EmailKey"
    static let FirstnameKey           = "FirstnameKey"
    static let LastnameKey            = "LastnameKey"
    static let fullnameKey            = "fullnameKey"
    static let ProfileImageKey        = "ProfileImage"
    static let PhoneNumberKey         = "PhoneNumber"
    
    static let isVerified             = "isVerified"
    static let isEmailVerified        = "isEmailVerified"
    static let isBasicProfile         = "isBasicProfile"
    static let isAdcanceProf          = "isAdcanceProf"
    static let roleId                 = "roleId"
    
}

class UserManager {
    
    // static properties get lazy evaluation and dispatch_once_t for free
    struct Static {
        static let instance = UserManager()
    }
    
    // this is the Swift way to do singletons
    class var userManager: UserManager
    {
        return Static.instance
    }
    
    // user authentication always begins with a UUID
    let userDefaults = UserDefaults.standard

    
    // username etc. are backed by NSUserDefaults, no need for further local storage
    
    //user emailAddress
    var emailAddress: String? {
        
        get {
            return userDefaults.objectForKey(TJUserConstants.EmailKey) as? String ?? nil
        }
        
        set (newValue) {
            userDefaults.setObject(newValue, forKey: TJUserConstants.EmailKey)
            userDefaults.synchronize()
        }
        
    }
    // user firstname
    var firstname: String? {
        
        get {
            return userDefaults.objectForKey(TJUserConstants.FirstnameKey) as? String ?? nil
        }
        
        set (newValue) {
            userDefaults.setObject(newValue, forKey: TJUserConstants.FirstnameKey)
            userDefaults.synchronize()
        }
        
    }
    
    //user role in app
    // 2 for pharmasict
    // 3 for owner
    var roleId: String? {
        
        get {
            return userDefaults.objectForKey(TJUserConstants.roleId) as? String ?? nil
        }
        
        set (newValue) {
            userDefaults.setObject(newValue, forKey: TJUserConstants.roleId)
            userDefaults.synchronize()
        }
        
    }
    
    var PhoneNumber: String? {
        
        get {
            return userDefaults.objectForKey(TJUserConstants.PhoneNumberKey) as? String ?? nil
        }
        
        set (newValue) {
            userDefaults.setObject(newValue, forKey: TJUserConstants.PhoneNumberKey)
            userDefaults.synchronize()
        }
        
    }
    //check verification status
    //if false then, now allowed to navigate to home screen
    var isEmailVerified: String? {
        
        get {
            return userDefaults.objectForKey(TJUserConstants.isEmailVerified) as? String ?? nil
        }
        
        set (newValue) {
            userDefaults.setObject(newValue, forKey: TJUserConstants.isEmailVerified)
            userDefaults.synchronize()
        }
        
    }
    // check advance profile status
    // if advance rofile filled then and then , user will allow to post job
    var isAdcanceProf: String?  {
        
        get {
            return userDefaults.objectForKey(TJUserConstants.isAdcanceProf) as? String ?? nil
        }
        
        set (newValue) {
            userDefaults.setObject(newValue, forKey: TJUserConstants.isAdcanceProf)
            userDefaults.synchronize()
        }
        
    }
    
    //check license verification status
    var isVerified: String? {
        
        get {
            return userDefaults.objectForKey(TJUserConstants.isVerified) as? String ?? nil
        }
        
        set (newValue) {
            userDefaults.setObject(newValue, forKey: TJUserConstants.isVerified)
            userDefaults.synchronize()
        }
        
    }
    var isBasicProfile: String? {
        
        get {
            return userDefaults.objectForKey(TJUserConstants.isBasicProfile) as? String ?? nil
        }
        
        set (newValue) {
            userDefaults.setObject(newValue, forKey: TJUserConstants.isBasicProfile)
            userDefaults.synchronize()
        }
        
    }
    var fullName: String? {
        
        get {
            return userDefaults.objectForKey(TJUserConstants.fullnameKey) as? String ?? nil
        }
        
        set (newValue) {
            userDefaults.setObject(newValue, forKey: TJUserConstants.fullnameKey)
            userDefaults.synchronize()
        }
        
    }
    var lastname: String? {
        
        get {
            return userDefaults.objectForKey(TJUserConstants.LastnameKey) as? String ?? nil
        }
        
        set (newValue) {
            userDefaults.setObject(newValue, forKey: TJUserConstants.LastnameKey)
            userDefaults.synchronize()
        }
        
    }
    
    var profileImage: String? {
        
        get {
            return userDefaults.objectForKey(TJUserConstants.ProfileImageKey) as? String ?? nil
        }
        
        set (newValue) {
            userDefaults.setObject(newValue, forKey: TJUserConstants.ProfileImageKey)
            userDefaults.synchronize()
        }
        
    }
    
    var userId: String?
        {
        get {
            return userDefaults.objectForKey(TJUserConstants.userIdKey) as? String ?? nil
        }
        
        set (newValue) {
            userDefaults.setObject(newValue, forKey: TJUserConstants.userIdKey)
            userDefaults.synchronize()
        }
    }
    
    func clearUUID()
    {
        //NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotificaiton, object: nil)
        self.firstname          = nil
        self.lastname           = nil
        self.emailAddress       = nil
        self.profileImage       = nil
        self.userId             = nil
        self.fullName           = nil
        self.roleId             = nil
        self.isEmailVerified    = nil
        self.isBasicProfile     = nil
        self.isAdcanceProf      = nil
        self.isVerified         = nil
        self.PhoneNumber        = nil
        mgr.clearSession()
        
        // this works because the TJUserManager will recreate a UUID on next access, & Validate() etc. will do the rest
        userDefaults.removeObjectForKey(TJUserConstants.FirstnameKey)
        userDefaults.removeObjectForKey(TJUserConstants.LastnameKey)
        userDefaults.removeObjectForKey(TJUserConstants.EmailKey)
        userDefaults.removeObjectForKey(TJUserConstants.ProfileImageKey)
        userDefaults.removeObjectForKey(TJUserConstants.userIdKey)
        userDefaults.removeObjectForKey(TJUserConstants.fullnameKey)
        userDefaults.removeObjectForKey(TJUserConstants.isEmailVerified)
        userDefaults.removeObjectForKey(TJUserConstants.isBasicProfile)
        userDefaults.removeObjectForKey(TJUserConstants.isAdcanceProf)
        userDefaults.removeObjectForKey(TJUserConstants.roleId)
        userDefaults.removeObjectForKey(TJUserConstants.isVerified)
        userDefaults.removeObjectForKey(TJUserConstants.PhoneNumberKey)
        
        let coreData = CoreDataHelper.coreDataHelper
        coreData.deleteDataFromEntity(dataModel.UserSoftwaresDataModel)
        
        userDefaults.synchronize()
    }
}
