//
//  InitialManager.swift
//  DevserappsSystem
//
//  Created by Soren Inis Ngo on 06/04/2026.
//

import Foundation

class InitialManager {
  static func pushAndPullSomething() async throws {
    try await _pushAndPullForSettings()
    try await _pullForNotifications()
  }
  
  static private func _pullForNotifications() async throws {
    NotificationsStore.notifications = try await _pullNotifications()
  }
  
  static private func _pushAndPullForSettings() async throws {
    if UserStore.currentUser.settingsID == nil {
      try await _pushInitialSettings()
      SettingsStore.currentSettings = SettingsStore.initialSettings()
      UserStore.currentUser.settingsID = SettingsStore.currentSettings.id
      let _ = try await UserStore.currentUser.saveAsync()
    } else {
      let settings = try await _pullSettings()
      SettingsStore.currentSettings = settings
    }
  }
  
  static private func _pushInitialSettings() async throws {
    let initialSettings = SettingsStore.initialSettings()
    let _ = try await initialSettings.saveAsync()
  }
  
  static private func _pullSettings() async throws -> MSettings {
    return try await MSettings.findAsync(byId: UserStore.currentUser.settingsID!) as! MSettings
  }
  
  static private func _pullNotifications() async throws -> [MNotification] {
    return try await withCheckedThrowingContinuation { continuation in
      MNotification.allNotificationsForCurrentUser { results, error in
        if let error = error {
          continuation.resume(throwing: error)
        } else {
          continuation.resume(returning: results as! [MNotification])
        }
      }
    }
  }
}
