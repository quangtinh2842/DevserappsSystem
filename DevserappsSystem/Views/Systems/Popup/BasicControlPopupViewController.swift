//
//  BasicControlPopupViewController.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 18/03/2025.
//

import UIKit

class BasicControlPopupViewController: UIViewController {
  var shouldRefreshViews: Bool = false
  
  @IBOutlet weak var _imgSymbol: UIImageView!
  @IBOutlet weak var _lblTitle: UILabel!
  @IBOutlet weak var _lblStatus: UILabel!
  @IBOutlet weak var _vSwitch: UIView!
  @IBOutlet weak var _vKnob: UIView!
  
  private var _isOn: Bool!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    _isOn = true // need to remove if populate data
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
  
  
  @IBAction func handleOutsideTapped(_ sender: Any) {
    self.dismiss(animated: true)
  }
  
  @IBAction func handleSwitchViewTapped(_ sender: UITapGestureRecognizer) {
    if _isOn {
      UIView.animate(withDuration: 1.0,
                     delay: 0,
                     usingSpringWithDamping: 0.5,
                     initialSpringVelocity: 0.7,
                     options: [],
                     animations: { [weak self] in
        self?._vKnob.frame.origin.y = 117
        self?._vKnob.backgroundColor = .darkGray
        self?._isOn = false
        self?._lblStatus.text = "Off"
      })
    } else {
      UIView.animate(withDuration: 1.0,
                     delay: 0,
                     usingSpringWithDamping: 0.5,
                     initialSpringVelocity: 0.7,
                     options: [],
                     animations: { [weak self] in
        self?._vKnob.frame.origin.y = 8
        self?._vKnob.backgroundColor = .yellow
        self?._isOn = true
        self?._lblStatus.text = "On"
      })
    }
  }
  
  @IBAction func settingsBtnTapped(_ sender: Any) {
    let deviceHomeNC = StoryboardHelper.newDeviceHomeNC()
    self.present(deviceHomeNC, animated: true)
  }
}
