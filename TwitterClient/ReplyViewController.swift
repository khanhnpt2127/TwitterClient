//
//  ReplyViewController.swift
//  TwitterClient
//
//  Created by Truong Tran on 7/2/17.
//  Copyright © 2017 Truong Tran. All rights reserved.
//

import UIKit

class ReplyViewController: UIViewController, UITextViewDelegate {

  @IBOutlet weak var textView: UITextView!
  @IBOutlet weak var screenNameLabel: UILabel!
  
  @IBOutlet weak var toolbarView: UIView!
  @IBOutlet weak var replyTwetterButton: UIButton!
  @IBOutlet weak var countLabel: UILabel!
  
  var placeholderLabel : UILabel!

  
  var timeLine: TimeLine!
  
    override func viewDidLoad() {
        super.viewDidLoad()

      screenNameLabel.text = "@" + timeLine.user!.screenName!
      textView.delegate = self
      
      
      // settup count label and create button
      countLabel.textColor = UIColor.lightGray
      replyTwetterButton.isEnabled = false
      replyTwetterButton.backgroundColor = UIColor.lightGray
      replyTwetterButton.layer.cornerRadius = 10
      
      // add placeholder in TexView
      placeholderLabel = UILabel()
      placeholderLabel.text = "Tweet your reply"
      placeholderLabel.font = UIFont.italicSystemFont(ofSize: (textView.font?.pointSize)!)
      placeholderLabel.sizeToFit()
      textView.addSubview(placeholderLabel)
      placeholderLabel.frame.origin = CGPoint(x: 5, y: (textView.font?.pointSize)! / 2)
      placeholderLabel.textColor = UIColor.lightGray
      placeholderLabel.isHidden = !textView.text.isEmpty
      
      
      textView.inputAccessoryView = toolbarView
      textView.becomeFirstResponder()
    }
  
  func textViewDidChange(_ textView: UITextView) {
    placeholderLabel.isHidden = !textView.text.isEmpty
    
    if textView.text.characters.count == 0 {
      replyTwetterButton.backgroundColor = UIColor.lightGray
      replyTwetterButton.isEnabled = false
    }
    
    let counter = 140 - textView.text.characters.count
    countLabel.text = "\(counter)"
    if counter < 0 {
      countLabel.textColor = UIColor.red
      replyTwetterButton.backgroundColor = UIColor.lightGray
      replyTwetterButton.isEnabled = false
    } else {
      countLabel.textColor = UIColor.lightGray
      replyTwetterButton.isEnabled = true
      replyTwetterButton.backgroundColor = MyColor.mainColor
    }
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  @IBAction func onCancel(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func onReplyTwitter(_ sender: UIButton) {
    let params = NSMutableDictionary()
    params.setValue("@" + timeLine.user!.screenName! + " " + textView.text, forKey: "status")
    params.setValue(timeLine.idStr!, forKey: "in_reply_to_status_id")
    TwitterAPI.sharedInstance?.createTwitterStatus(parameters: params){
      (timeLine, error) in
      if error == nil {
        print("***Reply twitter success")
        self.dismiss(animated: true, completion: nil)
      } else {
        print("***have error when Reply twitter \(error!)")
      }
    }
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
