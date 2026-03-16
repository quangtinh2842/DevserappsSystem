//
//  MenuViewController.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 02/03/2025.
//

import UIKit
import MapKit
import KRProgressHUD

@objc protocol PinMapDelegate: NSObjectProtocol {
  @objc optional func pinMapViewController(pinMapVC: PinMapViewController, didEditLocation editedLocationData: Geopoint)
}

class PinMapViewController: UIViewController {
  var shouldRefreshViews: Bool = false
  
  @IBOutlet weak var _btnDone: UIBarButtonItem!
  @IBOutlet weak var _vMap: MKMapView!
  
  var delegate: PinMapDelegate?
  var firstLocationData: Geopoint?
  
  private var _editedLocationData: Geopoint!
  
  override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
    if identifier == SegueID.BackPinMap.rawValue {
      return true
    }
    
    if identifier == SegueID.DonePinMap.rawValue {
      self.delegate?.pinMapViewController?(pinMapVC: self, didEditLocation: Geopoint(geopointParam: _editedLocationData))
      return true
    }
    
    return true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    _setupViews()
    _populateLocationData()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if shouldRefreshViews {
      _refreshViews()
      shouldRefreshViews = false
    }
  }
  
  private func _refreshViews() {
    _populateLocationData()
  }
  
  private func _setupViews() {
    if firstLocationData != nil {
      self.title = "Edit pin"
    } else {
      self.title = "Add new pin"
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(_handleTap))
      _vMap.addGestureRecognizer(tapGesture)
    }
  }
  
  @objc private func _handleTap(gesture: UITapGestureRecognizer) {
    let point = gesture.location(in: _vMap)
    let coordinate = _vMap.convert(point, toCoordinateFrom: _vMap)
    let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
    _pinAnnotation(withMapItem: mapItem)
    gesture.isEnabled = false
    _editedLocationData = Geopoint(coordinate: coordinate)
    _btnDone.isEnabled = true
  }
  
  private func _populateLocationData() {
    _editedLocationData = Geopoint(geopointParam: firstLocationData)
    
    if firstLocationData?.latitude != nil && firstLocationData?.longitude != nil {
      let latitude = Double(firstLocationData!.latitude!)!
      let longitude = Double(firstLocationData!.longitude!)!
      let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
      let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
      _pinAnnotation(withMapItem: mapItem)
      let region = MKCoordinateRegion(center: mapItem.placemark.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
      _vMap.setRegion(region, animated: true)
    }
  }
  
  private func _pinAnnotation(withMapItem mapItem: MKMapItem) {
    let annotation = MKPointAnnotation()
    annotation.coordinate = mapItem.placemark.coordinate
    annotation.title = mapItem.placemark.name
    annotation.subtitle = mapItem.placemark.locality
    _vMap.addAnnotation(annotation)
  }
}

extension PinMapViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    let identifier = "AnnotationViewIdentifier"
    var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
    if annotationView == nil {
      annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
      annotationView?.isDraggable = true
    } else {
      annotationView?.annotation = annotation
    }
    return annotationView
  }
  
  func mapView(_ mapView: MKMapView, annotationView: MKAnnotationView, didChange state: MKAnnotationView.DragState, fromOldState: MKAnnotationView.DragState) {
    if state == .ending {
      if let annotation = annotationView.annotation {
        _editedLocationData.longitude = String(annotation.coordinate.longitude)
        _editedLocationData.latitude = String(annotation.coordinate.latitude)
        if _editedLocationData.isDifferent(from: firstLocationData) {
          _btnDone.isEnabled = true
        } else {
          _btnDone.isEnabled = false
        }
      }
      annotationView.dragState = .none
    }
  }
}
