//
//  SensorCell.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 14/03/2025.
//

import UIKit
import AlamofireImage

class SensorCell: UICollectionViewCell {
  @IBOutlet weak var _vContainer: UIView!
  @IBOutlet weak var _imgSymbol: UIImageView!
  @IBOutlet weak var _lblTitle: UILabel!
  @IBOutlet weak var _lblValue: UILabel!
  
  private var _sensorData: Sensor!
  
  func setupCellView() {
    _vContainer.layer.cornerRadius = 16
  }
  
  func updateCell(withData sensor: Sensor) {
    _sensorData = sensor
    
    if let symbolURL = sensor.getSymbolURL {
      _imgSymbol.af.setImage(withURL: symbolURL)
    } else {
      _imgSymbol.image = UIImage(named: "Placeholder Image")
    }
    
    _lblTitle.text = sensor.title
    _lblValue.text = (sensor.value ?? "") + (sensor.unit ?? "")
  }
}
