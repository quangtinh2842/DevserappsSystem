//
//  SensorCell.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 14/03/2025.
//

import UIKit
import AlamofireImage

class ControlCell: UICollectionViewCell {
  @IBOutlet weak var _vContainer: UIView!
  @IBOutlet weak var _imgSymbol: UIImageView!
  @IBOutlet weak var _lblTitle: UILabel!
  @IBOutlet weak var _lblValue: UILabel!
  @IBOutlet weak var _vControlContainer: UIView!
  
  
  private var _controlData: Control!
  
  func setupCellView() {
    _vContainer.layer.cornerRadius = 16
    _vControlContainer.layer.cornerRadius = 8
  }
  
  func updateCell(withData control: Control) {
  }
}
