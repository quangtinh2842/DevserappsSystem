//
//  StoryboardHelper.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 07/03/2025.
//

import UIKit

class StoryboardHelper {
  private init() {}
  
  static func newVC(withID id: String, fromStoryboard storyboardParam: UIStoryboard = newMain()) -> UIViewController {
    return storyboardParam.instantiateViewController(withIdentifier: id)
  }
  
  // MARK: - Main
  static func newMain() -> UIStoryboard {
    return UIStoryboard(name: "Main", bundle: nil)
  }
  
  static func newHardToHandleErrorVC() -> HardToHandleErrorViewController {
    let vc = newVC(withID: MainSbVCID.HardToHandleErrorVCID.rawValue)
    return (vc as! HardToHandleErrorViewController)
  }
  
  static func newLogInVC() -> LogInViewController {
    let vc = newVC(withID: MainSbVCID.LogInVCID.rawValue)
    return (vc as! LogInViewController)
  }
  
  static func newMainTBC() -> MainTabBarController {
    let vc = newVC(withID: MainSbVCID.MainTBCID.rawValue)
    return (vc as! MainTabBarController)
  }
  
  static func newSystemVC() -> SystemViewController {
    let vc = newVC(withID: MainSbVCID.SystemVCID.rawValue)
    return (vc as! SystemViewController)
  }
  
  static func newEmailVerificationNC() -> UINavigationController {
    let nc = newVC(withID: MainSbVCID.EmailVerificationNCID.rawValue)
    return (nc as! UINavigationController)
  }
  
  static func newSettingsVC() -> SettingsViewController {
    let vc = newVC(withID: MainSbVCID.SettingsVCID.rawValue)
    return (vc as! SettingsViewController)
  }
  
  static func newProfileNC() -> UINavigationController {
    let nc = newVC(withID: MainSbVCID.ProfileNCID.rawValue)
    return (nc as! UINavigationController)
  }
  
  static func newProfileVC() -> ProfileViewController {
    let vc = newVC(withID: MainSbVCID.ProfileVCID.rawValue)
    return (vc as! ProfileViewController)
  }
  
  static func newAccountVC() -> AccountViewController {
    let vc = newVC(withID: MainSbVCID.AccountVCID.rawValue)
    return (vc as! AccountViewController)
  }
  
  static func newAccountNC() -> UINavigationController {
    let nc = newVC(withID: MainSbVCID.AccountNCID.rawValue)
    return (nc as! UINavigationController)
  }
  
  static func newSystemsNC() -> UINavigationController {
    let nc = newVC(withID: MainSbVCID.SystemsNCID.rawValue)
    return (nc as! UINavigationController)
  }
  
  static func newScheduleNC() -> UINavigationController {
    let nc = newVC(withID: MainSbVCID.ScheduleNCID.rawValue)
    return (nc as! UINavigationController)
  }
  
  static func newNotificationsNC() -> UINavigationController {
    let nc = newVC(withID: MainSbVCID.NotificationsNCID.rawValue)
    return (nc as! UINavigationController)
  }
  
  static func newMenuNC() -> UINavigationController {
    let nc = newVC(withID: MainSbVCID.MenuNCID.rawValue)
    return (nc as! UINavigationController)
  }
  
  static func newAppearanceNC() -> UINavigationController {
    let nc = newVC(withID: MainSbVCID.AppearanceNCID.rawValue)
    return (nc as! UINavigationController)
  }
  
  static func newLanguageNC() -> UINavigationController {
    let nc = newVC(withID: MainSbVCID.LanguageNCID.rawValue)
    return (nc as! UINavigationController)
  }
  
  static func newNotificationsSettingsNC() -> UINavigationController {
    let nc = newVC(withID: MainSbVCID.NotificationsSettingsNCID.rawValue)
    return (nc as! UINavigationController)
  }
  
