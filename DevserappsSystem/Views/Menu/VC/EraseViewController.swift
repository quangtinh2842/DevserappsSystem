//
//  EraseViewController.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 16/03/2025.
//

import UIKit

@objc protocol EraseDelegate: NSObjectProtocol {
  @objc optional func eraseViewController(eraseVC: EraseViewController, didEraseData newUserData: MUser)
}

class EraseViewController: UITableViewController {
  var shouldRefreshViews: Bool = false
  
  @IBOutlet weak var _txtEraseDataList: UITextView!
  
  var delegate: EraseDelegate?
  
  private var _list: [ErasedInformation] = [
    .init(name: "Photo URL"),
    .init(name: "Display name"),
    .init(name: "Name"),
    .init(name: "Date of birth"),
    .init(name: "Phone number"),
    .init(name: "Address")
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    _setupViews()
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
    _txtEraseDataList.text = _list.filter { $0.isSelected }.map{ "• "+$0.name! }.joined(separator: "\n")
  }
  
  @IBAction func eraseBtnTapped(_ sender: Any) {
    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let deleteAction = UIAlertAction(title: "Erase", style: .destructive) { [weak self] _ in
      for information in self?._list ?? [] {
        if information.isSelected {
          switch information.name {
          case "Photo URL": UserStore.currentUser.photoURL = nil
          case "Display name": UserStore.currentUser.displayName = nil
          case "Name": UserStore.currentUser.name = nil
          case "Date of birth": UserStore.currentUser.dateOfBirth = nil
          case "Phone number": UserStore.currentUser.phoneNumber = nil
          case "Address": UserStore.currentUser.address = nil
          default: continue
          }
        }
      }
      do {
        try self?._tryToSaveChanges()
      } catch {
        self?._presentBasicAlert(title: "Error", message: error.localizedDescription)
      }
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    alertController.addAction(deleteAction)
    alertController.addAction(cancelAction)
    present(alertController, animated: true)
  }
  
  private func _tryToSaveChanges() throws {
    let _ = try UserStore.currentUser.save { [weak self] error, _ in
      if error != nil {
        self?._presentBasicAlert(title: "Error", message: error!.localizedDescription)
      } else {
        for information in self?._list ?? [] {
          information.isSelected = false
          self?._txtEraseDataList.text = nil
        }
        self?._presentBasicAlert(title: "Erased successfully!", message: nil)
        if self != nil {
          self?.delegate?.eraseViewController?(eraseVC: self!, didEraseData: MUser(user: UserStore.currentUser))
        }
      }
    }
  }
  
  private func _presentBasicAlert(title: String?, message: String?) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    self.present(alert, animated: true, completion: nil)
  }
  
  @IBAction func handleErasedDataListTapped(_ sender: Any) {
    let vc = StoryboardHelper.newErasedListPopupVC()
    vc.list = _list
    vc.delegate = self
    self.present(vc, animated: true)
  }
}

extension EraseViewController: ErasedListPopupDelegate {
  func erasedListPopupVC(erasedListPopupVC: ErasedListPopupVC, updatedList: [ErasedInformation]) {
    _list = updatedList
    _txtEraseDataList.text = _list.filter { $0.isSelected }.map{ "• "+$0.name! }.joined(separator: "\n")
  }
}
