//
//  SettingsVC.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 19/03/2025.
//

import UIKit

@objc protocol SettingsDelegate: NSObjectProtocol {
  @objc optional func settingsViewController(settingsVC: SettingsViewController, settingsData: MSettings)
}

class SettingsViewController: UITableViewController {
  var shouldSetupViews = true
  var shouldPopulateDataFromDefaultSettings = true
  var shouldRefreshViews = false
  
  @IBOutlet weak var _lblNotifications: UILabel!
  @IBOutlet weak var _lblAppearance: UILabel!
  @IBOutlet weak var _lblLanguage: UILabel!
  @IBOutlet weak var _lblLastSyncTime: UILabel!
  @IBOutlet weak var _lblVersion: UILabel!
  
  var delegate: SettingsDelegate?
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if shouldSetupViews {
      _setupViews()
      shouldSetupViews = false
    }
    
    if shouldPopulateDataFromDefaultSettings {
      _populateDataFromDefaultSettings()
      shouldPopulateDataFromDefaultSettings = false
    }
    
    if shouldRefreshViews {
      _refreshViews()
      shouldRefreshViews = false
    }
  }
  
  private func _setupViews() {
  }
  
  private func _refreshViews() {
  }
  
  private func _populateDataFromDefaultSettings() {
    if let isAllOn = SettingsStore.settings.notifications?.isAllOn?.toBool() {
      _lblNotifications.text = isAllOn ? "On" : "Off"
    }
    _lblAppearance.text = SettingsStore.settings.appearance
    _lblLanguage.text = SettingsStore.settings.language
    _lblLastSyncTime.text = SettingsStore.settings.sync?.last()?.ddMMyyyy() ?? ""
    _lblVersion.text = SettingsStore.settings.about?.version ?? ""
  }
}

extension SettingsViewController {
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == 0 && indexPath.row == 0 {
      let notificationsNC = StoryboardHelper.newNotificationsSettingsNC()
      if let vc = notificationsNC.viewControllers.first as? NotificationsSettingsVC {
        vc.delegate = self
        vc.notifications = Notifications(notifications: SettingsStore.settings.notifications)
        navigationController?.pushViewController(vc, animated: true)
      }
    }
    
    if indexPath.section == 0 && indexPath.row == 1 {
      let appearanceNC = StoryboardHelper.newAppearanceNC()
      if let sheet = appearanceNC.sheetPresentationController {
        sheet.detents = [.medium()]
        sheet.preferredCornerRadius = 24
      }
      if let vc = appearanceNC.viewControllers.first as? AppearanceVC {
        vc.delegate = self
        vc.appearance = SettingsStore.settings.appearance
      }
      self.present(appearanceNC, animated: true)
    }
    
    if indexPath.section == 0 && indexPath.row == 2 {
      let languageNC = StoryboardHelper.newLanguageNC()
      if let sheet = languageNC.sheetPresentationController {
        sheet.detents = [.medium()]
        sheet.preferredCornerRadius = 24
      }
      if let vc = languageNC.viewControllers.first as? LanguageVC {
        vc.delegate = self
        vc.language = SettingsStore.settings.language
      }
      self.present(languageNC, animated: true)
    }
    
    if indexPath.section == 0 && indexPath.row == 3 {
      let syncNC = StoryboardHelper.newSyncNC()
      if let sheet = syncNC.sheetPresentationController {
        sheet.detents = [.medium(), .large()]
        sheet.preferredCornerRadius = 24
      }
      if let vc = syncNC.viewControllers.first as? SyncVC {
        vc.delegate = self
        vc.sync = Sync(sync: SettingsStore.settings.sync)
      }
      self.present(syncNC, animated: true)
    }
    
    if indexPath.section == 0 && indexPath.row == 4 {
      let aboutNC = StoryboardHelper.newAboutNC()
      if let vc = aboutNC.viewControllers.first as? AboutVC {
        vc.about = About(about: SettingsStore.settings.about)
        navigationController?.pushViewController(vc, animated: true)
      }
    }
    
    if indexPath.section == 1 && indexPath.row == 0 {
      let problemsToProviderNC = StoryboardHelper.newProblemsToProviderNC()
      if let vc = problemsToProviderNC.viewControllers.first as? ProblemsToProviderVC {
        vc.title = "App feedbacks"
        vc.problems = SettingsStore.settings.appFeedbacks
        navigationController?.pushViewController(vc, animated: true)
      }
    }
    
    if indexPath.section == 1 && indexPath.row == 1 {
      let problemsToProviderNC = StoryboardHelper.newProblemsToProviderNC()
      if let vc = problemsToProviderNC.viewControllers.first as? ProblemsToProviderVC {
        vc.title = "Bug reports"
        vc.problems = SettingsStore.settings.bugReports
        navigationController?.pushViewController(vc, animated: true)
      }
    }
    
    if indexPath.section == 2 && indexPath.row == 0 {
      let problemsToProviderNC = StoryboardHelper.newProblemsToProviderNC()
      if let vc = problemsToProviderNC.viewControllers.first as? ProblemsToProviderVC {
        vc.title = "Help & Support requests"
        vc.problems = SettingsStore.settings.helpAndSupportRequests
        navigationController?.pushViewController(vc, animated: true)
      }
    }
  }
}

extension SettingsViewController: NotificationsSettingsDelegate {
  func notificationsSettingsVC(notificationsSettingsVC: NotificationsSettingsVC, didEditNotificationsSettings editedNotificationsSettings: Notifications) {
    SettingsStore.settings.notifications = Notifications(notifications: editedNotificationsSettings)
    if let isAllOn = editedNotificationsSettings.isAllOn?.toBool() {
      _lblNotifications.text = isAllOn ? "On" : "Off"
    }
  }
}

extension SettingsViewController: AppearanceDelegate {
  func appearanceVC(appearanceVC: AppearanceVC, didSelect selectedAppearance: String) {
    SettingsStore.settings.appearance = selectedAppearance
    _lblAppearance.text = selectedAppearance
  }
}

extension SettingsViewController: LanguageDelegate {
  func languageVC(languageVC: LanguageVC, didSelect selectedLanguage: String) {
    SettingsStore.settings.language = selectedLanguage
    _lblLanguage.text = selectedLanguage
  }
}

extension SettingsViewController: SyncDelegate {
  func syncVC(syncVC: SyncVC, didEditSync synced: Sync) {
    SettingsStore.settings.sync = Sync(sync: synced)
    _lblLastSyncTime.text = synced.last()?.ddMMyyyy() ?? ""
  }
}
