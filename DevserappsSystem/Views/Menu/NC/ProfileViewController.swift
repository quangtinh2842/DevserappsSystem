//
//  MenuViewController.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 02/03/2025.
//

import UIKit
import AlamofireImage
import KRProgressHUD

@objc protocol ProfileDelegate: NSObjectProtocol {
  @objc optional func profileViewController(profileVC: ProfileViewController, didEditProfile editedUser: MUser)
}

class ProfileViewController: UITableViewController {
  var shouldRefreshViews: Bool = false
  
  @IBOutlet weak var _btnBack: UIBarButtonItem!
  @IBOutlet weak var _btnSave: UIBarButtonItem!
  @IBOutlet weak var _vProfilePhotoEditing: UIView!
  @IBOutlet weak var _imgProfilePhoto: UIImageView!
  @IBOutlet weak var _txtDisplayName: UITextField!
  @IBOutlet weak var _txtRegisteredEmail: UITextField!
  @IBOutlet weak var _lblName: UILabel!
  @IBOutlet weak var _lblDateOfBirth: UILabel!
  @IBOutlet weak var _cellDateOfBirthPicker: UITableViewCell!
  @IBOutlet weak var _lblPhoneNumber: UILabel!
  @IBOutlet weak var _pkgDateOfBirthPicker: UIDatePicker!
  @IBOutlet weak var _lblAddress: UILabel!
  
  var delegate: ProfileDelegate?
  
  private var _savedUser: MUser!
  private var _editedUser: MUser!
  
  private var _shouldExtendDateOfBirthPickerCell = false
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let nameVC = segue.destination as? NameViewController {
      nameVC.delegate = self
      nameVC.firstName = Name(nameParam: _editedUser.name)
    }
    
    if let addressVC = segue.destination as? AddressViewController {
      addressVC.delegate = self
      addressVC.firstAddress = Address(address: _editedUser.address)
    }
    
    if let eraseVC = segue.destination as? EraseViewController {
      eraseVC.delegate = self
    }
    
    if let phoneNumberVC = (segue.destination as? UINavigationController)?.viewControllers.first as? PhoneNumberVC {
      phoneNumberVC.delegate = self
      phoneNumberVC.firstPhoneNumber = PhoneNumber(phoneNumber: _editedUser.phoneNumber)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    _setupViews()
    _populateCurrentUserData()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if shouldRefreshViews {
      _refreshViews()
      shouldRefreshViews = false
    }
  }
  
  private func _refreshViews() {
  }
  
  private func _setupViews() {
    _hideKeyboardWhenTappedAround()
    
    navigationController?.navigationBar.tintColor = .label
    
    let yourBackImage = UIImage(systemName: "arrow.backward")
    navigationController?.navigationBar.backIndicatorImage = yourBackImage
    navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
    
    _vProfilePhotoEditing.layer.cornerRadius = _vProfilePhotoEditing.layer.frame.width/2
  }
  
  private func _populateCurrentUserData() {
    _savedUser = MUser(user: UserStore.currentUser)
    _editedUser = MUser(user: UserStore.currentUser)
    
    if let photoURL = UserStore.currentUser.getPhotoURL {
      _imgProfilePhoto.af.setImage(withURL: photoURL)
    } else {
      _imgProfilePhoto.image = UIImage(systemName: "person.circle")
    }
    _txtDisplayName.text = UserStore.currentUser.displayName
    _txtRegisteredEmail.text = UserStore.currentUser.email
    _lblName.text = UserStore.currentUser.name?.fullName()
    
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy"
    let dateOfBirth = UserStore.currentUser.dateOfBirth ?? Date()
    _lblDateOfBirth.text = UserStore.currentUser.dateOfBirth == nil ? "" : formatter.string(from: dateOfBirth)
    _pkgDateOfBirthPicker.date = dateOfBirth
    
    _lblPhoneNumber.text = UserStore.currentUser.phoneNumber?.number
    
    _lblAddress.text = UserStore.currentUser.address?.regionAddress()
  }
  
