//
//  SystemsViewController.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 03/03/2025.
//

import UIKit
import FirebaseAuth
import KRProgressHUD

class PasswordResetViewController: UITableViewController {
  @IBOutlet weak var _txtEmail: UITextField!
  
  var shouldRefreshViews: Bool = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if (shouldRefreshViews) {
      _refreshViews()
      shouldRefreshViews = false
    }
  }
  
  private func _refreshViews() {
    if let email = Auth.auth().currentUser?.email {
      _txtEmail.text = email
    }
  }
  
  func setupViews() {
    if let email = Auth.auth().currentUser?.email {
      _txtEmail.text = email
    }
  }
  
  @IBAction func handleXMarkBtnTapped(_ sender: Any) {
    self.dismiss(animated: true)
  }
  
  @IBAction func sendResetEmailBtnTapped(_ sender: Any) {
    let email = _txtEmail.text ?? ""
    
    if email.isEmpty {
      showAlert(title: "Email is empty", message: "You need to fill in email field first.")
      return
    }
    
    KRProgressHUD.show()
    
    Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
      KRProgressHUD.dismiss()
      
      if error != nil {
        self?.showAlert(title: "Error occurred", message: error!.localizedDescription)
      } else {
        self?.showAlert(title: "Sent reset email", message: "Please check your email box.")
      }
    }
  }
  
  func showAlert(title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
}

extension PasswordResetViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    _txtEmail.resignFirstResponder()
    return true
  }
}
