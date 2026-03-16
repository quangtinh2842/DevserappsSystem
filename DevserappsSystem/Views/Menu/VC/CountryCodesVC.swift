//
//  CountryCodesVC.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 26/03/2025.
//

import UIKit

@objc protocol CountryCodesDelegate: NSObjectProtocol {
  @objc optional func countryCodesVC(countryCodesVC: CountryCodesVC, didSelectCountry selectedCountry: CountryCode)
}

class CountryCodesVC: UITableViewController {
  var shouldRefreshViews = false
  var shouldSetupViews = true
  
  var delegate: CountryCodesDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if shouldRefreshViews {
      _refreshViews()
      shouldRefreshViews = false
    }
    
    if shouldSetupViews {
      _setupViews()
      shouldSetupViews = false
    }
  }
  
  private func _refreshViews() {
  }
  
  private func _setupViews() {
  }
}

extension CountryCodesVC {
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return CountryCodeStore.shared.all.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ReuseID.CountryCodeCell.rawValue) as! CountryCodeCell
    let countryCode = CountryCodeStore.shared.all[indexPath.row]
    cell.updateViews(with: countryCode)
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if delegate != nil && delegate!.responds(to: #selector(CountryCodesDelegate.countryCodesVC(countryCodesVC:didSelectCountry:))) {
      let countryCode = CountryCodeStore.shared.all[indexPath.row]
      delegate?.countryCodesVC?(countryCodesVC: self, didSelectCountry: countryCode)
      self.navigationController?.popViewController(animated: true)
    }
  }
}
