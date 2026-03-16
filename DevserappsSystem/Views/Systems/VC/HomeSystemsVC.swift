//
//  SystemsViewController.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 03/03/2025.
//

import UIKit
import FirebaseAuth
import KRProgressHUD

class HomeSystemsVC: UITableViewController {
  var shouldRefreshViews: Bool = false
  
  private var _bgrTapGestureRecog: UITapGestureRecognizer!
  
  private var _systems: [MSystem] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    _setupViews()
    _refreshAndPopulateSystemsData()
  }
  
  private func _setupViews() {
//    navigationController?.setNavigationBarHidden(true, animated: false)
    
    refreshControl?.addTarget(self, action: #selector(_refreshAndPopulateSystemsData), for: .valueChanged)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if shouldRefreshViews {
      _refreshViews()
      shouldRefreshViews = false
    }
  }
  
  private func _refreshViews() {
    _refreshAndPopulateSystemsData()
  }
  
  @objc private func _refreshAndPopulateSystemsData() {
    MSystem.allSystemsForCurrentUser { [weak self] results, error in
      if error != nil {
        self?._presentBasicAlert(title: error!.localizedDescription, message: nil)
      }
      
      self?._systems = results as! [MSystem]
      
      self?._populateSystemsData()
      self?.refreshControl?.endRefreshing()
    }
  }
  
  private func _populateSystemsData() {
    tableView.reloadData()
  }
  
  private func _presentBasicAlert(title: String?, message: String?) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    self.present(alert, animated: true, completion: nil)
  }
  
  @objc private func _cellLongPressGestureRecognizered() {
    if tableView.isEditing == false {
      tableView.isEditing = true
      _bgrTapGestureRecog = UITapGestureRecognizer(target: self, action: #selector(_bgrTapGestureRecognizered))
      self.view.addGestureRecognizer(_bgrTapGestureRecog)
    }
  }
  
  @objc private func _bgrTapGestureRecognizered() {
    if tableView.isEditing {
      tableView.isEditing = false
      self.view.removeGestureRecognizer(_bgrTapGestureRecog)
    }
  }
}

// MARK: - TableView
extension HomeSystemsVC {
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return UIView(frame: .zero)
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return _systems.count
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 160
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ReuseID.SystemCell.rawValue) as! SystemCell
    cell.setupCellView()
    cell.updateCell(withData: _systems[indexPath.row])
    cell.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(_cellLongPressGestureRecognizered)))
    return cell
  }
  
  override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
    let movedItem = _systems.remove(at: fromIndexPath.row)
    _systems.insert(movedItem, at: to.row)
  }
  
  override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    return .none
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let systemVC = StoryboardHelper.newSystemVC()
    systemVC.title = _systems[indexPath.row].displayName
    self.navigationController?.pushViewController(systemVC, animated: true)
  }
}
