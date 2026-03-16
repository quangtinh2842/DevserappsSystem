//
//  CountryCodeCell.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 26/03/2025.
//

import UIKit

class CountryCodeCell: UITableViewCell {
  @IBOutlet weak var _lblNameAndCode: UILabel!
  @IBOutlet weak var _lblDialCode: UILabel!
  
  func updateViews(with data: CountryCode) {
    _lblNameAndCode.text = data.name!+" ("+data.code!+")"
    _lblDialCode.text = data.dialCode!
  }
}
