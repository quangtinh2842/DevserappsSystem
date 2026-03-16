//
//  ProblemToProviderCell.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 05/04/2025.
//

import UIKit

class ProblemToProviderCell: UITableViewCell {
  @IBOutlet weak var _lblTitle: UILabel!
  @IBOutlet weak var _lblTime: UILabel!
  
  func updateViews(with data: Problem) {
    _lblTitle.text = data.title
    _lblTime.text = data.time?.ddMMyyyy()
  }
}
