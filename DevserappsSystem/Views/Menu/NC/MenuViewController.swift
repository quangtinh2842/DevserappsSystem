//
//  MenuViewController.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 02/03/2025.
//

import UIKit
import FirebaseAuth
import AlamofireImage
import LZViewPager

class MenuViewController: UIViewController {
  var shouldRefreshViews: Bool = false
  
  @IBOutlet weak var _imgProfilePhoto: UIImageView!
  @IBOutlet weak var _lblDisplayName: UILabel!
  @IBOutlet weak var _lblRegisteredEmail: UILabel!
  @IBOutlet weak var _vPager: LZViewPager!
  
  private var _subVCs = [UIViewController]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    _setupViews()
    _populateCurrentUserData()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if shouldRefreshViews {
      _refreshViews()
      shouldRefreshViews = false
    }
  }
  
  private func _refreshViews() {
    let settingsVC = StoryboardHelper.newSettingsVC()
    settingsVC.delegate = self
    let accountVC = StoryboardHelper.newAccountVC()
    accountVC.delegate = self
    
    _subVCs = [settingsVC, accountVC]
    _vPager.reload()
    
    _vPager.select(index: 0, animated: false)
    _populateCurrentUserData()
  }
  
  private func _setupViews() {
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.largeTitleDisplayMode = .always
    
    _imgProfilePhoto.layer.cornerRadius = _imgProfilePhoto.layer.frame.width/2
    
    _vPager.hostController = self
    let settingsVC = StoryboardHelper.newSettingsVC()
    settingsVC.delegate = self
    let accountVC = StoryboardHelper.newAccountVC()
    accountVC.delegate = self
    
    _subVCs = [settingsVC, accountVC]
    _vPager.reload()
  }
  
  private func _populateCurrentUserData() {
    if let photoURL = UserStore.currentUser.getPhotoURL {
      _imgProfilePhoto.af.setImage(withURL: photoURL)
    } else {
      _imgProfilePhoto.image = UIImage(systemName: "person.circle")
    }
    
    _lblDisplayName.text = UserStore.currentUser.displayName
    _lblRegisteredEmail.text = UserStore.currentUser.email
  }
}

extension MenuViewController: LZViewPagerDelegate, LZViewPagerDataSource {
  func backgroundColorForHeader() -> UIColor {
    return .systemBackground
  }
  
  func numberOfItems() -> Int {
    return _subVCs.count
  }
  
  func controller(at index: Int) -> UIViewController {
    return _subVCs[index]
  }
  
  func button(at index: Int) -> UIButton {
    let button = UIButton()
    button.setTitleColor(.gray, for: .normal)
    button.setTitleColor(.label, for: .selected)
    button.titleLabel?.font = .systemFont(ofSize: 17)
    button.backgroundColor = .systemBackground
    return button
  }
  
  func colorForIndicator(at index: Int) -> UIColor {
    return .tintColor
  }
}

extension MenuViewController: AccountDelegate {
  func accountViewController(accountVC: AccountViewController, userData: MUser) {
    if let photoURL = userData.getPhotoURL {
      _imgProfilePhoto.af.setImage(withURL: photoURL)
    } else {
      _imgProfilePhoto.image = UIImage(systemName: "person.circle")
    }
    
    _lblDisplayName.text = userData.displayName
    _lblRegisteredEmail.text = userData.email
  }
}

extension MenuViewController: SettingsDelegate {
}
