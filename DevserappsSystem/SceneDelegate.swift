//
//  SceneDelegate.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 01/03/2025.
//

import UIKit
import FirebaseAuth
import KRProgressHUD
import Reachability

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
  
  private var _reachability: Reachability? = nil
  
  private lazy var _mainTBC: MainTabBarController = {
    return StoryboardHelper.newMainTBC()
  }()
  
  private var _noConnectionVC: NoConnectionVC?
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//    guard let _ = (scene as? UIWindowScene) else { return }
    
    guard let windowScene = (scene as? UIWindowScene) else { return }
    window = UIWindow(windowScene: windowScene)
    _checkCurrentUserToShowRootView()
    _setup()
  }
  
  private func _setup() {
    _reachability = try? Reachability()
    
    _reachability?.whenReachable = { [weak self] _ in
      self?._noConnectionVC?.dismiss(animated: true)
      self?._noConnectionVC = nil
    }
    
    _reachability?.whenUnreachable = { [weak self] _ in
      self?._noConnectionVC = StoryboardHelper.newNoConnectionVC()
      
      let sheet = self?._noConnectionVC?.sheetPresentationController
      sheet?.detents = [.medium()]
      sheet?.preferredCornerRadius = 24
      sheet?.delegate = self?._noConnectionVC
      
      let currentVC = self?.getCurrentVC()
      if self != nil {
        currentVC?.present(self!._noConnectionVC!, animated: true)
      }
    }
    
    try? _reachability?.startNotifier()
  }
  
  func getCurrentVC() -> UIViewController? {
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let rootVC = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController else {
      return nil
    }
    return getTopVC(from: rootVC)
  }
  
  private func getTopVC(from rootVC: UIViewController?) -> UIViewController? {
    if let nav = rootVC as? UINavigationController {
      return getTopVC(from: nav.visibleViewController)
    }
    if let tab = rootVC as? UITabBarController {
      return getTopVC(from: tab.selectedViewController)
    }
    if let presented = rootVC?.presentedViewController {
      return getTopVC(from: presented)
    }
    return rootVC
  }
  
  private func _checkCurrentUserToShowRootView() {
    let currentUser = Auth.auth().currentUser
    if (currentUser != nil) {
      if (currentUser!.isEmailVerified) {
        KRProgressHUD.show()
        MUser.find(byId: currentUser!.uid) { [weak self] result, error in
          KRProgressHUD.dismiss()
          if error != nil {
            self?.window?.rootViewController = StoryboardHelper.newHardToHandleErrorVC()
          } else {
            if result != nil {
              UserStore.currentUser = nil
              UserStore.currentUser = (result as! MUser)
              self?.window?.rootViewController = self?._mainTBC
            } else {
              self?.window?.rootViewController = StoryboardHelper.newHardToHandleErrorVC()
            }
          }
        }
      } else {
        window?.rootViewController = StoryboardHelper.newEmailVerificationNC()
      }
    } else {
      window?.rootViewController = StoryboardHelper.newLogInVC()
    }
    window?.makeKeyAndVisible()
  }
  
  func backMainTBC() {
    window?.rootViewController = _mainTBC
    window?.makeKeyAndVisible()
  }
  
  func showMainTBC() {
    _mainTBC.requireAllTabsPopingToRootVC()
    _mainTBC.requireAllTabsReloading()
    window?.rootViewController = _mainTBC
    window?.makeKeyAndVisible()
  }
  
  func showLogInVC() {
    window?.rootViewController = StoryboardHelper.newLogInVC()
    window?.makeKeyAndVisible()
  }
  
  func showEmailVerificationNC() {
    window?.rootViewController = StoryboardHelper.newEmailVerificationNC()
    window?.makeKeyAndVisible()
  }
  
  func showHardToHandleErrorVC() {
    window?.rootViewController = StoryboardHelper.newHardToHandleErrorVC()
    window?.makeKeyAndVisible()
  }
  
  func sceneDidDisconnect(_ scene: UIScene) {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
  }
  
  func sceneDidBecomeActive(_ scene: UIScene) {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
  }
  
  func sceneWillResignActive(_ scene: UIScene) {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
  }
  
  func sceneWillEnterForeground(_ scene: UIScene) {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
  }
  
  func sceneDidEnterBackground(_ scene: UIScene) {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
  }
}
