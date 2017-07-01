//
//  Account.swift
//  TwitterClient
//
//  Created by Truong Tran on 6/28/17.
//  Copyright © 2017 Truong Tran. All rights reserved.
//

import UIKit

class User: NSObject {
  var name: String?
  var screenName: String?
  var profileImageUrl: URL?
  var tagline: String?
  
  init(dictionary: NSDictionary) {
    name = dictionary["name"] as? String
    screenName = dictionary["screen_name"] as? String
    tagline = dictionary["description"] as? String
    
    let profileImageURLString = dictionary["profile_image_url_https"] as? String
    if let profileImageURLString = profileImageURLString {
      profileImageUrl = URL(string: profileImageURLString)!
    }
  }
}
