//
//  SettingsStore.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 25/03/2025.
//

import Foundation
import RealmSwift
import Realm

struct SettingsStore {
  static var settings: MSettings!// = settingsForApp()
  
  static func settingsForApp() -> MSettings {
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
      Resource(name: "Firebase", url: URL(string: "https://github.com/firebase/firebase-ios-sdk")),
      Resource(name: "KRProgressHUD", url: URL(string: "https://github.com/krimpedance/KRProgressHUD")),
      Resource(name: "Toast", url: URL(string: "https://github.com/scalessec/Toast-Swift")),
      Resource(name: "AlamofireImage", url: URL(string: "https://github.com/Alamofire/AlamofireImage")),
      Resource(name: "ObjectMapper", url: URL(string: "https://github.com/tristanhimmelman/ObjectMapper")),
      Resource(name: "ESPullToRefresh", url: URL(string: "https://github.com/eggswift/pull-to-refresh")),
      Resource(name: "iOSDropDown", url: URL(string: "https://github.com/jriosdev/iOSDropDown")),
      Resource(name: "SwiftyJSON", url: URL(string: "https://github.com/SwiftyJSON/SwiftyJSON")),
      Resource(name: "LZViewPager", url: URL(string: "https://github.com/ladmini/LZViewPager")),
      Resource(name: "AZTabBarController", url: URL(string: "https://github.com/Minitour/AZTabBarController"))
    ])
    rst.about?.resources = List<Resource>(collection: resources as! RLMCollection)
    return rst
  }
}
