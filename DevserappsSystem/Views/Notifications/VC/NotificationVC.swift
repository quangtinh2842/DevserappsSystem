//
//  NotificationVC.swift
//  DevserappsSystem
//
//  Created by Soren Inis Ngo on 08/04/2026.
//

import UIKit

class NotificationVC: UITableViewController {
  var shouldSetupViews = true
  var shouldPopulateDataFromNotification = true
  var shouldRefreshViews = false
  
  @IBOutlet weak var _txtTitle: UITextField!
  @IBOutlet weak var _txtContent: UITextView!
  
  var firstNotification: MNotification!
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if shouldSetupViews {
      _setupViews()
      shouldSetupViews = false
    }
    
    if shouldPopulateDataFromNotification {
      _populateDataFromProblem()
      shouldPopulateDataFromNotification = false
    }
    
    if shouldRefreshViews {
      _refreshViews()
      shouldRefreshViews = false
    }
  }
  
  private func _setupViews() {
    _txtTitle.isEnabled = false
    _txtContent.isEditable = false
  }
  
  private func _populateDataFromProblem() {
    _txtTitle.text = firstNotification?.title
    _txtContent.text = firstNotification?.content
  }
  
  private func _refreshViews() {
  }
}

extension NotificationVC {
  override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    if section == 1 {
      return firstNotification?.time?.ddMMyyyy()
    } else {
      return super.tableView(tableView, titleForFooterInSection: section)
    }
  }
}
