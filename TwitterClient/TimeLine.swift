//
//  Timeline.swift
//  TwitterClient
//
//  Created by Truong Tran on 6/28/17.
//  Copyright © 2017 Truong Tran. All rights reserved.
//

import UIKit

class TimeLine: NSObject {
  var user: User?
  var UserRetweet: User?
  var id: Int?
  var idStr: String?
		
		
  var text: String?
  var createdAtString: String?
  var createdAt: Date?
  var timeSinceCreated: String?
  var retweetStatus: NSDictionary?
  
  var favorited = false
  var retweeted = false
  
  var retweetCount = 0
  var favCount = 0
  
 // var mediaArray: [[String: Any]]?
  var photos: [TweetPhoto]?
  
  
  init(dictionary: NSDictionary) {
    
    retweetStatus = dictionary["retweeted_status"] as? NSDictionary
    
    // if reweetstatus != nill then get status from origial
    
    if retweetStatus != nil {
      
      UserRetweet = User(dictionary: dictionary["user"] as! NSDictionary)
      user = User(dictionary: retweetStatus!["user"] as! NSDictionary)
      
      
      let entitiesDict = retweetStatus!["entities"] as? [String: Any]
        
      let mediaArray = entitiesDict!["media"] as? [[String: Any]]
      
      if let mediaDictArray = mediaArray {
        photos =  mediaDictArray.map { (mediaDict) -> TweetPhoto in
          TweetPhoto(photoDict: mediaDict)
        }
      }
      
      idStr = retweetStatus!["id_str"] as? String
      id = retweetStatus!["id"] as? Int
      favorited = retweetStatus!["favorited"] as? Bool ?? false
      retweeted = retweetStatus!["retweeted"] as? Bool ?? false
      text = retweetStatus!["text"] as? String
      createdAtString = retweetStatus!["created_at"] as? String
      retweetCount = (retweetStatus!["retweet_count"] as? Int)!
      favCount = (retweetStatus!["favorite_count"] as? Int)!
      retweetStatus = retweetStatus!["retweeted_status"] as? NSDictionary
      
      let formatter = DateFormatter()
      formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
      createdAt = formatter.date(from: createdAtString!)
      
      let elapsedTime = Date().timeIntervalSince(createdAt!)
      
      if elapsedTime < 60 {
        timeSinceCreated = String(Int(elapsedTime)) + "s"
      } else if elapsedTime < 3600 {
        timeSinceCreated = String(Int(elapsedTime / 60)) + "m"
      } else if elapsedTime < 24*3600 {
        timeSinceCreated = String(Int(elapsedTime / 60 / 60)) + "h"
      } else {
        timeSinceCreated = String(Int(elapsedTime / 60 / 60 / 24)) + "d"
      }
      
    }
    else {
      user = User(dictionary: dictionary["user"] as! NSDictionary)
      text = dictionary["text"] as? String
      
      let entitiesDict = dictionary["entities"] as? [String: Any]
      
      let mediaArray = entitiesDict!["media"] as? [[String: Any]]
      
      if let mediaDictArray = mediaArray {
        photos =  mediaDictArray.map { (mediaDict) -> TweetPhoto in
          TweetPhoto(photoDict: mediaDict)
        }
      }
      
      
      idStr = dictionary["id_str"] as? String
      id = dictionary["id"] as? Int
      favorited = dictionary["favorited"] as? Bool ?? false
      retweeted = dictionary["retweeted"] as? Bool ?? false
      createdAtString = dictionary["created_at"] as? String
      retweetCount = (dictionary["retweet_count"] as? Int)!
      favCount = (dictionary["favorite_count"] as? Int)!
      retweetStatus = dictionary["retweeted_status"] as? NSDictionary
      
      let formatter = DateFormatter()
      formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
      createdAt = formatter.date(from: createdAtString!)
      
      let elapsedTime = Date().timeIntervalSince(createdAt!)
      
      if elapsedTime < 60 {
        timeSinceCreated = String(Int(elapsedTime)) + "s"
      } else if elapsedTime < 3600 {
        timeSinceCreated = String(Int(elapsedTime / 60)) + "m"
      } else if elapsedTime < 24*3600 {
        timeSinceCreated = String(Int(elapsedTime / 60 / 60)) + "h"
      } else {
        timeSinceCreated = String(Int(elapsedTime / 60 / 60 / 24)) + "d"
      }
      
    }
  }
}



