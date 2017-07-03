//
//  TimeLineViewController.swift
//  TwitterClient
//
//  Created by Truong Tran on 6/28/17.
//  Copyright © 2017 Truong Tran. All rights reserved.
//

import UIKit
import BDBOAuth1Manager
import MBProgressHUD

class TimeLineViewController: UIViewController {
  var user: User!
  var timeLines = [TimeLine]()
		
  @IBOutlet weak var tableView: UITableView!
		
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.estimatedRowHeight = 100
    tableView.rowHeight = UITableViewAutomaticDimension
    
    
    
    getTimeLine()
    
    
    // add refreshControl
    let refreshControlTable = UIRefreshControl()
    
    refreshControlTable.attributedTitle = NSAttributedString(string: "Loading ...")
    refreshControlTable.addTarget(self, action: #selector(loadDataWithRefreshControl(_:)), for: UIControlEvents.valueChanged)
    tableView.insertSubview(refreshControlTable, at: 0)
  }
  
  @IBAction func save(_ sender: Any) {
    
    print("******asdfsahdfjhsdf")
    performSegue(withIdentifier: "ShowLogin", sender: nil)
    //      TwitterAPI.sharedInstance?.getUserInfo()
    //      //TwitterAPI.sharedInstance?.homeTimeline
    //    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func onLogOut(_ sender: Any) {
    TwitterAPI.sharedInstance?.requestSerializer.removeAccessToken()
    NotificationCenter.default.post(name: Notification.Name("LoginLogoutNotification"), object: nil, userInfo:["isLogout": true])
    performSegue(withIdentifier: "ShowLogin", sender: nil)
    
    
  }
  func loadDataWithRefreshControl(_ refreshControl: UIRefreshControl) {
    TwitterAPI.sharedInstance?.homeTimeline {
      (timeLines, error) in
      if (error == nil) {
        self.timeLines.removeAll()
        for timeLine in timeLines! {
          self.timeLines.append(timeLine)
        }
      } else {
        print("\(error!.localizedDescription)")
      }
      refreshControl.endRefreshing()
      self.tableView.reloadData()
      
    }
  }
  func getTimeLine() {
    MBProgressHUD.showAdded(to: self.view, animated: true)
    //    TwitterAPI.sharedInstance?.getUserInfo {
    //      (complete) in
    //      print(complete.name)
    //    }
    
    
    TwitterAPI.sharedInstance?.homeTimeline {
      (timeLines, error) in
      MBProgressHUD.hide(for: self.view, animated: true)
      if (error == nil) {
        for timeLine in timeLines! {
          self.timeLines.append(timeLine)
        }
      } else {
        print("\(error!.localizedDescription)")
      }
      self.tableView.reloadData()
      
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ViewDetail" {
      let viewController = segue.destination as! DetailViewController
      let ip = tableView.indexPathForSelectedRow!.row
      viewController.timeLine = timeLines[ip]
    } else if segue.identifier == "RepyScreen" {
      let navigationController = segue.destination as! UINavigationController
      let controller = navigationController.topViewController as! ReplyViewController
      
      let timeLine = sender as! TimeLine
      
      controller.timeLine = timeLine
      
    }
    else if segue.identifier == "NewTwetter" {
      let navigationController = segue.destination as! UINavigationController
      let controller = navigationController.topViewController as! NewTwetterViewController
      
     controller.delegate = self
      
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}
extension TimeLineViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return timeLines.count
    
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TimeLineCell", for: indexPath) as! TimeLineCell
    
    cell.delegate = self
    
    cell.timeLine = timeLines[indexPath.row]
    return cell
  }
}


extension TimeLineViewController: TimeLineCellDelegate {
  func onFavoritedClick(cell: TimeLineCell, isFavorited: Bool) {
    let ip = tableView.indexPath(for: cell)?.row
    
    // print("isFavorited: \(isFavorited)")
    // if like button is select then unfavoried else favoried
    if !isFavorited {
      TwitterAPI.sharedInstance?.unFavoriteStatus(id: timeLines[ip!].idStr) {
        (timeLine, error) in
        if error == nil {
          print("***unfavoried success")
          self.timeLines[ip!] = timeLine!
          self.tableView.reloadData()
          //self.timeLines[ip!].favCount = ti
        } else {
          print("have error when unfavoried \(error!)")
          self.tableView.reloadData()
        }
      }
    } else {
      TwitterAPI.sharedInstance?.favoriteStatus(id: timeLines[ip!].idStr) {
        (timeLine, error) in
        if error == nil {
          print("***favorite success")
          self.timeLines[ip!] = timeLine!
          self.tableView.reloadData()
          //self.timeLines[ip!].favorited = isFavorited
        } else {
          print("have error when favorited \(error!)")
          self.tableView.reloadData()
        }
      }
    }
    
    
  }
  
  func onRetweetClick(cell: TimeLineCell, isRetweet: Bool) {
    let ip = tableView.indexPath(for: cell)?.row
    
    // print("isRetweet: \(isRetweet)")
    
    // if Retweet button is select then unRetweet else Retweet
    if !isRetweet {
      TwitterAPI.sharedInstance?.unRetweetStatus(id: timeLines[ip!].idStr) {
        (timeLine, error) in
        if error == nil {
          print("***unRetweet success")
          self.timeLines[ip!] = timeLine!
          self.tableView.reloadData()
          //self.timeLines[ip!].retweeted = isRetweet
        } else {
          print("have error when unRetweet \(error!)")
          self.tableView.reloadData()
        }
      }
    } else {
      TwitterAPI.sharedInstance?.retweetStatus(id: timeLines[ip!].idStr) {
        (timeLine, error) in
        if error == nil {
          print("***retweet success")
          self.timeLines[ip!] = timeLine!
          self.tableView.reloadData()
          //self.timeLines[ip!].retweeted = isRetweet
        } else {
          print("have error when retweet \(error!)")
          self.tableView.reloadData()
        }
      }
    }
    
  }
  
  func onReplyClick(cell: TimeLineCell, timeLine: TimeLine) {
    
    performSegue(withIdentifier: "RepyScreen", sender: timeLine)
  }
}

extension TimeLineViewController: NewTwetterViewControllerDelegate {
  func newTwetterViewController(viewController: NewTwetterViewController, tileLine: TimeLine) {
    timeLines.insert(tileLine, at: 0)
    tableView.reloadData()
    // roll tableview to top
    tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableViewScrollPosition.top, animated: true)
  }
}

