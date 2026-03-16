//
//  NotificationVC.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 20/03/2025.
//

import UIKit

class NotificationsVC: UITableViewController {
  var shouldRefreshViews: Bool = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    _setupViews()
  }
  
  private func _setupViews() {
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.largeTitleDisplayMode = .always
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if shouldRefreshViews {
      _refreshViews()
      shouldRefreshViews = false
    }
  }
  
  private func _refreshViews() {
  }
}
