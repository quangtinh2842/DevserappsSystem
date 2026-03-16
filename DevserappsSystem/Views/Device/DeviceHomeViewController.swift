//
//  DeviceHomeViewController.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 18/03/2025.
//

import UIKit

class DeviceHomeViewController: UIViewController {
  var shouldRefreshViews: Bool = false
  
  @IBOutlet weak var _lblTitle: UILabel!
  @IBOutlet weak var _lblSubtitle: UILabel!
  @IBOutlet weak var _vSwitch: UIView!
  @IBOutlet weak var _imgSymbol: UIImageView!
  @IBOutlet weak var _vExtraPanel: UIView! // 240x148
  
  @IBOutlet weak var _vToggleControlExtraPanel: ToggleControlExtraPanel!
  
  fileprivate var _quickTime: QuickTime?
  
  private var _isOn: Bool!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    _isOn = true // need to remove if populate data
    _setupViews()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.navigationBar.isHidden = false
  }
  
  private func _setupViews() {
    
    
    navigationController?.navigationBar.tintColor = .label
    
    let yourBackImage = UIImage(systemName: "arrow.backward")
    navigationController?.navigationBar.backIndicatorImage = yourBackImage
    navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
    
    _vToggleControlExtraPanel.delegate = self
    _vToggleControlExtraPanel.setupViews(with: 15)
    _vExtraPanel.addSubview(_vToggleControlExtraPanel)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if shouldRefreshViews {
      _refreshViews()
      shouldRefreshViews = false
    }
    
    navigationController?.navigationBar.isHidden = true
  }
  
  private func _refreshViews() {
  }
  
  
  @IBAction func handleSwitchViewTapped(_ sender: Any) {
    if _isOn {
      UIView.animate(withDuration: 0.3) { [weak self] in
        self?._vSwitch.backgroundColor = .darkGray
        self?._isOn = false
      }
    } else {
      UIView.animate(withDuration: 0.3) { [weak self] in
        self?._vSwitch.backgroundColor = .systemYellow
        self?._isOn = true
      }
    }
  }
  
  @IBAction func handleBackBtnTapped(_ sender: Any) {
    self.dismiss(animated: true)
  }
}

extension DeviceHomeViewController: ToggleControlExtraPanelDelegate {
  func toggleControlExtraPanel(toggleControlExtraPanel: ToggleControlExtraPanel, didSelectTime selectedTime: Int) {
  }
}

@objc protocol ToggleControlExtraPanelDelegate: NSObjectProtocol {
  @objc optional func toggleControlExtraPanel(toggleControlExtraPanel: ToggleControlExtraPanel, didSelectTime selectedTime: Int)
}

class ToggleControlExtraPanel: UIView {
  @IBOutlet var _btnTimes: [UIButton]!
  
  var delegate: ToggleControlExtraPanelDelegate?
  
  private let _times = [15, 30, 45, 60, 90, 120]
  private var _selectedTimeTag: Int!
  
  func setupViews(with selectedTime: Int) {
    _selectedTimeTag = _times.firstIndex(of: selectedTime)
    _updateViewsAfterChoosing(preTag: _selectedTimeTag, tag: _selectedTimeTag)
  }
  
  @IBAction func handleTimeBtnTapped(_ sender: UIButton) {
    if _selectedTimeTag == sender.tag {
      _unselected(tag: sender.tag)
      _selectedTimeTag = nil
    } else {
      let preTimeTag = _selectedTimeTag ?? sender.tag
      _selectedTimeTag = sender.tag
      _updateViewsAfterChoosing(preTag: preTimeTag, tag: _selectedTimeTag)
    }
    
    if delegate != nil && delegate!.responds(to: #selector(ToggleControlExtraPanelDelegate.toggleControlExtraPanel(toggleControlExtraPanel:didSelectTime:))) {
      let selectedTime = _selectedTimeTag == nil ? 0 : _times[sender.tag]
      delegate?.toggleControlExtraPanel?(toggleControlExtraPanel: self, didSelectTime: selectedTime)
    }
  }
  
  private func _updateViewsAfterChoosing(preTag: Int, tag: Int) {
    _unselected(tag: preTag)
    _selected(tag: tag)
  }
  
  private func _unselected(tag: Int) {
    let button = _btnTimes.filter{ $0.tag == tag }.first
    button?.setTitleColor(.systemYellow, for: .normal)
    button?.backgroundColor = .systemGray6
  }
  
  private func _selected(tag: Int) {
    let button = _btnTimes.filter{ $0.tag == tag }.first
    button?.setTitleColor(.white, for: .normal)
    button?.backgroundColor = .systemYellow
  }
}

class QuickTime {
  var totalMins: Int
  var leftTime: Int?
  
  init(totalMins: Int) {
    self.totalMins = totalMins
  }
}
