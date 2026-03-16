//
//  ViewController.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 01/03/2025.
//

import UIKit
import FirebaseAuth
import Toast
import KRProgressHUD

class LogInViewController: UIViewController {
  @IBOutlet weak var _btnLogIn: UIButton!
  @IBOutlet weak var _imgLogo: UIImageView!
  @IBOutlet weak var _txtEmail: UITextField!
  @IBOutlet weak var _txtPassword: UITextField!
  
  var shouldRefreshViews: Bool = false
  
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
    _btnLogIn.isEnabled = true
  }
  
  private func _setupViews() {
    _imgLogo.layer.cornerRadius = 50
    
    let rightView = UIView()
    rightView.frame.size = CGSize(width: 50, height: 50)
    rightView.frame.origin = .zero
    rightView.backgroundColor = .green
    _txtPassword.rightView = rightView
  }
  
  @IBAction func logInBtnTapped(_ sender: Any) {
    let email = _txtEmail.text
    let password = _txtPassword.text
    
    if (email == nil || email!.isEmpty) {
      self.view.makeToast(
        "Email field is empty. Please enter an email address.",
        duration: 3.0,
        position: .bottom)
      return
    } else if (password == nil || password!.isEmpty) {
      self.view.makeToast(
        "Password field is empty. Please enter a password.",
        duration: 3.0,
        position: .bottom)
      return
    }
    
    _btnLogIn.isEnabled = false
    
    KRProgressHUD.show()
    Auth.auth().signIn(withEmail: email!, password: password!) { [weak self] result, error in
      KRProgressHUD.dismiss()
      
      if (error != nil) {
        let uxErrorText = self?.firebaseErrorToUXLanguage(error!)
        self?.view.makeToast(uxErrorText, duration: 3.0, position: .bottom)
        self?._btnLogIn.isEnabled = true
      } else {
        if (result!.user.isEmailVerified) {
          self?._didVerifyEmailSuccessfullyHandler(withUID: result!.user.uid)
        } else {
          self?._presentEmailVerificationNC()
        }
      }
    }
  }
    
  private func _didVerifyEmailSuccessfullyHandler(withUID uid: String) {
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
  
  private func _presentMainVC() {
    let scene = UIApplication.shared.connectedScenes.first as! UIWindowScene
    let sceneDelegate = scene.delegate as! SceneDelegate
    sceneDelegate.showMainTBC()
  }
  
  private func _presentEmailVerificationNC() {
    let scene = UIApplication.shared.connectedScenes.first as! UIWindowScene
    let sceneDelegate = scene.delegate as! SceneDelegate
    sceneDelegate.showEmailVerificationNC()
  }
  
  private func _presentHardToHandleErrorVC() {
    let scene = UIApplication.shared.connectedScenes.first as! UIWindowScene
    let sceneDelegate = scene.delegate as! SceneDelegate
    sceneDelegate.showHardToHandleErrorVC()
  }
  
  func firebaseErrorToUXLanguage(_ errorParam: Error) -> String {
    guard let error = (errorParam as NSError?) else {
      return ""
    }
    
    switch error.code {
    case AuthErrorCode.networkError.rawValue:
      return "Network error. Please check your connection."
    case AuthErrorCode.userNotFound.rawValue:
      return "User not found. Please check your email."
    case AuthErrorCode.wrongPassword.rawValue:
      return "Incorrect password."
    case AuthErrorCode.invalidEmail.rawValue:
      return "Invalid email format."
    case AuthErrorCode.invalidCredential.rawValue:
      return "Incorrect email or password."
    case AuthErrorCode.internalError.rawValue:
      return "Internal error."
    default:
      return error.localizedDescription
    }
  }
}

extension LogInViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if _txtEmail === textField {
      _txtPassword.becomeFirstResponder()
    } else {
      _txtPassword.resignFirstResponder()
    }
    
    return true
  }
}
