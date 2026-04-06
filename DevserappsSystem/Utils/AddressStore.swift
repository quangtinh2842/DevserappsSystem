//
//  UserStore.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 06/03/2025.
//

import Foundation
import Alamofire
import SwiftyJSON
import ObjectMapper

typealias DownloadAddressesHandler = (_ error: Error?) -> ()

class AddressStore: NSObject {
  static var shared = AddressStore()
  fileprivate override init() {}
  
  var provinces: [Province] { get { return _provinces } }
  var districts: [District] { get { return _districts } }
  var wards: [Ward] { get { return _wards } }
  
  fileprivate var _provinces: [Province] = []
  fileprivate var _districts: [District] = []
  fileprivate var _wards: [Ward] = []
  
  func downloadAddresses(_ handler: @escaping DownloadAddressesHandler) {
    AF.request("https://raw.githubusercontent.com/quangtinh2842/PublicStore/refs/heads/main/addresses/vn/vn_only_simplified_json_generated_data_vn_units_minified.json").response { [weak self] response in
      if response.response!.statusCode != 200 {
        handler(NotFoundError)
      } else {
        switch response.result {
        case .success(let jsonData):
          do {
            try self?._parseAndPopulateRegionAddresses(fromJSONData: jsonData!)
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
  
  private func _parseAndPopulateRegionAddresses(fromJSONData jsonData: Data) throws {
    _provinces.removeAll()
    _districts.removeAll()
    _wards.removeAll()
    
    let provinceJSONArray = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as! NSArray
    for provinceJSON in provinceJSONArray {
      guard let provinceDict = provinceJSON as? [String: Any] else { continue }
      guard let province = Province(JSON: provinceDict) else { continue }
      _provinces.append(province)
      
      guard let districtDictArray = provinceDict["District"] as? [[String: Any]] else { continue }
      for districtDict in districtDictArray {
        guard let district = District(JSON: districtDict) else { continue }
        _districts.append(district)
        
        guard let wardDictArray = districtDict["Ward"] as? [[String: Any]] else { continue }
        for wardDict in wardDictArray {
          guard let ward = Ward(JSON: wardDict) else { continue }
          _wards.append(ward)
        }
      }
    }
  }
  
  func isEmpty() -> Bool {
    return _provinces.isEmpty && districts.isEmpty && wards.isEmpty
  }
}

class Province: NSObject, Mappable {
  @objc var code: String?
  @objc var fullName: String?
  
  init(provinceParam: Province?) {
    self.code = provinceParam?.code
    self.fullName = provinceParam?.fullName
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
    code       <- map["Code"]
    fullName   <- map["FullName"]
  }
}

class District: NSObject, Mappable {
  @objc var code: String?
  @objc var fullName: String?
  @objc var provinceCode: String?
  
  init(districtParam: District?) {
    self.code = districtParam?.code
    self.fullName = districtParam?.fullName
    self.provinceCode = districtParam?.provinceCode
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
    code           <- map["Code"]
    fullName       <- map["FullName"]
    provinceCode   <- map["ProvinceCode"]
  }
}

class Ward: NSObject, Mappable {
  @objc var code: String?
  @objc var fullName: String?
  @objc var districtCode: String?
  
  init(wardParam: Ward?) {
    self.code = wardParam?.code
    self.fullName = wardParam?.fullName
    self.districtCode = wardParam?.districtCode
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
    code           <- map["Code"]
    fullName       <- map["FullName"]
    districtCode   <- map["DistrictCode"]
  }
}
