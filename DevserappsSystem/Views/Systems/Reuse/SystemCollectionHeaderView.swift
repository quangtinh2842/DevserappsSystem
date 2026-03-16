//
//  SystemCollectionHeaderView.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 14/03/2025.
//

import UIKit

class SystemCollectionHeaderView: UICollectionReusableView {
  @IBOutlet weak var _lblTitle: UILabel!
  
  private var _rightBtnAct: (() -> Void)?
  
  func updateView(with title: String?, rightBtnAct: (() -> Void)?) {
    _lblTitle.text = title
    _rightBtnAct = rightBtnAct
  }
  
  @IBAction func rightBtnTapped(_ sender: Any) {
    if _rightBtnAct != nil {
      _rightBtnAct!()
    }
  }
}
