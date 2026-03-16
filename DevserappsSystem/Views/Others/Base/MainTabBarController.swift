//
//  MainTabBarController.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 02/03/2025.
//

import UIKit

class MainTabBarController: UITabBarController {  
  override func viewDidLoad() {
    super.viewDidLoad()
    _setupViews()
  }
  
//  override func viewWillLayoutSubviews() { // consider to remove
//    super.viewWillLayoutSubviews()
//    self.selectedIndex = 0
//  }
  
  private func _setupViews() {
    self.tabBar.items?.first?.title = "●"
    self.delegate = self
  }
  
  func requireAllTabsReloading() {
    self.selectedIndex = 0

    for (i, subNC) in self.viewControllers!.enumerated() {
      self.tabBar.items?[i].title = ""
      let navigation = subNC as! UINavigationController

      if let systemsVC = navigation.viewControllers.first as? SystemsViewController {
        systemsVC.shouldRefreshViews = true
      } else if let scheduliesVC = navigation.viewControllers.first as? ScheduliesVC {
        scheduliesVC.shouldRefreshViews = true
      } else if let notificationsVC = navigation.viewControllers.first as? NotificationsVC {
        notificationsVC.shouldRefreshViews = true
      } else if let menuVC = navigation.viewControllers.first as? MenuViewController {
        menuVC.shouldRefreshViews = true
      }
    }
    
    self.tabBar.items?.first?.title = "●"
  }

  func requireAllTabsPopingToRootVC() {
    for subVC in self.viewControllers! {
      let navigation = subVC as! UINavigationController
      navigation.popToRootViewController(animated: false)
    }
  }
}

extension MainTabBarController: UITabBarControllerDelegate {
  func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
    if let systemsNC = (viewController as? UINavigationController),
        tabBarController.selectedIndex == 0 {
      if let systemsVC = systemsNC.viewControllers.first as? SystemsViewController {
        if systemsVC._vPager != nil {
          systemsVC._vPager.select(index: 0)
        }
      }
    }
    
    if let menuNC = (viewController as? UINavigationController),
        tabBarController.selectedIndex == 3 {
      if let menuVC = menuNC.viewControllers.first as? MenuViewController {
        if menuVC._vPager != nil {
          menuVC._vPager.select(index: 0)
        }
      }
    }
    
    tabBarController.tabBar.items?[tabBarController.selectedIndex].title = ""
    return true
  }
  
  func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    tabBarController.tabBar.items?[tabBarController.selectedIndex].title = "●"
  }
}