  @IBAction func backBtnTapped(_ sender: Any) {
    if _editedUser.isDifferent(from: _savedUser) {
      let alert = UIAlertController(title: "Not saved yet", message: "Leave without saving?", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak self] _ in
        self?.dismiss(animated: true)
      }))
      alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
      present(alert, animated: true, completion: nil)
    } else {
      self.dismiss(animated: true)
    }
  }
  
  @IBAction func saveBtnTapped(_ sender: Any) {
    _saveProfile()
  }
  
  @IBAction func profilePhotoEditBtnTapped(_ sender: Any) {
    _presentProfilePhotoURLInputAlert()
  }
  
  @IBAction func dateOfBirthPickerValueChanged(_ sender: UIDatePicker) {
    if sender.date.isFuture() {
      sender.date = Date()
    } else {
      _lblDateOfBirth.text = sender.date.ddMMyyyy()
      _editedUser.dateOfBirth = _pkgDateOfBirthPicker.date
      _btnSave.isEnabled = _editedUser.dateOfBirth?.ddMMyyyy() != _savedUser.dateOfBirth?.ddMMyyyy()
    }
  }
  
  private func _saveProfile() {
    do {
      KRProgressHUD.show()
      try _tryToSaveEditedUser()
    } catch {
      KRProgressHUD.dismiss()
      _presentBasicAlert(title: "Error", message: error.localizedDescription)
    }
  }
  
  private func _tryToSaveEditedUser() throws {
    let _ = try _editedUser.save { [weak self] error, _ in
      KRProgressHUD.dismiss()
      if error != nil {
        self?._presentBasicAlert(title: "Error", message: error!.localizedDescription)
      } else {
        self?._didSaveProfileSuccessfullyHandler()
      }
    }
  }
  
  private func _didSaveProfileSuccessfullyHandler() {
    _savedUser = MUser(user: _editedUser)
    UserStore.currentUser = MUser(user: _savedUser)
    delegate?.profileViewController?(profileVC: self, didEditProfile: MUser(user: _editedUser))
    _btnSave.isEnabled = false
  }
  
  private func _presentBasicAlert(title: String?, message: String?) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    self.present(alert, animated: true, completion: nil)
  }
  
  private func _presentProfilePhotoURLInputAlert() {
    let alert = UIAlertController(title: "Edit photo URL", message: "Please type photo URL below:", preferredStyle: .alert)
    
    alert.addTextField { [weak self] textField in
      textField.placeholder = "https://www"
      textField.clearButtonMode = .whileEditing
      textField.text = self?._editedUser.photoURL
    }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    let saveAction = UIAlertAction(title: "Done", style: .default) { [weak self] _ in
      let photoURLString = alert.textFields?.first?.text ?? ""
      
      if let photoURL = URL(string: photoURLString) {
        self?._editedUser.photoURL = photoURLString
        self?._imgProfilePhoto.af.setImage(withURL: photoURL)
      } else {
        self?._editedUser.photoURL = nil
        self?._imgProfilePhoto.image = UIImage(systemName: "person.circle")
      }
      
      self?._btnSave.isEnabled = self?._editedUser.photoURL != self?._savedUser.photoURL
    }
    
    alert.addAction(cancelAction)
    alert.addAction(saveAction)
    
    self.present(alert, animated: true, completion: nil)
  }
  
  @IBAction func handleNameTxtChanged(_ sender: Any) {
    let text = _txtDisplayName.text!.isEmpty ? nil : _txtDisplayName.text
    
    _editedUser.displayName = text
    _btnSave.isEnabled = _editedUser.displayName != _savedUser.displayName
  }
}

// MARK: - TableView

extension ProfileViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 3 {
      return _shouldExtendDateOfBirthPickerCell ? 2 : 1
    } else {
      return super.tableView(tableView, numberOfRowsInSection: section)
    }
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.section == 3 && indexPath.row == 1 {
      return _heightForRow(at: indexPath)
    } else {
      return super.tableView(tableView, heightForRowAt: indexPath)
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == 3 && indexPath.row == 0 {
      _shouldExtendDateOfBirthPickerCell = !_shouldExtendDateOfBirthPickerCell
      tableView.reloadSections(IndexSet(integer: 3), with: .bottom)
      tableView.selectRow(at: IndexPath(row: 0, section: 1), animated: true, scrollPosition: .top)
    }
  }
  
  private func _heightForRow(at indexPath: IndexPath) -> CGFloat {
    let row = indexPath.row
    let section = indexPath.section
    
    if section == 3 && row == 1 {
      if _shouldExtendDateOfBirthPickerCell {
        return self.view.frame.width * 0.8
      } else {
        return 0
      }
    }
    
    return 0
  }
}

extension ProfileViewController {
  private func _hideKeyboardWhenTappedAround() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(self._dismissKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }
  
  @objc private func _dismissKeyboard() {
    view.endEditing(true)
  }
}

// MARK: - UITextFieldDelegate

extension ProfileViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    let text = textField.text!.isEmpty ? nil : textField.text
    
    _txtDisplayName.resignFirstResponder()
    _editedUser.displayName = text
    _btnSave.isEnabled = _editedUser.displayName != _savedUser.displayName
    return true
  }
}

