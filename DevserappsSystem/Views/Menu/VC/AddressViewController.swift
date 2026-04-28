//
//  MenuViewController.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 02/03/2025.
//

import UIKit
import MapKit
import KRProgressHUD
import SwiftUI

@objc protocol AddressDelegate: NSObjectProtocol {
  @objc optional func addressViewController(addressVC: AddressViewController, didEditAddress editedAddressData: Address)
}

class AddressViewController: UITableViewController {
  var shouldSetupViews: Bool = true
  var shouldPopulateDataFromFirstAddress: Bool = true
  var shouldRefreshViews: Bool = false
  
  @IBOutlet weak var _btnDone: UIBarButtonItem!
  @IBOutlet weak var _lblName: UILabel!
  @IBOutlet weak var _lblPhoneNumber: UILabel!
  @IBOutlet weak var _txtProvinceOrCity: UITextField!
  @IBOutlet weak var _txtDistrict: UITextField!
  @IBOutlet weak var _txtWardOrCommune: UITextField!
  @IBOutlet weak var _txtSpecificAddress: UITextView!
  @IBOutlet weak var _vPinMapNotification: UIView!
  @IBOutlet weak var _vPinMap: MKMapView!
  @IBOutlet weak var _vPinMapCover: UIView!
  @IBOutlet weak var _btnAddLocation: UIButton!
  
  var delegate: AddressDelegate?
  var firstAddress: Address?
  
  private var _editedAddress: Address!
  private var _selectedIndexPath: IndexPath!
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let nameVC = segue.destination as? NameViewController {
      nameVC.delegate = self
      nameVC.firstName = Name(nameParam: _editedAddress.name)
    }
    
    if let phoneNumberVC = (segue.destination as? UINavigationController)?.viewControllers.first as? PhoneNumberVC {
      phoneNumberVC.delegate = self
      phoneNumberVC.firstPhoneNumber = PhoneNumber(phoneNumber: _editedAddress.phoneNumber)
    }
    
    if let pinMapVC = (segue.destination as? UINavigationController)?.viewControllers.first as? PinMapViewController {
      pinMapVC.delegate = self
      if segue.identifier == SegueID.EditMapPin.rawValue {
        pinMapVC.firstLocationData = Geopoint(geopointParam: _editedAddress.geopoint)
      }
    }
  }
    
  override func viewDidLoad() {
    super.viewDidLoad()
    if shouldPopulateDataFromFirstAddress {
      _populateDataFromFirstAddress()
      shouldPopulateDataFromFirstAddress = true
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if shouldSetupViews {
      _setupViews()
      shouldSetupViews = false
    }
    
    if shouldPopulateDataFromFirstAddress {
      _populateDataFromFirstAddress()
      shouldPopulateDataFromFirstAddress = false
    }
    
    if shouldRefreshViews {
      _refreshViews()
      shouldRefreshViews = false
    }
  }
  
  private func _setupViews() {
    _hideKeyboardWhenTappedAround()
    
    if firstAddress?.geopoint == nil {
      _vPinMapCover.isHidden = false
    }
  }
  
  private func _populateDataFromFirstAddress() {
    _editedAddress = Address(address: firstAddress)
    
    _lblName.text = firstAddress?.name?.fullName()
    _lblPhoneNumber.text = firstAddress?.phoneNumber?.number
    _txtProvinceOrCity.text = firstAddress?.provinceOrCity
    _txtDistrict.text = firstAddress?.district
    _txtWardOrCommune.text = firstAddress?.wardOrCommune
    _txtSpecificAddress.text = firstAddress?.specificAddress
    if let mapItem = firstAddress?.geopoint?.toMKMapItem() {
      _replaceExistedPinAnnotation(withMapItem: mapItem)
    } else if _shouldShowMapPinNotification() {
      _showMapPinNotification()
      _showPinMapCoverViewAndEnableAddLocationButton()
    }
  }
  
  private func _refreshViews() {
  }
  
  @IBAction func doneBtnTapped(_ sender: Any) {
    delegate?.addressViewController?(addressVC: self, didEditAddress: Address(address: _editedAddress))
    navigationController?.popViewController(animated: true)
  }
  
  private func _presentBasicAlert(title: String?, message: String?) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    self.present(alert, animated: true, completion: nil)
  }
  
  func searchLocation(keyword searchKey: String, completion handler: @escaping (MKMapItem?) -> Void) {
    let request = MKLocalSearch.Request()
    request.naturalLanguageQuery = searchKey
    let searchResult = MKLocalSearch(request: request)
    searchResult.start { response, _ in
      handler(response?.mapItems.first)
    }
  }
  
  private func _shouldShowMapPinNotification() -> Bool {
    if !_txtSpecificAddress.text.isEmpty && _editedAddress.wardOrCommune != nil {
      return true
    } else {
      return false
    }
  }
  
  @IBAction func backPinMap(_ segue: UIStoryboardSegue) {
  }
  
  @IBAction func donePinMap(_ segue: UIStoryboardSegue) {
  }
}

