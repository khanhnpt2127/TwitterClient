//
//  TimeLineCell.swift
//  TwitterClient
//
//  Created by Truong Tran on 6/30/17.
//  Copyright © 2017 Truong Tran. All rights reserved.
//

import UIKit
import AFNetworking
import FaveButton

func color(_ rgbColor: Int) -> UIColor{
  return UIColor(
    red:   CGFloat((rgbColor & 0xFF0000) >> 16) / 255.0,
    green: CGFloat((rgbColor & 0x00FF00) >> 8 ) / 255.0,
    blue:  CGFloat((rgbColor & 0x0000FF) >> 0 ) / 255.0,
    alpha: CGFloat(1.0)
  )
}
protocol TimeLineCellDelegate {
  func onFavoritedClick(cell: TimeLineCell, isFavorited: Bool)
  func onRetweetClick(cell: TimeLineCell, isRetweet: Bool)
}

class TimeLineCell: UITableViewCell, FaveButtonDelegate {
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
  
  var delegate: TimeLineCellDelegate!
  var isFavorited = false
  var isRetweet = false
  
  
  var timeLine: TimeLine! {
    didSet {
      nameLabel.text = timeLine.user!.name
      tagNameLabel.text = "@" + timeLine.user!.screenName!
      statusLabel.text = timeLine.text
      avataImage.setImageWith(timeLine.user!.profileImageUrl!)
      timeLabel.text = timeLine.timeSinceCreated!
      numberRetweetedLabel.text = "\(timeLine.retweetCount)"
      numberLikeLabel.text = "\(timeLine.favCount)"
      
      isFavorited = timeLine.favorited
      isRetweet = timeLine.retweeted
      likeButton.isSelected = timeLine.favorited
      retweetedButton.isSelected = timeLine.retweeted
     // likeButton.setImage(UIinamed: "liked", for: UIControlState.normal)
//      if isFavorited {
//        likeButton.setImage(UIImage(named: "liked"), for: .selected)
//      }
//      if isRetweet {
//        retweetedButton.setImage(UIImage(named: "retweeted"), for: .selected)
//      }
//      likeButton.
      
      
    //  print(timeLine.favorited)
      
      if let userRetweet = timeLine.UserRetweet  {
        nameRetweetedLabel.text = userRetweet.name! + "retweeted"
        imageRetweeted.isHidden = false
        nameRetweetedLabel.isHidden = false

      }else {
        imageRetweeted.isHidden = true
        nameRetweetedLabel.isHidden = true
      }
    }
    
  }

  let colors = [
    DotColors(first: color(0x7DC2F4), second: color(0xE2264D)),
    DotColors(first: color(0xF8CC61), second: color(0x9BDFBA)),
    DotColors(first: color(0xAF90F4), second: color(0x90D1F9)),
    DotColors(first: color(0xE9A966), second: color(0xF8C852)),
    DotColors(first: color(0xF68FA7), second: color(0xF6A2B8))
  ]
  
  
  override func awakeFromNib() {
    likeButton.delegate = self
    retweetedButton.delegate = self
    
  }
  
  func faveButton(_ faveButton: FaveButton, didSelected selected: Bool){
    if faveButton == likeButton {
      isFavorited = !isFavorited
      delegate.onFavoritedClick(cell: self, isFavorited: isFavorited)
      print("like button click")
    } else if faveButton == retweetedButton{
      isRetweet = !isRetweet
      delegate.onRetweetClick(cell: self, isRetweet: isRetweet)
      print("retweet button click")
    }
  
  }
  
//  func faveButtonDotColors(_ faveButton: FaveButton) -> [DotColors]?{
//    return colors
//  }
  

}


