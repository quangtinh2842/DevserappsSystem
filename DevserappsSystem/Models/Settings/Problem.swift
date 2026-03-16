//
//  ProblemForm.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 04/04/2025.
//

import Foundation
import ObjectMapper

class Problem: NSObject, Mappable {
  @objc var subject: String?
  @objc var title: String?
  @objc var content: String?
  @objc var time: Date?
  
  init(subject: String? = nil, title: String? = nil, content: String? = nil, time: Date? = nil) {
    self.subject = subject
    self.title = title
    self.content = content
    self.time = time
  }
  
  init(problem: Problem?) {
    self.subject = problem?.subject
    self.title = problem?.title
    self.content = problem?.content
    self.time = problem?.time
  }
  
  required init?(map: Map) {
    let attributes: [String] = []
    let validations = attributes.map {
      map[$0].currentValue != nil
    }.reduce(true) { $0 && $1 }
    
    if !validations {
      return nil
    }
  }
  
  func mapping(map: Map) {
    subject     <- map["subject"]
    title       <- map["title"]
    content     <- map["content"]
    time        <- map["time"]
  }
}