// MARK: - TableView

extension AddressViewController {
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    _selectedIndexPath = indexPath
    if indexPath.section == 1 {
      if indexPath.row == 1 && _editedAddress.provinceOrCity == nil {
        return
      }
      
      if indexPath.row == 2 && _editedAddress.district == nil {
        return
      }
      
      if AddressStore.shared.isEmpty() {
        let indicator = UIActivityIndicatorView()
        let provinceCell = self.tableView(self.tableView, cellForRowAt: indexPath)
        indicator.frame = CGRect(x: 5, y: 5, width: 24, height: 24)
        indicator.color = self.view.tintColor
        let indicatorContainer = UIView(frame: CGRect(x: 0, y: 0, width: 34, height: 34))
        indicatorContainer.addSubview(indicator)
        provinceCell.accessoryView = indicatorContainer
        indicator.startAnimating()
        AddressStore.shared.downloadAddresses { [weak self] error in
          indicator.stopAnimating()
          provinceCell.accessoryView = UIImageView(image: UIImage(systemName: "chevron.down"))
          if error != nil {
            self?._presentBasicAlert(title: "Error occurred", message: error?.localizedDescription)
          } else {
            self?._configureAndPopupSearchPopupVC(withDidSelectRowAt: indexPath.row)
          }
        }
      } else {
        _configureAndPopupSearchPopupVC(withDidSelectRowAt: indexPath.row)
      }
    }
  }
  
  private func _configureAndPopupSearchPopupVC(withDidSelectRowAt rowIndex: Int) {
    let searchPopupVC = StoryboardHelper.newSearchPopupVC()
    searchPopupVC.delegate = self
    if rowIndex == 0 {
      searchPopupVC.searchPlaceholder = _editedAddress.provinceOrCity ?? "Province/City"
      searchPopupVC.list = AddressStore.shared.provinces.compactMap { $0.fullName }
    } else if rowIndex == 1 {
      searchPopupVC.searchPlaceholder = _editedAddress.district ?? "District"
      let currentProvinceCode = AddressStore.shared.provinces.filter { $0.fullName == _editedAddress.provinceOrCity }.first?.code
      searchPopupVC.list = AddressStore.shared.districts.filter { $0.provinceCode == currentProvinceCode }.compactMap { $0.fullName }
    } else if rowIndex == 2 {
      searchPopupVC.searchPlaceholder = _editedAddress.wardOrCommune ?? "Ward/Commune"
      let currentDistrictCode = AddressStore.shared.districts.filter { $0.fullName == _editedAddress.district }.first?.code
      searchPopupVC.list = AddressStore.shared.wards.filter { $0.districtCode == currentDistrictCode }.compactMap { $0.fullName }
    }
    present(searchPopupVC, animated: true)
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.section == 3 {
      if _shouldShowMapPinNotification() {
        return 180
      } else {
        return 110
      }
    } else {
      return super.tableView(tableView, heightForRowAt: indexPath)
    }
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return super.tableView(tableView, numberOfRowsInSection: section)
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if (indexPath.section == 1) {
      let cell = super.tableView(tableView, cellForRowAt: indexPath)
      let accessoryView = UIImageView(image: UIImage(systemName: "chevron.down"))
      if indexPath.row == 1 && _editedAddress.provinceOrCity == nil {
        accessoryView.tintColor = .gray
      } else if indexPath.row == 2 && _editedAddress.district == nil {
        accessoryView.tintColor = .gray
      } else {
        accessoryView.tintColor = self.view.tintColor
      }
      cell.accessoryView = accessoryView
      return cell
    } else {
      return super.tableView(tableView, cellForRowAt: indexPath)
    }
  }
}

