//
//  Geopoint.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 14/03/2025.
//

import Foundation
import ObjectMapper
import MapKit

class Geopoint: NSObject, Mappable {
  @objc var latitude: String?
  @objc var longitude: String?
  
  init(geopointParam: Geopoint?) {
    self.latitude = geopointParam?.latitude
    self.longitude = geopointParam?.longitude
  }
  
  init(coordinate: CLLocationCoordinate2D) {
    self.latitude = String(coordinate.latitude)
    self.longitude = String(coordinate.longitude)
  }
  
  override init() { super.init() }
  
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
    latitude    <- map["latitude"]
    longitude   <- map["longitude"]
  }
  
  func isDifferent(from geopoint: Geopoint?) -> Bool {
    if self.latitude != geopoint?.latitude {
      return true
    }
    
    if self.longitude != geopoint?.longitude {
      return true
    }
    
    return false
  }
  
  func toMKMapItem() -> MKMapItem? {
    if latitude != nil && longitude != nil {
      if let lat = Double(latitude!),
         let long = Double(longitude!) {
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let placemark = MKPlacemark(coordinate: coordinate)
        return MKMapItem(placemark: placemark)
      } else {
        return nil
      }
    } else {
      return nil
    }
  }
}

