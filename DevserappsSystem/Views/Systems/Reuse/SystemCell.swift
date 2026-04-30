//
//  SystemTableViewCell.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 13/03/2025.
//

import UIKit
import AlamofireImage

class SystemCell: UITableViewCell {
  @IBOutlet weak var _vContainer: UIView!
  @IBOutlet weak var _imgPhoto: UIImageView!
  @IBOutlet weak var _lblDisplayName: UILabel!
  @IBOutlet weak var _btnOn: UIButton!
  @IBOutlet weak var _btnOff: UIButton!
  
  private var _systemData: MSystem!
  
  func setupCellView() {
    _vContainer.layer.cornerRadius = 16
    _btnOn.layer.cornerRadius = _btnOn.frame.width/2
    _btnOff.layer.cornerRadius = _btnOff.frame.width/2
  }
  
  func updateCell(withData system: MSystem) {
    _systemData = system
    
    if let photoURL = system.getPhotoURL {
      _imgPhoto.af.setImage(withURL: photoURL)
    } else {
      _imgPhoto.image = UIImage.init()
    }
    _lblDisplayName.text = system.displayName
  }
  
  @IBAction func onBtnTapped(_ sender: Any) {
  }
  
  @IBAction func offBtnTapped(_ sender: Any) {
  }
}