// MARK: - NameDelegate

extension ProfileViewController: NameDelegate {
  func nameViewController(nameVC: NameViewController, didEditName editedNameData: Name) {
    do {
      _editedUser.name = Name(nameParam: editedNameData)
      KRProgressHUD.show()
      let _ = try _editedUser.save { [weak self] error, _ in
        KRProgressHUD.dismiss()
        if error != nil {
          self?._editedUser.name = Name(nameParam: self?._savedUser.name)
          self?._presentBasicAlert(title: "Error", message: error!.localizedDescription)
        } else {
          UserStore.currentUser.name = Name(nameParam: self?._editedUser.name)
          self?._savedUser.name = Name(nameParam: self?._editedUser.name)
          self?._lblName.text = self?._editedUser.name?.fullName()
        }
      }
    } catch {
      KRProgressHUD.dismiss()
      _editedUser.name = Name(nameParam: _savedUser.name)
      _presentBasicAlert(title: "Error", message: error.localizedDescription)
    }
  }
}

// MARK: - AddressDelegate

extension ProfileViewController: AddressDelegate {
  func addressViewController(addressVC: AddressViewController, didEditAddress editedAddressData: Address) {
    do {
      _editedUser.address = Address(address: editedAddressData)
      KRProgressHUD.show()
      let _ = try _editedUser.save { [weak self] error, _ in
        KRProgressHUD.dismiss()
        if error != nil {
          self?._editedUser.address = Address(address: self?._savedUser.address)
          self?._presentBasicAlert(title: "Error", message: error!.localizedDescription)
        } else {
          UserStore.currentUser.address = Address(address: self?._editedUser.address)
          self?._savedUser.address = Address(address: self?._editedUser.address)
          self?._lblAddress.text = self?._editedUser.address?.regionAddress()
        }
      }
    } catch {
      KRProgressHUD.dismiss()
      _editedUser.address = Address(address: _savedUser.address)
      _presentBasicAlert(title: "Error", message: error.localizedDescription)
    }
  }
}

// MARK: - EraseDelegate

extension ProfileViewController: EraseDelegate {
  func eraseViewController(eraseVC: EraseViewController, didEraseData newUserData: MUser) {
    _savedUser = MUser(user: newUserData)
    
    if newUserData.photoURL == nil {
      _editedUser.photoURL = nil
      _imgProfilePhoto.image = UIImage(systemName: "person.circle")
    }
    
    if newUserData.displayName == nil {
      _editedUser.displayName = nil
      _txtDisplayName.text = nil
    }
    
    if newUserData.name == nil {
      _editedUser.name = nil
      _lblName.text = nil
    }
    
    if newUserData.dateOfBirth == nil {
      _editedUser.dateOfBirth = nil
      _lblDateOfBirth.text = nil
      _pkgDateOfBirthPicker.date = Date()
    }
    
    if newUserData.phoneNumber == nil {
      _editedUser.phoneNumber = nil
      _lblPhoneNumber.text = nil
    }
    
    if newUserData.address == nil {
      _editedUser.address = nil
      _lblAddress.text = nil
    }
  }
}

// MARK: - PhoneNumberDelegate

extension ProfileViewController: PhoneNumberDelegate {
  func phoneNumberVC(phoneNumberVC: PhoneNumberVC, didEditPhoneNumber editedPhoneNumber: PhoneNumber) {
    do {
      _editedUser.phoneNumber = PhoneNumber(phoneNumber: editedPhoneNumber)
      KRProgressHUD.show()
      let _ = try _editedUser.save { [weak self] error, _ in
        KRProgressHUD.dismiss()
        if error != nil {
          self?._editedUser.phoneNumber = PhoneNumber(phoneNumber: self?._savedUser.phoneNumber)
          self?._presentBasicAlert(title: "Error", message: error!.localizedDescription)
        } else {
          UserStore.currentUser.phoneNumber = PhoneNumber(phoneNumber: self?._editedUser.phoneNumber)
          self?._savedUser.phoneNumber = PhoneNumber(phoneNumber: self?._editedUser.phoneNumber)
          self?._lblPhoneNumber.text = self?._editedUser.phoneNumber?.number
        }
      }
    } catch {
      KRProgressHUD.dismiss()
      _editedUser.phoneNumber = PhoneNumber(phoneNumber: _savedUser.phoneNumber)
      _presentBasicAlert(title: "Error", message: error.localizedDescription)
    }
  }
}
