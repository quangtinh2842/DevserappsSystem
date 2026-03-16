//
//  SystemsViewController.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 03/03/2025.
//

import UIKit
import FirebaseAuth
import KRProgressHUD

class EmailVerificationViewController: UITableViewController {
  @IBOutlet weak var _txtRegisteredEmail: UITextField!
  
  var shouldRefreshViews: Bool = false
  
  private var _emailVerificationTimer: Timer?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    _setupViews()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if (shouldRefreshViews) {
      _refreshViews()
      shouldRefreshViews = false
    }
  }
  
  private func _refreshViews() {
    _txtRegisteredEmail.text = Auth.auth().currentUser?.email
  }
  
  private func _setupViews() {
    _txtRegisteredEmail.text = Auth.auth().currentUser?.email
  }
  
  @IBAction func sendVerificationBtnTapped(_ sender: Any) {
    KRProgressHUD.show()
    
    Auth.auth().currentUser?.sendEmailVerification { [weak self] error in
      KRProgressHUD.dismiss()
      
      if (error != nil) {
        self?.showAlert(title: "Error occurred", message: error!.localizedDescription)
      } else {
        self?.showAlert(title: "Sent verified email", message: "Please check your email box.")
        self?._startEmailVerificationCheck()
      }
    }
  }
  
  private func _startEmailVerificationCheck() {
    _emailVerificationTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
      self?._checkEmailVerificationStatusToShowMainVC()
    }
  }
  
  private func _checkEmailVerificationStatusToShowMainVC() {
    Auth.auth().currentUser?.reload { [weak self] error in
      if Auth.auth().currentUser!.isEmailVerified {
        self?._didVerifyEmailSuccessfullyHandler(withUID: Auth.auth().currentUser!.uid)
      }
    }
  }
  
  private func _didVerifyEmailSuccessfullyHandler(withUID uid: String) {
    _emailVerificationTimer?.invalidate()
    KRProgressHUD.show()
    MUser.find(byId: uid) { [weak self] result, error in
      KRProgressHUD.dismiss()
      if let errorCode = (error as? NSError)?.code, errorCode == NotFoundError.code {
        self?._tryToSyncLoggedInUserToShowVC()
        return
      }
      
      if let syncedUser = result as? MUser {
        UserStore.currentUser = nil
        UserStore.currentUser = MUser(user: syncedUser)
        self?._presentMainVC()
        return
      }
      
      self?._presentHardToHandleErrorVC()
    }
  }
  
  private func _tryToSyncLoggedInUserToShowVC() {
    do {
      KRProgressHUD.show()
      try MUser.syncFromCurrentUser { [weak self] error, _ in
        KRProgressHUD.dismiss()
        if (error != nil) {
          self?._presentHardToHandleErrorVC()
        } else {
          self?._presentMainVC()
        }
      }
    } catch {
      _presentHardToHandleErrorVC()
    }
  }
  
  private func _presentHardToHandleErrorVC() {
    let scene = UIApplication.shared.connectedScenes.first as! UIWindowScene
    let sceneDelegate = scene.delegate as! SceneDelegate
    sceneDelegate.showHardToHandleErrorVC()
  }
  
  @IBAction func logOutBtnTapped(_ sender: Any) {
    do {
      try Auth.auth().signOut()
      _presentLogInVC()
      _emailVerificationTimer?.invalidate()
    } catch {
      showAlert(title: "Error occurred", message: error.localizedDescription)
    }
  }
  
  func showAlert(title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
  
  private func _presentLogInVC() {
    let scene = UIApplication.shared.connectedScenes.first as! UIWindowScene
    let sceneDelegate = scene.delegate as! SceneDelegate
    sceneDelegate.showLogInVC()
  }
  
  private func _presentMainVC() {
    let scene = UIApplication.shared.connectedScenes.first as! UIWindowScene
    let sceneDelegate = scene.delegate as! SceneDelegate
    sceneDelegate.showMainTBC()
  }
}
