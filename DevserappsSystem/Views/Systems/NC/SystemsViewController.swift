//
//  SystemsViewController.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 03/03/2025.
//

import UIKit
import LZViewPager

class SystemsViewController: UIViewController {
  var shouldRefreshViews: Bool = false
  
  @IBOutlet weak var _vPager: LZViewPager!
  
  private var _subVCs = [UIViewController]()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    _setupViews()
  }
  
  private func _setupViews() {
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.largeTitleDisplayMode = .always
    
    navigationController?.navigationBar.tintColor = .label
    
    let yourBackImage = UIImage(systemName: "arrow.backward")
    navigationController?.navigationBar.backIndicatorImage = yourBackImage
    navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
    
    _vPager.hostController = self
    let homeSystemsVC = StoryboardHelper.newHomeSystemsVC()
    let tankSystemsVC = StoryboardHelper.newTankSystemsVC()
    let otherSystemsVC = StoryboardHelper.newOtherSystemsVC()
    _subVCs = [homeSystemsVC, tankSystemsVC, otherSystemsVC]
    _vPager.reload()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if shouldRefreshViews {
      _refreshViews()
      shouldRefreshViews = false
    }
  }
  
  private func _refreshViews() {
    _vPager.select(index: 0, animated: false)
  }
}

extension SystemsViewController: LZViewPagerDelegate, LZViewPagerDataSource {
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