extension AddressViewController {
  private func _hideKeyboardWhenTappedAround() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(self._dismissKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }
  
  @objc private func _dismissKeyboard() {
    view.endEditing(true)
  }
}

// MARK: - UITextViewDelegate

extension AddressViewController: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    let text = textView.text!.isEmpty ? nil : textView.text
    
    _editedAddress.specificAddress = text
    _btnDone.isEnabled = _editedAddress.isDifferent(from: firstAddress)
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    if _shouldShowMapPinNotification() {
      _showMapPinNotification()
      KRProgressHUD.show()
      _searchLocation(withAddress: _editedAddress) { [weak self] mapItem, error in
        KRProgressHUD.dismiss()
        if error != nil {
          self?._showPinMapCoverViewAndEnableAddLocationButton()
          self?._editedAddress.geopoint = nil
          self?._removeExistedPinAnnotation()
        } else {
          self?._hidePinMapCoverViewAndDisableAddLocationButton()
          self?._editedAddress.geopoint = Geopoint(coordinate: mapItem!.placemark.coordinate)
          self?._replaceExistedPinAnnotation(withMapItem: mapItem!)
        }
      }
    } else {
      _hideMapPinNotification()
      _showPinMapCoverViewAndDisableAddLocationButton()
      _editedAddress.geopoint = nil
      _removeExistedPinAnnotation()
    }
    
    _btnDone.isEnabled = _editedAddress.isDifferent(from: firstAddress)
  }
  
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    if text != "\n" { return true }
    
    textView.resignFirstResponder()
    
    let text = textView.text!.isEmpty ? nil : textView.text
    
    if text == _editedAddress.specificAddress {
      return false
    }
    
    _editedAddress.specificAddress = text
    
    if _shouldShowMapPinNotification() {
      _showMapPinNotification()
      KRProgressHUD.show()
      _searchLocation(withAddress: _editedAddress) { [weak self] mapItem, error in
        KRProgressHUD.dismiss()
        if error != nil {
          self?._showPinMapCoverViewAndEnableAddLocationButton()
          self?._editedAddress.geopoint = nil
          self?._removeExistedPinAnnotation()
        } else {
          self?._hidePinMapCoverViewAndDisableAddLocationButton()
          self?._editedAddress.geopoint = Geopoint(coordinate: mapItem!.placemark.coordinate)
          self?._replaceExistedPinAnnotation(withMapItem: mapItem!)
        }
      }
    } else {
      _hideMapPinNotification()
      _showPinMapCoverViewAndDisableAddLocationButton()
      _editedAddress.geopoint = nil
      _removeExistedPinAnnotation()
    }
    
    if _editedAddress.isDifferent(from: firstAddress) {
      _btnDone.isEnabled = true
    } else {
      _btnDone.isEnabled = false
    }
    
    return false
  }
  
  private func _showPinMapCoverViewAndEnableAddLocationButton() {
    _vPinMapCover.isHidden = false
    _btnAddLocation.isEnabled = true
  }
  
  private func _showPinMapCoverViewAndDisableAddLocationButton() {
    _vPinMapCover.isHidden = false
    _btnAddLocation.isEnabled = false
  }
  
  private func _hidePinMapCoverViewAndDisableAddLocationButton() {
    _vPinMapCover.isHidden = true
    _btnAddLocation.isEnabled = false
  }
  
  private func _showMapPinNotification() {
    if _vPinMapNotification.frame.height == 0 {
      self.tableView.reloadSections(IndexSet(integer: 3), with: .none)
    }
  }
  
  private func _hideMapPinNotification() {
    if _vPinMapNotification.frame.height == 70 {
      self.tableView.reloadSections(IndexSet(integer: 3), with: .none)
    }
  }
  
  private func _searchLocation(withAddress address: Address, handler: @escaping (MKMapItem?, Error?) -> Void) {
    if let province = address.provinceOrCity,
       let district = address.district,
       let ward = address.wardOrCommune,
       let specificAddress = address.specificAddress {
      let keyword = [specificAddress, ward, district, province].joined(separator: ",")
      searchLocation(keyword: keyword) { mapItem in
        if mapItem != nil {
          handler(mapItem, nil)
        } else {
          handler(nil, NilFoundError)
        }
      }
    } else {
      handler(nil, NilFoundError)
    }
  }
}

// MARK: - SearchPopupDelegate

