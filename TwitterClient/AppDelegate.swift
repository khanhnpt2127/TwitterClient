//
//  AppDelegate.swift
//  TwitterClient
//
//  Created by Truong Tran on 6/28/17.
//  Copyright © 2017 Truong Tran. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var timeLines: [TimeLine]?
  var storyboard = UIStoryboard(name: "Main", bundle: nil)
		


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    // register defaule userDefault
    let dictionary: [String: Any] = ["isLogout": false]
    UserDefaults.standard.register(defaults: dictionary)
    
    let isLogout = UserDefaults.standard.bool(forKey: "isLogout")
    if !isLogout {
      let viewConroller = self.storyboard.instantiateViewController(withIdentifier: "TimeLineViewController")as UIViewController
      self.window?.rootViewController = viewConroller
    }
    
    loginLogoutNotification()
    
    
    
    
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }

  func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {

    TwitterAPI.sharedInstance?.halderCallback(url: url) {
      (twitterError) in
      if let error = twitterError {
        switch error {
        case .userDeny:
          print("Error user deny access twitter")
        case let .failure(error?):
          print("have error when back app \(error)")
        default:
          print("have error when back app")
        }

      } else {
        // success and move to Home timeline screen
        let viewConroller = self.storyboard.instantiateViewController(withIdentifier: "TimeLineViewController")as UIViewController
        self.window?.rootViewController = viewConroller
      }
    }
    
    
    
    
//    print("UIApplicationOpenURLOptionsKey")
//    let requestToken = BDBOAuth1Credential(queryString: url.query)
//    
//    TwitterAPI.sharedInstance?.fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (response: BDBOAuth1Credential?) in
//      
//      if let response = response {
//        print("access token = \(response.token)")
//        
//        TwitterAPI.sharedInstance?.requestSerializer.saveAccessToken(response)
//        
//        TwitterAPI.sharedInstance?.getUserInfo()
//        TwitterAPI.sharedInstance?.homeTimeline {
//          (compelete) in
//         // self.timeLines = compelete
//          
////          let navigationController = self.window!.rootViewController as!
////          LoginViewController
////          navigationController.timeLines = compelete
//          
////          let storyboard = UIStoryboard(name: "Main", bundle: nil)
////          let controller = storyboard.instantiateViewController(withIdentifier: "someViewController")
////          self.present(controller, animated: true, completion: nil)
//          
//          let viewConroller = self.storyboard.instantiateViewController(withIdentifier: "TimeLineViewController")as UIViewController
//          self.window?.rootViewController = viewConroller
//          
//          let navigationController = viewConroller as! UINavigationController
//          let controller = navigationController.viewControllers[0] as! TimeLineViewController
//          controller.timeLines = compelete
//          
//  
////          let storyboard = UIStoryboard(name: "Main", bundle: nil)
////          let viewController = storyboard.instantiateViewController(withIdentifier :"TimeLineViewController") as! UINavigationController
////          present(viewController, animated: true)
//          
////          var vc = storyboard.instantiateViewController(withIdentifier: "TimeLineViewController") as UIViewController
////          window?.rootViewController = vc
//        }
//      }
//    }, failure: { (error: Error?) in
//      print("\(String(describing: error?.localizedDescription))")
//    })
    
    
    
    
    return true
  }
  
  func loginLogoutNotification() {
    NotificationCenter.default.addObserver(forName: Notification.Name("LoginLogoutNotification"), object: nil, queue: OperationQueue.main, using: { notification in
      guard let userInfo = notification.userInfo,
        let isLogout = userInfo["isLogout"] as? Bool else {
          print("No userInfo found in notification")
          return
      }
      
      print(isLogout)
      UserDefaults.standard.set(isLogout, forKey: "isLogout")
    }
    )
  }
  
}

