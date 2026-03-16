//
//  MenuViewController.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 02/03/2025.
//

import UIKit
import MapKit

@objc protocol SearchPopupDelegate: NSObjectProtocol {
  @objc optional func searchPopupViewController(searchPopupVC: SearchPopupViewController, didSelectRow rowData: String)
}

class SearchPopupViewController: UIViewController {
  var shouldRefreshViews: Bool = false
  
  private let _MIN_CONTAINER_HEIGHT: CGFloat = (8+34+8)
  private let _MAX_CONTAINER_HEIGHT: CGFloat = 410 // (8+34+8)+(44*8)+8
  
  @IBOutlet weak var _vContainer: UIView!
  @IBOutlet weak var _txtSearch: UITextField!
  @IBOutlet weak var _tblTableView: UITableView!
  
  var delegate: SearchPopupDelegate?
  var searchPlaceholder: String?
  var list: [String] = []
  
  private var _filteredList: [String] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    _setupViews()
    _filteredList = list
    _considerFilterdListToSetHeightForContainerAndTableView()
    _populateData()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if shouldRefreshViews {
      _refreshViews()
      shouldRefreshViews = false
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    _txtSearch.becomeFirstResponder()
  }
  
  private func _refreshViews() {
    _populateData()
  }
  
  private func _setupViews() {
    _vContainer.frame = CGRect(x: (view.frame.width-300)/2, y: view.frame.height/5, width: 300, height: 50)
    _vContainer.layer.cornerRadius = 8
    
    let magnifyingGlass = UIImageView(image: UIImage(systemName: "magnifyingglass"))
    magnifyingGlass.tintColor = .gray
    magnifyingGlass.contentMode = .scaleAspectFit
    magnifyingGlass.frame = CGRect(x: 5, y: 5, width: 24, height: 24)
    let leftView = UIView()
    leftView.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
    leftView.addSubview(magnifyingGlass)
    _txtSearch.leftView = leftView
    _txtSearch.leftViewMode = .always
    
    _txtSearch.placeholder = searchPlaceholder
  }
  
  private func _populateData() {
  }
  
  @IBAction func outsideTapped(_ sender: Any) {
    self.dismiss(animated: true)
  }
  
  @IBAction func searchEditingChanged(_ sender: Any) {
    let searchText = _txtSearch.text ?? ""
    
    if searchText.isEmpty {
      _filteredList = list
    } else {
      _filteredList = search(withText: searchText, listParam: list)
    }
    
    _considerFilterdListToSetHeightForContainerAndTableView()
    
    _tblTableView.reloadData()
  }
  
  private func _considerFilterdListToSetHeightForContainerAndTableView() {
    if _filteredList.count == 0 {
      _vContainer.frame.size.height = _MIN_CONTAINER_HEIGHT
    } else if _filteredList.count >= 8 {
      _vContainer.frame.size.height = _MAX_CONTAINER_HEIGHT
      _tblTableView.frame.size.height = 44*8
    } else {
      _vContainer.frame.size.height = _MIN_CONTAINER_HEIGHT + CGFloat(44*_filteredList.count) + 8
      _tblTableView.frame.size.height = CGFloat(44*_filteredList.count)
    }
  }
}

extension SearchPopupViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if self.delegate != nil && self.delegate!.responds(to: #selector(SearchPopupDelegate.searchPopupViewController(searchPopupVC:didSelectRow:))) {
      self.delegate?.searchPopupViewController?(searchPopupVC: self, didSelectRow: _filteredList[indexPath.row])
      self.dismiss(animated: true)
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return _filteredList.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 44
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ReuseID.BasicSearchCell.rawValue)!
    var contentConfiguration = cell.defaultContentConfiguration()
    contentConfiguration.text = _filteredList[indexPath.row]
    cell.contentConfiguration = contentConfiguration
    return cell
  }
}

extension SearchPopupViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    _txtSearch.resignFirstResponder()
    return true
  }
}
