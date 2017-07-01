//
//  LoginViewController.swift
//  TwitterClient
//
//  Created by Truong Tran on 6/28/17.
//  Copyright © 2017 Truong Tran. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {
  var user: User!
  var timeLines: [TimeLine]!

    override func viewDidLoad() {
        super.viewDidLoad()
      
      if let timeLines = timeLines {
        print("******timeLines \(timeLines)")
      }

    }
  
  
  
  @IBAction func logout(_ sender: Any) {
    TwitterAPI.sharedInstance?.requestSerializer.removeAccessToken()
  }
  @IBAction func check(_ sender: Any) {
   // TwitterAPI.sharedInstance?.getUserInfo()
  }


  @IBAction func onLogin(_ sender: UIButton) {
    TwitterAPI.sharedInstance?.requestLogin()
  }

}
