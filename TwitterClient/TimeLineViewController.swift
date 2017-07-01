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
//    let loginViewController = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewController")
//    UIApplication.shared.keyWindow?.rootViewController = loginViewController
    
    //Show login Screen
   // print("logout")
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
//    print("\(ip!)")
//    print("isRetweet \(isFavorited)")
    TwitterAPI.sharedInstance?.favoriteStatus(id: timeLines[ip!].idStr) {
      (error) in
      if error == nil {
        print("favorite success")
      } else {
        print("have error when favorited \(error!)")
      }
    }
  }
  
  func onRetweetClick(cell: TimeLineCell, isRetweet: Bool) {
    let ip = tableView.indexPath(for: cell)?.row
//    print("\(ip!)")
//    print("isRetweet \(isRetweet)")
    TwitterAPI.sharedInstance?.retweetStatus(id: timeLines[ip!].idStr) {
      (error) in
      if error == nil {
        print("favorite success")
      } else {
        print("have error when favorited \(error!)")
      }
    }
  }
}



