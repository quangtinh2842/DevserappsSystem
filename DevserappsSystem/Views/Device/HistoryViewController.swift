//
//  HistoryViewController.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 18/03/2025.
//

import UIKit

class HistoryViewController: UITableViewController {
  var shouldRefreshViews: Bool = false

  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    _setupViews()
  }
  
  private func _setupViews() {
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
