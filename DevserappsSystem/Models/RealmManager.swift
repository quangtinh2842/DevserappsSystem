//  Nguyen Xuan Thanh (Unica)
//  Link: https://bitbucket.org/edm-courses/edm-01-ios-beginners/src/master/hot-girls-vn-2/hot-girls-vn/models/RealmManager.swift

//
//  RealmManager.swift
//  hot-girls-vn
//
//  Created by Ethan Nguyen on 6/9/16.
//  Copyright © 2016 Thanh Nguyen. All rights reserved.
//

import Foundation
import RealmSwift
import Alamofire
import SwiftyJSON

class RealmManager: NSObject {
  // Singleton declarations
  static var sharedManager = RealmManager()
  
  fileprivate override init() {
    NSLog("DB file path: \(Realm.Configuration().fileURL!.absoluteString)")
    do {
      _realmInstance = try Realm()
    } catch (let error as NSError) {
      NSLog("Realm initialization error: \(error)")
    }
  }
  
  fileprivate var _realmInstance: Realm!
  var realmInstance: Realm { get { return _realmInstance! } }
  
//  func insertPosts(_ posts: [JSON]) {
//    do {
//      var savedPosts = [MPost]()
//
//      try _realmInstance!.write {
//        for post in posts {
//          let newPost = MPost.newObject(fromAttributes: post)
//          let existedPost = MPost.find(withQuery: "imageUrl == '\(newPost.imageUrl)'")
//
//          if existedPost != nil {
//            // If existed, update
//            _realmInstance.add(existedPost!, update: true)
//          } else {
//            // Else, add new
//            _realmInstance.add(newPost)
//          }
//
//          savedPosts.append(newPost)
//        }
//      }
//
//      self._downloadAndSaveImages(forPosts: savedPosts)
//    } catch (let error as NSError) {
//      NSLog("Realm saving error: \(error)")
//    }
//  }
//
//  func clearPosts(multiplePosts posts: [MPost] = [MPost](), singlePost post: MPost? = nil, clearAll: Bool = false) {
//    do {
//      try _realmInstance.write{
//        if !posts.isEmpty {
//          _realmInstance.delete(posts)
//        }
//
//        if post != nil {
//          _realmInstance.delete(post!)
//        }
//
//        if clearAll {
//          _realmInstance.deleteAll()
//        }
//      }
//    } catch (let error as NSError) {
//      NSLog("Realm saving error: \(error)")
//    }
//  }
//
//  fileprivate func _downloadAndSaveImages(forPosts posts: [MPost]) {
//    for post in posts {
//      Alamofire.request(post.imageUrl, method: .get).responseImage { [weak self] (response) in
//        switch response.result {
//        case .success(let imageData):
//          do {
//            try self?._realmInstance.write {
//              post.imageData = UIImageJPEGRepresentation(imageData, 1)
//            }
//          } catch (let error as NSError) {
//            NSLog("Realm saving error: \(error)")
//          }
//        default: break
//        }
//      }
//    }
//  }
}
