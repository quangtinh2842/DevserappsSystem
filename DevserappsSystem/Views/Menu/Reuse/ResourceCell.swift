//
//  ResourceCellID.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 03/04/2025.
//

import UIKit

class ResourceCell: UITableViewCell {
  @IBOutlet weak var _lblName: UILabel!
  
  func updateViews(with data: Resource) {
    _lblName.text = data.name
  }
}
