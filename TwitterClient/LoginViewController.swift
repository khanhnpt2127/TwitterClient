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
      

    }
  
  @IBAction func onLogin(_ sender: UIButton) {
    TwitterAPI.sharedInstance?.requestLogin()
  }

}
