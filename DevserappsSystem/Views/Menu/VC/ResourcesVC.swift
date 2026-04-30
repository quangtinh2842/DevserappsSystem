//
//  ResourcesVC.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 03/04/2025.
//

import UIKit
import Toast

class ResourcesVC: UITableViewController {
  var shouldSetupViews: Bool = true
  var shouldPopulateDataFromResources: Bool = true
  var shouldRefreshViews: Bool = false
  
  var resources: [Resource] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if shouldSetupViews {
      _setupViews()
      shouldSetupViews = false
    }
    
    if shouldPopulateDataFromResources {
      _populateDataFromResources()
      shouldPopulateDataFromResources = false
    }
    
    if shouldRefreshViews {
      _refreshViews()
      shouldRefreshViews = false
    }
  }
  
  private func _setupViews() {
  }
  
  private func _populateDataFromResources() {
  }
  
  private func _refreshViews() {
  }
}

extension ResourcesVC {
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return resources.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ReuseID.ResourceCell.rawValue) as! ResourceCell
    cell.updateViews(with: resources[indexPath.row])
    
    let accessoryView = UIView()
    accessoryView.frame.origin = .zero
    accessoryView.frame.size = CGSize(width: 50, height: 50)
    
    let detailBtn = UIButton(type: .detailDisclosure)
    detailBtn.tag = indexPath.row
    detailBtn.frame.size = CGSize(width: 24, height: 24)
    detailBtn.frame.origin = CGPoint(x: 13, y: 13)
    detailBtn.addTarget(self, action: #selector(_handleDetailBtnTapped), for: .touchUpInside)
    accessoryView.addSubview(detailBtn)
    
    cell.accessoryView = accessoryView
    
    return cell
  }
  
  @objc private func _handleDetailBtnTapped(_ sender: UIButton) {
    let alertController = UIAlertController(title: resources[sender.tag].url, message: nil, preferredStyle: .actionSheet)
    let copyAction = UIAlertAction(title: "Copy", style: .default) { [weak self] _ in
      UIPasteboard.general.string = self?.resources[sender.tag].url
      self?.navigationController?.view.makeToast("copied", duration: 2.0, position: .bottom)
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    alertController.addAction(copyAction)
    alertController.addAction(cancelAction)
    present(alertController, animated: true)
  }
}
