//
//  SettingsVC.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 19/03/2025.
//

import UIKit

@objc protocol AccountDelegate: NSObjectProtocol {
  @objc optional func accountViewController(accountVC: AccountViewController, userData: MUser)
}

class AccountViewController: UITableViewController {
  var shouldRefreshViews: Bool = false
  
  var delegate: AccountDelegate?
  
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

extension AccountViewController {
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == 0 && indexPath.row == 0 {
      let profileNC = StoryboardHelper.newProfileNC()
      let profileVC = profileNC.viewControllers.first as! ProfileViewController
      profileVC.delegate = self
      self.present(profileNC, animated: true)
    }
    
    if indexPath.section == 1 && indexPath.row == 0 {
      _logOut()
    }
  }
  
  private func _logOut() {
    MUser.logOutEverywhere() { [weak self] error in
      if error != nil {
        self?._presentBasicAlert(title: "Error occurred", message: error?.localizedDescription)
      } else {
        self?._presentLogInVC()
      }
    }
  }
  
  private func _presentBasicAlert(title: String?, message: String?) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    self.present(alert, animated: true, completion: nil)
  }
  
  private func _presentLogInVC() {
    let scene = UIApplication.shared.connectedScenes.first as! UIWindowScene
    let sceneDelegate = scene.delegate as! SceneDelegate
    sceneDelegate.showLogInVC()
  }
}

extension AccountViewController: ProfileDelegate {
  func profileViewController(profileVC: ProfileViewController, didEditProfile editedUserData: MUser) {
    delegate?.accountViewController?(accountVC: self, userData: editedUserData)
  }
}
