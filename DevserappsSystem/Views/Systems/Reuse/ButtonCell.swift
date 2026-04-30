//
//  SensorCell.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 14/03/2025.
//

import UIKit
import AlamofireImage

class ButtonCell: UICollectionViewCell {
  @IBOutlet weak var _vContainer: UIView!
  @IBOutlet weak var _btnButton: UIButton!
  
  func setupCellView() {
    _btnButton.layer.cornerRadius = _btnButton.frame.width/2
  }
  
  func updateCell(WithTitle title: String, state isOn: Bool) {
    _btnButton.setAttributedTitle(.init(string: title), for: .normal)
    _btnButton.isEnabled = isOn
  }
}
