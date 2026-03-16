//
//  CountryCodeStore.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 26/03/2025.
//

import Foundation
import Alamofire
import SwiftyJSON
import ObjectMapper

typealias DownloadCountryCodesHandler = (_ error: Error?) -> ()

class CountryCodeStore: NSObject {
  static var shared = CountryCodeStore()
  fileprivate override init() {}
  
  var all: [CountryCode] { get { return _countryCodes } }
  
  fileprivate var _countryCodes: [CountryCode] = []
  
  func downloadCountryCodes(_ handler: @escaping DownloadCountryCodesHandler) {
    AF.request("https://gist.githubusercontent.com/anubhavshrimal/75f6183458db8c453306f93521e93d37/raw/f77e7598a8503f1f70528ae1cbf9f66755698a16/CountryCodes.json").response { [weak self] response in
      if response.response!.statusCode != 200 {
        handler(NotFoundError)
      } else {
        switch response.result {
        case .success(let jsonData):
          do {
            try self?._parseAndPopulateCountryCodes(fromJSONData: jsonData!)
            handler(nil)
          } catch {
            handler(error)
          }
        case .failure(let error):
          handler(error)
        }
      }
    }
  }
  
  private func _parseAndPopulateCountryCodes(fromJSONData jsonData: Data) throws {
    _countryCodes.removeAll()
    
    let countryCodeJSONArray = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as! NSArray
    for countryCodeJSON in countryCodeJSONArray {
      guard let countryCodeDict = countryCodeJSON as? [String: Any] else { continue }
      guard let countryCode = CountryCode(JSON: countryCodeDict) else { continue }
      _countryCodes.append(countryCode)
    }
  }
}

class CountryCode: NSObject, Mappable {
  @objc var name: String?
  @objc var dialCode: String?
  @objc var code: String?
  
  init(countryCode: CountryCode?) {
    self.name = countryCode?.name
    self.dialCode = countryCode?.dialCode
    self.code = countryCode?.code
  }
  
  required init?(map: Map) {
    let attributes: [String] = ["name", "dial_code", "code"]
    let validations = attributes.map {
      map[$0].currentValue != nil
    }.reduce(true) { $0 && $1 }
    
    if !validations {
      return nil
    }
  }
  
  func mapping(map: Map) {
    name       <- map["name"]
    dialCode   <- map["dial_code"]
    code   <- map["code"]
  }
  
  func isDifferent(from countryCode: CountryCode?) -> Bool {
    if self.name != countryCode?.name {
      return true
    }
    
    if self.dialCode != countryCode?.dialCode {
      return true
    }
    
    if self.code != countryCode?.code {
      return true
    }
    
    return false
  }
}
