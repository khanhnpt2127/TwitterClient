//
//  DetailViewController.swift
//  TwitterClient
//
//  Created by Truong Tran on 7/1/17.
//  Copyright © 2017 Truong Tran. All rights reserved.
//

import UIKit
import AFNetworking
import FaveButton

class DetailViewController: UIViewController {
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var tagNameLabel: UILabel!
  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet weak var imageRetweeted: UIImageView!
  @IBOutlet weak var nameRetweetedLabel: UILabel!
  @IBOutlet weak var avataImage: UIImageView!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var numberReplyLabel: UILabel!
  @IBOutlet weak var numberRetweetedLabel: UILabel!
  @IBOutlet weak var numberLikeLabel: UILabel!
  
  @IBOutlet weak var likeButton: FaveButton!
  @IBOutlet weak var retweetedButton: FaveButton!
  
  var isFavorited = false
  var isRetweet = false
  
  var timeLine: TimeLine!

    override func viewDidLoad() {
        super.viewDidLoad()

      nameLabel.text = timeLine.user!.name
      tagNameLabel.text = "@" + timeLine.user!.screenName!
      statusLabel.text = timeLine.text
      avataImage.setImageWith(timeLine.user!.profileImageUrl!)
      timeLabel.text = "\(timeLine.createdAt!)"
      numberRetweetedLabel.text = "\(timeLine.retweetCount)"
      numberLikeLabel.text = "\(timeLine.favCount)"
      
      isFavorited = timeLine.favorited
      isRetweet = timeLine.retweeted
      likeButton.isSelected = timeLine.favorited
      retweetedButton.isSelected = timeLine.retweeted
      
      if let userRetweet = timeLine.UserRetweet  {
        nameRetweetedLabel.text = userRetweet.name! + "retweeted"
        imageRetweeted.isHidden = false
        nameRetweetedLabel.isHidden = false
        
      }else {
        imageRetweeted.isHidden = true
        nameRetweetedLabel.isHidden = true
      }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
