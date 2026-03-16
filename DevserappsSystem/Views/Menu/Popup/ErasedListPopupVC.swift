//
//  MenuViewController.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 02/03/2025.
//

import UIKit
import MapKit

@objc protocol ErasedListPopupDelegate: NSObjectProtocol {
  @objc optional func erasedListPopupVC(erasedListPopupVC: ErasedListPopupVC, updatedList: [ErasedInformation])
}

class ErasedListPopupVC: UIViewController {
  var shouldRefreshViews: Bool = false
  
  @IBOutlet weak var _vContainer: UIView!
  @IBOutlet weak var _tblErasedList: UITableView!
  
  var delegate: ErasedListPopupDelegate?
  var list: [ErasedInformation] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    _setupViews()
    _populateData()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if shouldRefreshViews {
      _refreshViews()
      shouldRefreshViews = false
    }
  }
  
  private func _refreshViews() {
    _populateData()
  }
  
  private func _setupViews() {
    _vContainer.frame.origin.x = (view.frame.width-_vContainer.frame.width)/2
    _vContainer.frame.size.height = CGFloat(8*2+50*list.count)
    _vContainer.frame.origin.y = (view.frame.height-_vContainer.frame.height)/2
  }
  
  private func _populateData() {
  }
  
  @IBAction func handleBackgroundTapped(_ sender: Any) {
    self.dismiss(animated: true)
  }
}

extension ErasedListPopupVC: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return list.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ReuseID.ErasedInfoCell.rawValue)!
    var contentConfiguration = cell.defaultContentConfiguration()
    contentConfiguration.text = list[indexPath.row].name
    cell.contentConfiguration = contentConfiguration
    
    let container = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    let selectionBtn = UIButton(type: .custom)
    selectionBtn.frame.origin = CGPoint(x: 5, y: 5)
    selectionBtn.frame.size = CGSize(width: 40, height: 40)
    selectionBtn.tag = indexPath.row
    
    if list[indexPath.row].isSelected {
      let image = UIImage(systemName: "largecircle.fill.circle")
      selectionBtn.setImage(image, for: .normal)
      selectionBtn.tintColor = .tintColor
    } else {
      let image = UIImage(systemName: "circle")
      selectionBtn.setImage(image, for: .normal)
      selectionBtn.tintColor = .label
    }
    
    selectionBtn.addTarget(self, action: #selector(handleSelectionBtnTapped), for: .touchUpInside)
    
    container.addSubview(selectionBtn)
    cell.accessoryView = container
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = _tblErasedList.cellForRow(at: indexPath)
        
    let accessoryView = cell!.accessoryView
    let selectionBtn = accessoryView!.subviews.first as! UIButton
    
    if list[indexPath.row].isSelected {
      let image = UIImage(systemName: "circle")
      selectionBtn.setImage(image, for: .normal)
      selectionBtn.tintColor = .label
    } else {
      let image = UIImage(systemName: "largecircle.fill.circle")
      selectionBtn.setImage(image, for: .normal)
      selectionBtn.tintColor = .tintColor
    }
    
    list[indexPath.row].isSelected = !list[indexPath.row].isSelected
    
    if delegate != nil && delegate!.responds(to: #selector(ErasedListPopupDelegate.erasedListPopupVC(erasedListPopupVC:updatedList:))) {
      delegate?.erasedListPopupVC?(erasedListPopupVC: self, updatedList: list)
    }
  }
  
  @objc private func handleSelectionBtnTapped(_ sender: UIButton) {
    tableView(_tblErasedList, didSelectRowAt: IndexPath(row: sender.tag, section: 0))
  }
}

class ErasedInformation: NSObject {
  var name: String!
  var isSelected = false
  
  init(name: String) {
    self.name = name
  }
}
