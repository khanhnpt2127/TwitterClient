//
//  Account.swift
//  TwitterClient
//
//  Created by Truong Tran on 6/28/17.
//  Copyright © 2017 Truong Tran. All rights reserved.
//

import UIKit
var _currentUser: User?

class User: NSObject {
  var name: String?
  var screenName: String?
  var profileImageUrl: URL?
  var tagline: String?
  var dictionary: NSDictionary?
  
  init(dictionary: NSDictionary) {
    self.dictionary = dictionary
    name = dictionary["name"] as? String
    screenName = dictionary["screen_name"] as? String
    tagline = dictionary["description"] as? String
    
    let profileImageURLString = dictionary["profile_image_url_https"] as? String
    if let profileImageURLString = profileImageURLString {
      profileImageUrl = URL(string: profileImageURLString)!
    }
  }
  
  
  class var currentUser: User? {
    get {
      if let data = UserDefaults.standard.object(forKey: "CurrentUserKey") as? Data {
        do {
          let data = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as! NSDictionary
          User.currentUser = User(dictionary: data)
        } catch {
          print("Failed getting JSON object with data")
        }
      }
      
      return _currentUser
    }
    
    set(user) {
      _currentUser = user
      if user != nil {
        do {
          let data = try JSONSerialization.data(withJSONObject: (user?.dictionary)!, options: JSONSerialization.WritingOptions(rawValue: 0))
          UserDefaults.standard.set(data, forKey: "CurrentUserKey")
        } catch {
          print("Failed getting data with JSON object")
        }
      } else {
        UserDefaults.standard.set(nil, forKey: "CurrentUserKey")
      }
      UserDefaults.standard.synchronize()
    }
  }
}
