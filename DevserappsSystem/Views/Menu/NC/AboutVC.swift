//
//  AboutVC.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 03/04/2025.
//

import UIKit
import Realm
import RealmSwift

class AboutVC: UITableViewController {
  var shouldSetupViews = true
  var shouldPopulateDataFromAbout = true
  var shouldRefreshViews = false
  
  @IBOutlet weak var _lblVersion: UILabel!
  @IBOutlet weak var _lblNResources: UILabel!
  
  var about: About?
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if shouldSetupViews {
      _setupViews()
      shouldSetupViews = false
    }
    
    if shouldPopulateDataFromAbout {
      _populateDataFromAbout()
      shouldPopulateDataFromAbout = false
    }
    
    if shouldRefreshViews {
      _refreshViews()
      shouldRefreshViews = false
    }
  }
  
  private func _refreshViews() {
  }
  
  private func _setupViews() {
    navigationController?.navigationBar.tintColor = .label
    
    let yourBackImage = UIImage(systemName: "arrow.backward")
    navigationController?.navigationBar.backIndicatorImage = yourBackImage
    navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
  }
  
  private func _populateDataFromAbout() {
    _lblVersion.text = about?.version
    _lblNResources.text = String(about?.resources.count ?? 0)
  }
  
  @IBAction func handleBackBtnTapped(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
}

extension AboutVC {
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == 1 && indexPath.row == 0 {
      let resourcesVC = StoryboardHelper.newResourcesVC()
      if SettingsStore.settings.about?.resources != nil {
        resourcesVC.resources = Array(SettingsStore.settings.about!.resources)
      }
      navigationController?.pushViewController(resourcesVC, animated: true)
    }
  }
}
