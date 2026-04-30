//
//  SyncVC.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 31/03/2025.
//

import UIKit
import KRProgressHUD

@objc protocol SyncDelegate: NSObjectProtocol {
  @objc optional func syncVC(syncVC: SyncVC, didEditSync synced: Sync)
}

class SyncVC: UITableViewController {
  var shouldSetupViews = true
  var shouldPopulateDataFromSync = true
  var shouldRefreshViews = false
  
  @IBOutlet weak var _lblLastSync: UILabel!
  @IBOutlet var _btnTicks: [UIButton]!
  @IBOutlet weak var _btnSync: UIButton!
  
  var delegate: SyncDelegate?
  var sync: Sync?
  
  private var _ticks = [true]
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if shouldSetupViews {
      _setupViews()
      shouldSetupViews = false
    }
    
    if shouldPopulateDataFromSync {
      _populateDataFromSync()
      shouldPopulateDataFromSync = false
    }
    
    if shouldRefreshViews {
      _refreshViews()
      shouldRefreshViews = false
    }
  }
  
  private func _refreshViews() {
  }
  
  private func _setupViews() {
  }
  
  private func _populateDataFromSync() {
    if let lastSync = sync?.last() {
      _lblLastSync.text = lastSync.ddMMyyyy()+", "+lastSync.hhmm()
    }
  }
  
  @IBAction func handleXMarkBtnTapped(_ sender: Any) {
    self.dismiss(animated: true)
  }
  
  @IBAction func handleTickBtnTapped(_ sender: UIButton) {
    if _ticks[sender.tag] {
      sender.setImage(UIImage(systemName: "square"), for: .normal)
    } else {
      sender.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
    }
    _ticks[sender.tag] = !_ticks[sender.tag]
    _btnSync.isEnabled = _ticks.reduce(false) { $0 || $1 }
  }
  
  @IBAction func handleSyncBtnTapped(_ sender: Any) {
    do {
      SettingsStore.currentSettings.sync = sync
      SettingsStore.currentSettings.sync?.settings.append(Date())
      KRProgressHUD.show()
      let _ = try SettingsStore.currentSettings.save { [weak self] error, _ in
        KRProgressHUD.dismiss()
        if error != nil {
          SettingsStore.currentSettings.sync?.settings.removeLast()
          self?._presentBasicAlert(title: "Error", message: error!.localizedDescription)
        } else {
          self?.sync = Sync(sync: SettingsStore.currentSettings.sync)
          if let lastSync = self?.sync?.last() {
            self?._lblLastSync.text = lastSync.ddMMyyyy()+", "+lastSync.hhmm()
          }
          if self != nil {
            self?.delegate?.syncVC?(syncVC: self!, didEditSync: Sync(sync: self?.sync))
            self!.tableView.reloadSections(IndexSet(integer: 0), with: .none)
          }
        }
      }
    } catch {
      KRProgressHUD.dismiss()
      SettingsStore.currentSettings.sync?.settings.removeLast()
      _presentBasicAlert(title: "Error", message: error.localizedDescription)
    }
  }
  
  private func _presentBasicAlert(title: String?, message: String?) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    self.present(alert, animated: true, completion: nil)
  }
}

extension SyncVC {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 && sync?.last() == nil {
      return 0
    } else {
      return super.tableView(tableView, numberOfRowsInSection: section)
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == 1 && indexPath.row == 0 {
      if let btn = _btnTicks.filter({ $0.tag == 0 }).first {
        if _ticks[0] {
          btn.setImage(UIImage(systemName: "square"), for: .normal)
        } else {
          btn.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
        }
      }
      _ticks[0] = !_ticks[0]
      _btnSync.isEnabled = _ticks.reduce(false) { $0 || $1 }
    }
  }
}
