//
//  HardToHandleErrorViewController.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 06/03/2025.
//

import UIKit
import FirebaseAuth

class HardToHandleErrorViewController: UIViewController {
  @IBOutlet weak var _lblRegisteredEmail: UILabel!
  
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
    _lblRegisteredEmail.text = Auth.auth().currentUser?.email
  }
  
  private func _setupViews() {
    _lblRegisteredEmail.text = Auth.auth().currentUser?.email
  }
  
  @IBAction func logOutBtnTapped(_ sender: Any) {
    MUser.logOutEverywhere() { [weak self] error in
      if (error != nil) {
        self?.showAlert(title: "Error occurred", message: error!.localizedDescription)
      } else {
        self?._presentLogInVC()
      }
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
}
