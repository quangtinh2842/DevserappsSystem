//
//  SensorCell.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 14/03/2025.
//

import UIKit
import AlamofireImage

class ContextCell: UICollectionViewCell {
  @IBOutlet weak var _vContainer: UIView!
  @IBOutlet weak var _imgSymbol: UIImageView!
  @IBOutlet weak var _lblTitle: UILabel!
  
  private var _contextData: Context!
  
  var stringContent: String! // need to remove
  
  func setupCellView() {
    
    _lblTitle.text = stringContent
    
    _vContainer.layer.cornerRadius = 16
  }
  
  func updateCell(withData context: Context) {
    _contextData = context
    
    if let symbolURL = context.getSymbolURL {
      _imgSymbol.af.setImage(withURL: symbolURL)
    } else {
      _imgSymbol.image = UIImage(named: "Placeholder Image")
    }
    
    _lblTitle.text = context.title
  }
}