  static func newSyncNC() -> UINavigationController {
    let nc = newVC(withID: MainSbVCID.SyncNCID.rawValue)
    return (nc as! UINavigationController)
  }
  
  static func newAboutNC() -> UINavigationController {
    let nc = newVC(withID: MainSbVCID.AboutNCID.rawValue)
    return (nc as! UINavigationController)
  }
  
  static func newProblemsToProviderNC() -> UINavigationController {
    let nc = newVC(withID: MainSbVCID.ProblemsToProviderNCID.rawValue)
    return (nc as! UINavigationController)
  }
  
  static func newProblemToProviderNC() -> UINavigationController {
    let nc = newVC(withID: MainSbVCID.ProblemToProviderNCID.rawValue)
    return (nc as! UINavigationController)
  }
  
  static func newSearchPopupVC() -> SearchPopupViewController {
    let vc = newVC(withID: MainSbVCID.SearchPopupVCID.rawValue)
    return (vc as! SearchPopupViewController)
  }
  
  static func newBasicControlPopupVC() -> BasicControlPopupViewController {
    let vc = newVC(withID: MainSbVCID.BasicControlPopupVCID.rawValue)
    return (vc as! BasicControlPopupViewController)
  }
  
  static func newHomeSystemsVC() -> HomeSystemsVC {
    let vc = newVC(withID: MainSbVCID.HomeSystemsVCID.rawValue)
    return (vc as! HomeSystemsVC)
  }
  
  static func newTankSystemsVC() -> TankSystemsVC {
    let vc = newVC(withID: MainSbVCID.TankSystemsVCID.rawValue)
    return (vc as! TankSystemsVC)
  }
  
  static func newOtherSystemsVC() -> OtherSystemsVC {
    let vc = newVC(withID: MainSbVCID.OtherSystemsVCID.rawValue)
    return (vc as! OtherSystemsVC)
  }
  
  static func newCountryCodesVC() -> CountryCodesVC {
    let vc = newVC(withID: MainSbVCID.CountryCodesVCID.rawValue)
    return (vc as! CountryCodesVC)
  }
  
  static func newErasedListPopupVC() -> ErasedListPopupVC {
    let vc = newVC(withID: MainSbVCID.ErasedListPopupVCID.rawValue)
    return (vc as! ErasedListPopupVC)
  }
  
  static func newSyncVC() -> SyncVC {
    let vc = newVC(withID: MainSbVCID.SyncVCID.rawValue)
    return (vc as! SyncVC)
  }
  
  static func newResourcesVC() -> ResourcesVC {
    let vc = newVC(withID: MainSbVCID.ResourcesVCID.rawValue)
    return (vc as! ResourcesVC)
  }
  
  static func newProblemsToProviderVC() -> ProblemsToProviderVC {
    let vc = newVC(withID: MainSbVCID.ProblemsToProviderVCID.rawValue)
    return (vc as! ProblemsToProviderVC)
  }
  
  static func newSensorPopupVC() -> SensorPopupVC {
    let vc = newVC(withID: MainSbVCID.SensorPopupVCID.rawValue)
    return (vc as! SensorPopupVC)
  }
  
  static func newNoConnectionVC() -> NoConnectionVC {
    let vc = newVC(withID: MainSbVCID.NoConnectionVCID.rawValue)
    return (vc as! NoConnectionVC)
  }
  
  static func newNotificationVC() -> NotificationVC {
    let vc = newVC(withID: MainSbVCID.NotificationVCID.rawValue)
    return (vc as! NotificationVC)
  }
  
  // MARK: - Device
  static func newDevice() -> UIStoryboard {
    return UIStoryboard(name: "Device", bundle: nil)
  }
  
  static func newDeviceHomeNC() -> UINavigationController {
    let nc = newVC(withID: DeviceSbVCID.DeviceHomeNCID.rawValue, fromStoryboard: newDevice())
    return (nc as! UINavigationController)
  }
}
