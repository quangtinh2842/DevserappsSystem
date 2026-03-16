//
//  MenuViewController.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 02/03/2025.
//

import UIKit
import KRProgressHUD

@objc protocol NameDelegate: NSObjectProtocol {
  @objc optional func nameViewController(nameVC: NameViewController, didEditName editedName: Name)
}

class NameViewController: UITableViewController {
  var shouldSetupViews = true
  var shouldPopulateDataFromFirstName = true
  var shouldRefreshViews = false
  
  @IBOutlet weak var _btnDone: UIBarButtonItem!
  @IBOutlet weak var _txtLast: UITextField!
  @IBOutlet weak var _txtMiddle: UITextField!
  @IBOutlet weak var _txtFirst: UITextField!
  
  var delegate: NameDelegate?
  var firstName: Name?
  
  private var _editedName: Name!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if shouldPopulateDataFromFirstName {
      _populateDataFromFirstAddress()
      shouldPopulateDataFromFirstName = false
    }
  }
  
  private func _populateDataFromFirstAddress() {
    _editedName = Name(nameParam: firstName)
    
    _txtLast.text = _editedName.last
    _txtMiddle.text = _editedName.middle
    _txtFirst.text = _editedName.first
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if shouldSetupViews {
      _setupViews()
      shouldSetupViews = false
    }
    
    if shouldPopulateDataFromFirstName {
      _populateDataFromFirstAddress()
      shouldPopulateDataFromFirstName = false
    }
    
    if shouldRefreshViews {
      _refreshViews()
      shouldRefreshViews = false
    }
  }
  
  private func _refreshViews() {
  }
  
  private func _setupViews() {
    _hideKeyboardWhenTappedAround()
  }
  
  @IBAction func doneBtnTapped(_ sender: Any) {
    delegate?.nameViewController?(nameVC: self, didEditName: Name(nameParam: _editedName))
    navigationController?.popViewController(animated: true)
  }
  
  @IBAction func handleTxtChannged(_ sender: UITextField) {
    let text = sender.text!.isEmpty ? nil : sender.text
    
    if sender.tag == 0 {
      _editedName.last = text
    } else if sender.tag == 1 {
      _editedName.middle = text
    } else if sender.tag == 2 {
      _editedName.first = text
    }
    
    _btnDone.isEnabled = _editedName.isDifferent(from: firstName)
  }
}

extension NameViewController {
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
extension NameViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    let text = textField.text!.isEmpty ? nil : textField.text
    
    if _txtLast === textField {
      _editedName.last = text
      _txtMiddle.becomeFirstResponder()
    } else if _txtMiddle === textField {
      _editedName.middle = text
      _txtFirst.becomeFirstResponder()
    } else if _txtFirst === textField {
      _editedName.first = text
      _txtFirst.resignFirstResponder()
    }
    
    _btnDone.isEnabled = _editedName.isDifferent(from: firstName)
    
    return true
  }
}
