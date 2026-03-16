//
//  NotificationsSettingsVC.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 31/03/2025.
//

import UIKit

@objc protocol NotificationsSettingsDelegate: NSObjectProtocol {
  @objc optional func notificationsSettingsVC(notificationsSettingsVC: NotificationsSettingsVC, didEditNotificationsSettings editedNotificationsSettings: Notifications)
}

class NotificationsSettingsVC: UITableViewController {
  var shouldSetupViews = true
  var shouldPopulateDataFromNotifications = true
  var shouldRefreshViews = false
  
  @IBOutlet weak var _swAll: UISwitch!
  
  var delegate: NotificationsSettingsDelegate?
  var notifications: Notifications?
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if shouldSetupViews {
      _setupViews()
      shouldSetupViews = false
    }
    
    if shouldPopulateDataFromNotifications {
      _populateDataFromFirstNotifications()
      shouldPopulateDataFromNotifications = false
    }
    
    if shouldRefreshViews {
      _refreshViews()
      shouldRefreshViews = false
    }
  }
  
  private func _refreshViews() {
  }
  
  private func _setupViews() {
  }
  
  private func _populateDataFromFirstNotifications() {
    _swAll.isOn = notifications?.isAllOn?.toBool() ?? false
  }
  
  @IBAction func handleBackBtnTapped(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
  
  @IBAction func handleAllSwChanged(_ sender: Any) {
    notifications?.isAllOn = _swAll.isOn ? "True" : "False"
    delegate?.notificationsSettingsVC?(notificationsSettingsVC: self, didEditNotificationsSettings: Notifications(notifications: notifications))
  }
}
