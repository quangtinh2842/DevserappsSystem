//
//  SettingsStore.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 25/03/2025.
//

import Foundation

struct SettingsStore {
  static var currentSettings: MSettings!
  
  static func initialSettings() -> MSettings {
    let rst = MSettings()
    rst.id = UserStore.currentUser.uid
    rst.notifications = Notifications(notifications: nil)
    rst.notifications?.isAllOn = "True"
    rst.appearance = "Auto"
    rst.language = "vi"
    rst.sync = Sync(sync: nil)
    rst.about = About(about: nil)
    rst.about?.version = "0.0.0"
    var resources = [Resource]()
    resources.append(contentsOf: [
      Resource(name: "Firebase", url: "https://github.com/firebase/firebase-ios-sdk"),
      Resource(name: "KRProgressHUD", url: "https://github.com/krimpedance/KRProgressHUD"),
      Resource(name: "Toast", url: "https://github.com/scalessec/Toast-Swift"),
      Resource(name: "AlamofireImage", url: "https://github.com/Alamofire/AlamofireImage"),
      Resource(name: "ObjectMapper", url: "https://github.com/tristanhimmelman/ObjectMapper"),
      Resource(name: "ESPullToRefresh", url: "https://github.com/eggswift/pull-to-refresh"),
      Resource(name: "iOSDropDown", url: "https://github.com/jriosdev/iOSDropDown"),
      Resource(name: "SwiftyJSON", url: "https://github.com/SwiftyJSON/SwiftyJSON"),
      Resource(name: "LZViewPager", url: "https://github.com/ladmini/LZViewPager"),
      Resource(name: "AZTabBarController", url: "https://github.com/Minitour/AZTabBarController")
    ])
    rst.about?.resources = resources
    return rst
  }
}
