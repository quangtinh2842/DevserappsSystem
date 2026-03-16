//
//  ScheduleViewController.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 19/03/2025.
//

import UIKit

class ScheduleViewController: UITableViewController {
  var shouldRefreshViews = false
  var shouldSetupViews = true
  
  @IBOutlet weak var _collectionView: UICollectionView!
  
  private var _bottomSeparatorLine: UIView!
  private var _bottomBlurEffectView: UIVisualEffectView!
  
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
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    _handleBottomViewWith(self.tableView, isSwipe: false)
  }
  
  private func _refreshViews() {
  }
  
  private func _setupViews() {
    _setupSaveBtn()
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
    
  @IBAction func handleScheduleSwChanged(_ sender: UISwitch) {
  }
}

extension ScheduleViewController {
  override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    if section == 2 {
      return 50*2
    } else {
      return super.tableView(tableView, heightForFooterInSection: section)
    }
  }
}

extension ScheduleViewController {
  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    _handleBottomViewWith(scrollView, isSwipe: true)
  }
  
  private func _handleBottomViewWith(_ scrollView: UIScrollView, isSwipe: Bool) {
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

//extension ScheduleViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//    return 0
//  }
//
//  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//    <#code#>
//  }
//
//
//}
