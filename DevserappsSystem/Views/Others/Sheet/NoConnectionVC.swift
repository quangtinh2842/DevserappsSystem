//
//  NoConnectionVC.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 11/04/2025.
//

import UIKit
import Reachability

class NoConnectionVC: UIViewController {
  var shouldSetupViews = true
  var shouldRefreshViews = false
  
  private var _reachability: Reachability? = nil
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if shouldSetupViews {
      _setupViews()
      shouldSetupViews = false
    }
    
    if shouldRefreshViews {
      _refreshViews()
      shouldRefreshViews = false
    }
  }
  
  private func _setupViews() {
    _reachability = try? Reachability()
  }
  
  private func _refreshViews() {
  }
}

extension NoConnectionVC: UISheetPresentationControllerDelegate {
  func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
    return _reachability?.connection != .unavailable
  }
}
