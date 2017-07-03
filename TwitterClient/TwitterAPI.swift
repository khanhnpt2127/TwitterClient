//
//  TwitterAPI.swift
//  TwitterClient
//
//  Created by Truong Tran on 6/28/17.
//  Copyright © 2017 Truong Tran. All rights reserved.
//

import UIKit
import BDBOAuth1Manager
let baseUrl = URL(string: "https://api.twitter.com/")
let consumerKey = "KB4Ga2sIELpkELheukrxP3YSh"
let consumerSecret = "CVLkVNyp6VSFjwX3B7vfIgcfoPxqGZJu2cMLwaufFmmXxBGH22"

enum TwitterError {
  case userDeny
  case failure(Error?)
}

class TwitterAPI: BDBOAuth1SessionManager {
  static var sharedInstance = TwitterAPI(baseURL: baseUrl, consumerKey: consumerKey, consumerSecret: consumerSecret)
  
  func requestLogin() {
    // remove access token
    TwitterAPI.sharedInstance?.requestSerializer.removeAccessToken()
    // to make sure whoever login before, loutout first
    TwitterAPI.sharedInstance?.deauthorize()
    
    TwitterAPI.sharedInstance?.fetchRequestToken(withPath: "oauth/request_token", method: "POST", callbackURL: URL(string: "TwitterClient://"), scope: nil, success: { (response: BDBOAuth1Credential?) in
      
      if let response = response {
        print(response.token)
        
        let authURL = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(response.token!)")
        
        UIApplication.shared.open(authURL!, options: [:], completionHandler: nil)
      }
      
    }, failure: { (error: Error?) in
      print("\(String(describing: error?.localizedDescription))")
    })
  }
  
  
  // MARK: - Get user info
  
  func getUserInfo(complete: @escaping (User) -> Void) {
    _ = get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (_: URLSessionDataTask, response: Any?) in
      if let response = response  {
        let user = User(dictionary: response as! NSDictionary)
        
        complete(user)
      }
      
    }, failure: { (_: URLSessionDataTask?, error: Error) in
      print("\(error.localizedDescription)")
    })
  }
  
  // MARK: - Get home time line
  
  func homeTimeline(complete: @escaping ([TimeLine]?, Error?) -> Void) {
    _ = get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (_: URLSessionDataTask, response: Any?) in
      if let response = response  {
        let dictionaryResponse = response as! [NSDictionary]
        
        print("***Success get home Timeline")
        
        var timeLineArray = [TimeLine]()
        for dictionary in dictionaryResponse {
          let tileLine = TimeLine(dictionary: dictionary)
          
          timeLineArray.append(tileLine)
          // print("\(String(describing: tileLine.user!.name!)) : \(tileLine.text!)")
        }
        
        complete(timeLineArray, nil)
        
      }
      
    }, failure: { (_: URLSessionDataTask?, error: Error) in
      complete(nil, error)

    })
  }
  
  // MARK: - Favorite
  
  func favoriteStatus(id: String?, complete: @escaping (TimeLine? ,Error?) -> Void) {
    _ = post("1.1/favorites/create.json", parameters: NSDictionary(dictionary: ["id": id!]), progress: nil, success: { (_: URLSessionDataTask, response: Any?) in
      if response != nil  {
        complete(TimeLine(dictionary: response as! NSDictionary) ,nil)
        
      }
      
    }, failure: { (_: URLSessionDataTask?, error: Error) in
      complete(nil, error)
      
    })
  }
  
  
  // MARK: - Retweet
  
  func retweetStatus(id: String?, complete: @escaping (TimeLine? ,Error?) -> Void) {
    _ = post("1.1/statuses/retweet/\(id!).json", parameters: nil, progress: nil, success: { (_: URLSessionDataTask, response: Any?) in
      if response != nil  {
        complete(TimeLine(dictionary: response as! NSDictionary) ,nil)
        
      }
      
    }, failure: { (_: URLSessionDataTask?, error: Error) in
      complete(nil, error)
      
    })
  }
  
  // MARK: - UnFavorite
  
  func unFavoriteStatus(id: String?, complete: @escaping (TimeLine? ,Error?) -> Void) {
    _ = post("1.1/favorites/destroy.json", parameters: NSDictionary(dictionary: ["id": id!]), progress: nil, success: { (_: URLSessionDataTask, response: Any?) in
      if response != nil  {
        complete(TimeLine(dictionary: response as! NSDictionary) ,nil)
        
      }
      
    }, failure: { (_: URLSessionDataTask?, error: Error) in
      complete(nil, error)
      
    })
  }
  
  // MARK: - UnRetweet
  
  func unRetweetStatus(id: String?, complete: @escaping (TimeLine? ,Error?) -> Void) {
    _ = post("1.1/statuses/unretweet/\(id!).json", parameters: nil, progress: nil, success: { (_: URLSessionDataTask, response: Any?) in
      if response != nil  {
        complete(TimeLine(dictionary: response as! NSDictionary) ,nil)
        
      }
      
    }, failure: { (_: URLSessionDataTask?, error: Error) in
      complete(nil, error)
      
    })
  }
  
  
  
  // MARK: - Create and Reply Twitter
  
  func createTwitterStatus(parameters: NSDictionary, complete: @escaping (TimeLine?, Error?) -> Void) {
    _ = TwitterAPI.sharedInstance?.post("1.1/statuses/update.json", parameters: parameters, progress: nil, success: { (_: URLSessionDataTask, response: Any?) in
      if response != nil  {
        complete(TimeLine(dictionary: response as! NSDictionary) ,nil)
        
      }
      
    }, failure: { (_: URLSessionDataTask?, error: Error) in
      complete(nil, error)
      
    })
  }
  
  
  
  
  // MARK: - Halder callback
  
  func halderCallback(url: URL, complete: @escaping (TwitterError?) -> Void) {
    
    let stringUrl = "\(url)"
    //check if user denied app
    if (stringUrl.range(of: "denied") != nil) {
      complete(TwitterError.userDeny)
      return
    } else {
      
      let requestToken = BDBOAuth1Credential(queryString: url.query)
      
      TwitterAPI.sharedInstance?.fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (response: BDBOAuth1Credential?) in
        
        if let response = response {
          print("access token = \(response.token)")
          self.getUserInfo {
            (user) in
            User.currentUser = user
          }
          
          // save access token
          TwitterAPI.sharedInstance?.requestSerializer.saveAccessToken(response)
          
          // send Notification login success
          NotificationCenter.default.post(name: Notification.Name("LoginLogoutNotification"), object: nil, userInfo:["isLogout": false])
          complete(nil)
          
        }
      }, failure: { (error: Error?) in
        //print("\(String(describing: error?.localizedDescription))")
        complete(TwitterError.failure(error))
      })
    }
    
  }
  
  
}
