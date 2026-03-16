//
//  PhoneNumberVC.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 26/03/2025.
//

import UIKit
import KRProgressHUD

@objc protocol PhoneNumberDelegate: NSObjectProtocol {
  @objc optional func phoneNumberVC(phoneNumberVC: PhoneNumberVC, didEditPhoneNumber editedPhoneNumber: PhoneNumber)
}

class PhoneNumberVC: UITableViewController {
  var shouldSetupViews = true
  var shouldPopulateDataFromFirstPhoneNumber = true
  var shouldRefreshViews = false
  
  @IBOutlet weak var _btnDone: UIBarButtonItem!
  @IBOutlet weak var _lblDialCodeAndCountryName: UILabel!
  @IBOutlet weak var _txtPhoneNumber: UITextField!
  
  var delegate: PhoneNumberDelegate?
  var firstPhoneNumber: PhoneNumber?
  
  private var _editedPhoneNumber: PhoneNumber!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if shouldPopulateDataFromFirstPhoneNumber {
      _populateDataFromFirstPhoneNumber()
      shouldPopulateDataFromFirstPhoneNumber = false
    }
  }
  
  private func _populateDataFromFirstPhoneNumber() {
    _editedPhoneNumber = PhoneNumber(phoneNumber: firstPhoneNumber)
    
    let dialCode = _editedPhoneNumber?.countryCode?.dialCode ?? ""
    let countryName = _editedPhoneNumber?.countryCode?.name ?? ""
    
    if dialCode.isEmpty && countryName.isEmpty {
      _lblDialCodeAndCountryName.text = "Country"
    } else {
      _lblDialCodeAndCountryName.text = dialCode+" ("+countryName+")"
    }
    
    _txtPhoneNumber.text = _editedPhoneNumber?.number
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if shouldSetupViews {
      _setupViews()
      shouldSetupViews = false
    }
    
    if shouldPopulateDataFromFirstPhoneNumber {
      _populateDataFromFirstPhoneNumber()
      shouldPopulateDataFromFirstPhoneNumber = false
    }
    
    if shouldRefreshViews {
      _refreshViews()
      shouldRefreshViews = false
    }
  }
  
  private func _refreshViews() {
  }
  
  private func _setupViews() {
    navigationController?.navigationBar.tintColor = .label
    let yourBackImage = UIImage(systemName: "arrow.backward")
    navigationController?.navigationBar.backIndicatorImage = yourBackImage
    navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
    
    _hideKeyboardWhenTappedAround()
  }
  
  @IBAction func handleXMarkBtnTapped(_ sender: Any) {
    self.dismiss(animated: true)
  }
  
  @IBAction func handleDoneBtnTapped(_ sender: Any) {
    delegate?.phoneNumberVC?(phoneNumberVC: self, didEditPhoneNumber: PhoneNumber(phoneNumber: _editedPhoneNumber))
    self.dismiss(animated: true)
  }
  
  private func _presentBasicAlert(title: String?, message: String?) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    self.present(alert, animated: true, completion: nil)
  }
  
  @IBAction func handlePhoneNumberTxtChanged(_ sender: Any) {
    let text = _txtPhoneNumber.text!.isEmpty ? nil : _txtPhoneNumber.text
    
    _editedPhoneNumber.number = text
    _btnDone.isEnabled = _editedPhoneNumber.isDifferent(from: firstPhoneNumber)
  }
}

extension PhoneNumberVC {
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section != 0 || indexPath.row != 0 {
      return
    }
    
    if CountryCodeStore.shared.all.isEmpty {
      let cell = self.tableView(self.tableView, cellForRowAt: indexPath)
      let preAccessoryView = cell.accessoryView
      
      let indicator = UIActivityIndicatorView()
      indicator.frame = CGRect(x: 26, y: 13, width: 24, height: 24)
      indicator.color = .gray
      let indicatorContainer = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
      indicatorContainer.addSubview(indicator)
      cell.accessoryView = indicatorContainer
      indicator.startAnimating()
      
      CountryCodeStore.shared.downloadCountryCodes { [weak self] error in
        indicator.stopAnimating()
        cell.accessoryView = preAccessoryView
        
        if error != nil {
          self?._presentBasicAlert(title: "Error occurred", message: error!.localizedDescription)
        } else {
          let countryCodeVC = StoryboardHelper.newCountryCodesVC()
          countryCodeVC.delegate = self
          self?.navigationController?.pushViewController(countryCodeVC, animated: true)
        }
      }
    } else {
      let countryCodeVC = StoryboardHelper.newCountryCodesVC()
      countryCodeVC.delegate = self
      self.navigationController?.pushViewController(countryCodeVC, animated: true)
    }
  }
}

extension PhoneNumberVC: UITextFieldDelegate {
  func textFieldDidEndEditing(_ textField: UITextField) {
    
  }
}

extension PhoneNumberVC {
  private func _hideKeyboardWhenTappedAround() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(self._dismissKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }
  
  @objc private func _dismissKeyboard() {
    view.endEditing(true)
  }
}

extension PhoneNumberVC: CountryCodesDelegate {
  func countryCodesVC(countryCodesVC: CountryCodesVC, didSelectCountry selectedCountry: CountryCode) {
    
    if selectedCountry.isDifferent(from: firstPhoneNumber?.countryCode) {
      _editedPhoneNumber.countryCode = CountryCode(countryCode: selectedCountry)
      
      let dialCode = _editedPhoneNumber.countryCode?.dialCode ?? ""
      let countryName = _editedPhoneNumber.countryCode?.name ?? ""
      
      if dialCode.isEmpty && countryName.isEmpty {
        _lblDialCodeAndCountryName.text = "Country"
      } else {
        _lblDialCodeAndCountryName.text = dialCode+" ("+countryName+")"
      }
      
      _btnDone.isEnabled = _editedPhoneNumber.isDifferent(from: firstPhoneNumber)
    } else {
      _editedPhoneNumber.countryCode = CountryCode(countryCode: firstPhoneNumber?.countryCode)
      
      let dialCode = _editedPhoneNumber.countryCode?.dialCode ?? ""
      let countryName = _editedPhoneNumber.countryCode?.name ?? ""
      
      if dialCode.isEmpty && countryName.isEmpty {
        _lblDialCodeAndCountryName.text = "Country"
      } else {
        _lblDialCodeAndCountryName.text = dialCode+" ("+countryName+")"
      }
      
      _btnDone.isEnabled = _editedPhoneNumber.isDifferent(from: firstPhoneNumber)
    }
  }
}
