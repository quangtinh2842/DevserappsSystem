//
//  ProblemToProviderVC.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 05/04/2025.
//

import UIKit

@objc protocol ProblemToProviderDelegate: NSObjectProtocol {
  @objc optional func problemToProviderVC(problemToProviderVC: ProblemToProviderVC, didSendProblem sentProblem: Problem)
}

class ProblemToProviderVC: UITableViewController {
  var shouldSetupViews = true
  var shouldPopulateDataFromProblem = true
  var shouldRefreshViews = false
  
  @IBOutlet weak var _txtTitle: UITextField!
  @IBOutlet weak var _txtContent: UITextView!
  @IBOutlet weak var _btnSend: UIButton!
  
  var delegate: ProblemToProviderDelegate?
  var firstProblem: Problem?
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if shouldSetupViews {
      _setupViews()
      shouldSetupViews = false
    }
    
    if shouldPopulateDataFromProblem {
      _populateDataFromProblem()
      shouldPopulateDataFromProblem = false
    }
    
    if shouldRefreshViews {
      _refreshViews()
      shouldRefreshViews = false
    }
  }
  
  private func _setupViews() {
    if firstProblem == nil {
      _hideKeyboardWhenTappedAround()
    } else {
      _txtTitle.isEnabled = false
      _txtContent.isEditable = false
    }
  }
  
  private func _populateDataFromProblem() {
    _txtTitle.text = firstProblem?.title
    _txtContent.text = firstProblem?.content
  }
  
  private func _refreshViews() {
  }
  
  @IBAction func handleXMarkBtnTapped(_ sender: Any) {
    self.dismiss(animated: true)
  }
  
  @IBAction func handleTitleTxtChanged(_ sender: Any) {
    _btnSend.isEnabled = _txtContent.text != "" && _txtTitle.text != ""
  }
  
  @IBAction func handleSendBtnTapped(_ sender: Any) {
    let newProblem = Problem(problem: nil)
    
    newProblem.title = _txtTitle.text
    newProblem.content = _txtContent.text
    newProblem.time = Date()
    
    if title == "New app feedback" {
      newProblem.subject = "App feedbacks"
      SettingsStore.currentSettings.appFeedbacks.append(newProblem)
    } else if title == "New bug report" {
      newProblem.subject = "Bug reports"
      SettingsStore.currentSettings.bugReports.append(newProblem)
    } else if title == "New help & support request" {
      newProblem.subject = "Help & Support requests"
      SettingsStore.currentSettings.helpAndSupportRequests.append(newProblem)
    }
    
    do {
      let _ = try SettingsStore.currentSettings.save { [weak self] error, _ in
        if error != nil {
          if self?.title == "New app feedback" {
            SettingsStore.currentSettings.appFeedbacks.removeLast()
          } else if self?.title == "New bug report" {
            SettingsStore.currentSettings.bugReports.removeLast()
          } else if self?.title == "New help & support request" {
            SettingsStore.currentSettings.helpAndSupportRequests.removeLast()
          }
          self?._presentBasicAlert(title: "Error", message: error?.localizedDescription)
        } else {
          var problem: Problem!
          if self?.title == "New app feedback" {
            problem = SettingsStore.currentSettings.appFeedbacks.first
          } else if self?.title == "New bug report" {
            problem = SettingsStore.currentSettings.bugReports.first
          } else if self?.title == "New help & support request" {
            problem = SettingsStore.currentSettings.helpAndSupportRequests.first
          }
          if self != nil {
            self?.delegate?.problemToProviderVC?(problemToProviderVC: self!, didSendProblem: problem)
            self?.dismiss(animated: true)
          }
        }
      }
    } catch {
      if title == "New app feedback" {
        SettingsStore.currentSettings.appFeedbacks.removeLast()
      } else if title == "New bug report" {
        SettingsStore.currentSettings.bugReports.removeLast()
      } else if title == "New help & support request" {
        SettingsStore.currentSettings.helpAndSupportRequests.removeLast()
      }
      _presentBasicAlert(title: "Error", message: error.localizedDescription)
    }
  }
  
  private func _presentBasicAlert(title: String?, message: String?) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    self.present(alert, animated: true, completion: nil)
  }
}

extension ProblemToProviderVC {
  private func _hideKeyboardWhenTappedAround() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(self._dismissKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }
  
  @objc private func _dismissKeyboard() {
    view.endEditing(true)
  }
}

extension ProblemToProviderVC: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField === _txtTitle {
      _txtContent.becomeFirstResponder()
    }
    return true
  }
}

extension ProblemToProviderVC: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    _btnSend.isEnabled = _txtContent.text != "" && _txtTitle.text != ""
  }
}

extension ProblemToProviderVC {
  override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    if section == 1 {
      return firstProblem?.time?.ddMMyyyy()
    } else {
      return super.tableView(tableView, titleForFooterInSection: section)
    }
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 2 {
      if firstProblem == nil {
        return 1
      } else {
        return 0
      }
    } else {
      return super.tableView(tableView, numberOfRowsInSection: section)
    }
  }
}
