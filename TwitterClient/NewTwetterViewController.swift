//
//  NewTwetterViewController.swift
//  TwitterClient
//
//  Created by Truong Tran on 7/1/17.
//  Copyright © 2017 Truong Tran. All rights reserved.
//

import UIKit
import AFNetworking

protocol NewTwetterViewControllerDelegate {
  func newTwetterViewController(viewController: NewTwetterViewController, tileLine: TimeLine)
}

class NewTwetterViewController: UIViewController, UITextViewDelegate {
  @IBOutlet weak var avataImage: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var screenNameLabel: UILabel!
  @IBOutlet weak var toolbarView: UIView!
  @IBOutlet weak var createTwetterButton: UIButton!
  @IBOutlet weak var countLabel: UILabel!
  
  var delegate: NewTwetterViewControllerDelegate!
  
  var placeholderLabel : UILabel!
		
  
  @IBOutlet weak var textView: UITextView!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // set navibar color
    navigationController!.navigationBar.barTintColor = UIColor.white
    
    textView.delegate = self
    let user = User.currentUser
    if user != nil {
      avataImage.setImageWith((user?.profileImageUrl!)!)
      nameLabel.text = user?.name!
      screenNameLabel.text = "@\(user!.screenName!)"
    }
    
    // settup count label and create button
    countLabel.textColor = UIColor.lightGray
    createTwetterButton.isEnabled = false
    createTwetterButton.backgroundColor = UIColor.lightGray
    createTwetterButton.layer.cornerRadius = 10
    

    // add placeholder in TexView
    placeholderLabel = UILabel()
    placeholderLabel.text = "What's happening ?"
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
      createTwetterButton.backgroundColor = UIColor.lightGray
      createTwetterButton.isEnabled = false
    }
    
    let counter = 140 - textView.text.characters.count
    countLabel.text = "\(counter)"
    if counter < 0 {
      countLabel.textColor = UIColor.red
      createTwetterButton.backgroundColor = UIColor.lightGray
      createTwetterButton.isEnabled = false
    } else {
      countLabel.textColor = UIColor.lightGray
      createTwetterButton.isEnabled = true
      createTwetterButton.backgroundColor = MyColor.mainColor
    }
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  @IBAction func onCreateNewTwitter(_ sender: Any) {
    let params = NSMutableDictionary()
    params.setValue(textView.text, forKey: "status")
    
    TwitterAPI.sharedInstance?.createTwitterStatus(parameters: params){
      (timeLine, error) in
      if error == nil {
        print("***Success create status")
        self.delegate.newTwetterViewController(viewController: self, tileLine: timeLine!)
        self.dismiss(animated: true, completion: nil)
      } else {
        print("***have error when create twitter \(error!)")
      }
    }
  }
  
 
  
  @IBAction func onCancel(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}


