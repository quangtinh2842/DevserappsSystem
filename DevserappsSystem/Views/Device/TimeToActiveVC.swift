//
//  TimeToActiveVC.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 19/03/2025.
//

import UIKit

class TimeToActiveVC: UITableViewController {
  var shouldRefreshViews = false
  var shouldSetupViews = true
  
  @IBOutlet weak var _lblTime: UILabel!
  @IBOutlet weak var _segTimePickerOptions: UISegmentedControl!
  @IBOutlet weak var _pkgTimePicker: UIDatePicker!
  @IBOutlet weak var _swIsRepeat: UISwitch!
  
  private var _bottomSeparatorLine: UIView!
  private var _bottomBlurEffectView: UIVisualEffectView!
  
  private var _weekdays = [Bool](repeating: true, count: 7)
  private var _shouldExpandR1S0 = false
  private var _shouldExpandR1S1 = false
  private var _shouldExpandR1S2 = false
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if shouldRefreshViews {
      _refreshViews()
      shouldRefreshViews = false
    }
    
    if shouldSetupViews {
      _setupViews()
      shouldSetupViews = false
    }
  }
  
  private func _refreshViews() {
  }
  
  // Force fix
  private func _setupViews() {
    _setupSaveBtn()
    self.tableView(self.tableView, didSelectRowAt: IndexPath(row: 0, section: 1))
    self.tableView(self.tableView, didSelectRowAt: IndexPath(row: 0, section: 1))
  }
  
  private func _setupSaveBtn() {
    let container = UIView()
    container.frame = .zero
    container.frame.size.width = view.frame.width
    container.frame.size.height = 50*2
    container.frame.origin.x = 0
    container.frame.origin.y = view.frame.height-container.frame.height
    container.backgroundColor = .clear
    
    _bottomSeparatorLine = UIView()
    _bottomSeparatorLine.frame = .zero
    _bottomSeparatorLine.frame.size.width = view.frame.width
    _bottomSeparatorLine.frame.size.height = 1
    _bottomSeparatorLine.backgroundColor = .separator
    
    let blurEffect = UIBlurEffect(style: .systemChromeMaterial)
    _bottomBlurEffectView = UIVisualEffectView(effect: blurEffect)
    _bottomBlurEffectView.frame.size = container.bounds.size
    _bottomBlurEffectView.frame.origin.x = 0
    _bottomBlurEffectView.frame.origin.y = 1
    _bottomBlurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    container.addSubview(_bottomBlurEffectView)
    container.addSubview(_bottomSeparatorLine)
    
    let saveBtn = UIButton(type: .system)
    saveBtn.frame = .zero
    saveBtn.frame.size.width = view.frame.width*0.9
    saveBtn.frame.size.height = 50
    saveBtn.frame.origin.x = (container.frame.width-saveBtn.frame.width)/2
    saveBtn.frame.origin.y = 25
    saveBtn.setTitle("Save", for: .normal)
    saveBtn.titleLabel?.font = .systemFont(ofSize: 17)
    saveBtn.setTitleColor(.white, for: .normal)
    saveBtn.backgroundColor = .tintColor
    saveBtn.layer.cornerRadius = 25
    saveBtn.layer.masksToBounds = true
    saveBtn.addTarget(self, action: #selector(_handleSaveBtnTapped), for: .touchUpInside)
    
    container.addSubview(saveBtn)
    navigationController?.view.addSubview(container)
  }
  
  @objc private func _handleSaveBtnTapped(_ sender: Any) {
    self.dismiss(animated: true)
  }
  
  @IBAction func handleXMarkBtnTapped(_ sender: Any) {
    self.dismiss(animated: true)
  }
  
  @IBAction func timePickerOptionsSegChanged(_ sender: UISegmentedControl) {
  }
  
  @IBAction func repeatSwChanged(_ sender: UISwitch) {
    _shouldExpandR1S2 = sender.isOn
    self.tableView.reloadSections(IndexSet(integer: 2), with: .none)
    handleBottomViewWith(self.tableView, isSwipe: false)
  }
  
  @IBAction func weekdayBtnTapped(_ sender: UIButton) {
    _weekdays[sender.tag-10] = !_weekdays[sender.tag-10]
    
    if _weekdays[sender.tag-10] {
      sender.setTitleColor(.white, for: .normal)
      sender.backgroundColor = .tintColor
    } else {
      sender.setTitleColor(.tintColor, for: .normal)
      sender.backgroundColor = .systemGray6
    }
  }
}

extension TimeToActiveVC {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 && !_shouldExpandR1S0 {
      return 1
    } else if section == 1 && !_shouldExpandR1S1 {
      return 1
    } else if section == 2 && !_shouldExpandR1S2 {
      return 1
    }
    
    return super.tableView(tableView, numberOfRowsInSection: section)
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == 0 &&
        indexPath.row == 0 {
      _shouldExpandR1S0 = !_shouldExpandR1S0
      self.tableView.reloadSections(IndexSet(integer: 0), with: .none)
      handleBottomViewWith(self.tableView, isSwipe: false)
    }
    
    if indexPath.section == 1 &&
        indexPath.row == 0 {
      _shouldExpandR1S1 = !_shouldExpandR1S1
      self.tableView.reloadSections(IndexSet(integer: 1), with: .none)
      handleBottomViewWith(self.tableView, isSwipe: false)
    }
  }
  
  override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    if section == 2 {
      return 50*2
    } else {
      return super.tableView(tableView, heightForFooterInSection: section)
    }
  }
}

extension TimeToActiveVC {
  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    handleBottomViewWith(scrollView, isSwipe: true)
  }
  
  private func handleBottomViewWith(_ scrollView: UIScrollView, isSwipe: Bool) {
    var tableViewContentHeight = tableView.contentSize.height
    tableViewContentHeight += (isSwipe ? 0 : (85))
    let scrollInsideContentHeight = tableViewContentHeight-scrollView.contentOffset.y-(50*2)
    let containerY = view.frame.height-(50*2)
    let space = containerY-scrollInsideContentHeight
    
    print("y:", scrollView.contentOffset.y)
    print("scrollInsideContentHeight:", scrollInsideContentHeight)
    print("containerY:", containerY)
    print("space:", space)
    
    if space > 6 {
      _bottomSeparatorLine.alpha = 0
      _bottomBlurEffectView.alpha = 0
    } else if space <= 6 && space >= 0 {
      let alpha = 1-(space/6)
      _bottomSeparatorLine.alpha = alpha
      _bottomBlurEffectView.alpha = alpha
    } else {
      _bottomSeparatorLine.alpha = 1
      _bottomBlurEffectView.alpha = 1
    }
  }
}