extension AddressViewController: SearchPopupDelegate {
  func searchPopupViewController(searchPopupVC: SearchPopupViewController, didSelectRow rowData: String) {
    if _selectedIndexPath.section == 1 && _selectedIndexPath.row == 0 {
      _txtProvinceOrCity.text = rowData
      _editedAddress.provinceOrCity = rowData
      _txtDistrict.text = ""
      _editedAddress.district = nil
      _txtWardOrCommune.text = ""
      _editedAddress.wardOrCommune = nil
    } else if _selectedIndexPath.section == 1 && _selectedIndexPath.row == 1 {
      _txtDistrict.text = rowData
      _editedAddress.district = rowData
      _txtWardOrCommune.text = ""
      _editedAddress.wardOrCommune = nil
    } else if _selectedIndexPath.section == 1 && _selectedIndexPath.row == 2 {
      _txtWardOrCommune.text = rowData
      _editedAddress.wardOrCommune = rowData
    }
    
    if _shouldShowMapPinNotification() {
      _showMapPinNotification()
      KRProgressHUD.show()
      _searchLocation(withAddress: _editedAddress) { [weak self] mapItem, error in
        KRProgressHUD.dismiss()
        if error != nil {
          self?._showPinMapCoverViewAndEnableAddLocationButton()
          self?._editedAddress.geopoint = nil
          self?._removeExistedPinAnnotation()
        } else {
          self?._hidePinMapCoverViewAndDisableAddLocationButton()
          self?._editedAddress.geopoint = Geopoint(coordinate: mapItem!.placemark.coordinate)
          self?._replaceExistedPinAnnotation(withMapItem: mapItem!)
        }
      }
    } else {
      _hideMapPinNotification()
      _showPinMapCoverViewAndDisableAddLocationButton()
      _editedAddress.geopoint = nil
      _removeExistedPinAnnotation()
    }
    
    if _editedAddress.isDifferent(from: firstAddress) {
      _btnDone.isEnabled = true
    } else {
      _btnDone.isEnabled = false
    }
    
    self.tableView.reloadSections(IndexSet(integer: 1), with: .none)
  }
}

// MARK: - PinMapDelegate

extension AddressViewController: PinMapDelegate {
  func pinMapViewController(pinMapVC: PinMapViewController, didEditLocation editedLocationData: Geopoint) {
    if let mapItem = editedLocationData.toMKMapItem() {
      _hidePinMapCoverViewAndDisableAddLocationButton()
      _replaceExistedPinAnnotation(withMapItem: mapItem)
      _editedAddress.geopoint = Geopoint(geopointParam: editedLocationData)
      _btnDone.isEnabled = _editedAddress.isDifferent(from: firstAddress)
    }
  }
  
  private func _replaceExistedPinAnnotation(withMapItem mapItem: MKMapItem) {
    _removeExistedPinAnnotation()
    _pinAnnotation(withMapItem: mapItem)
    let region = MKCoordinateRegion(center: mapItem.placemark.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
    _vPinMap.setRegion(region, animated: true)
  }
  
  private func _removeExistedPinAnnotation() {
    if let existedAnnotation = _vPinMap.annotations.first {
      _vPinMap.removeAnnotation(existedAnnotation)
    }
  }
  
  private func _pinAnnotation(withMapItem mapItem: MKMapItem) {
    let annotation = MKPointAnnotation()
    
    annotation.coordinate = mapItem.placemark.coordinate
    annotation.title = mapItem.placemark.name
    annotation.subtitle = mapItem.placemark.locality
    
    _vPinMap.addAnnotation(annotation)
  }
}

extension AddressViewController: NameDelegate {
  func nameViewController(nameVC: NameViewController, didEditName editedNameData: Name) {
    _editedAddress.name = Name(nameParam: editedNameData)
    _btnDone.isEnabled = editedNameData.isDifferent(from: firstAddress?.name)
    _lblName.text = editedNameData.fullName()
  }
}

extension AddressViewController: PhoneNumberDelegate {
  func phoneNumberVC(phoneNumberVC: PhoneNumberVC, didEditPhoneNumber editedPhoneNumber: PhoneNumber) {
    _editedAddress.phoneNumber = PhoneNumber(phoneNumber: editedPhoneNumber)
    _btnDone.isEnabled = editedPhoneNumber.isDifferent(from: firstAddress?.phoneNumber)
    _lblPhoneNumber.text = editedPhoneNumber.number
  }
}
