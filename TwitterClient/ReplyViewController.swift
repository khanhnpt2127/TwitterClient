//
//  ReplyViewController.swift
//  TwitterClient
//
//  Created by Truong Tran on 7/2/17.
//  Copyright © 2017 Truong Tran. All rights reserved.
//

import UIKit

class ReplyViewController: UIViewController {

  @IBOutlet weak var textView: UITextView!
  @IBOutlet weak var screenNameLabel: UILabel!
  
  var timeLine: TimeLine!
  
    override func viewDidLoad() {
        super.viewDidLoad()

        screenNameLabel.text = "@" + timeLine.user!.screenName!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  @IBAction func onCancel(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }


  @IBAction func onReply(_ sender: UIBarButtonItem) {
    
    let params = NSMutableDictionary()
    params.setValue("@" + timeLine.user!.screenName! + " " + textView.text, forKey: "status")
    params.setValue(timeLine.idStr!, forKey: "in_reply_to_status_id")
    
    TwitterAPI.sharedInstance?.createTwitterStatus(parameters: params){
      (timeLine, error) in
      if error == nil {
        print("Reply twitter success")
      } else {
        print("have error when Reply twitter \(error!)")
      }
    }
  }

}
