//
//  NotificationCell.swift
//  DevserappsSystem
//
//  Created by Soren Inis Ngo on 08/04/2026.
//

import UIKit
import AlamofireImage

class NotificationCell: UITableViewCell {
  @IBOutlet weak var _imgIcon: UIImageView!
  @IBOutlet weak var _lblTitle: UILabel!
  @IBOutlet weak var _lblContent: UILabel!
  @IBOutlet weak var _lblTime: UILabel!
  @IBOutlet weak var _lblWasRead: UILabel!
  
//  private var _notification: MNotification!
  
  func setupCell(with data: MNotification) {
//    _notification = data
    
    _imgIcon.af.setImage(withURL: URL(string: data.iconURL ?? "https://raw.githubusercontent.com/quangtinh2842/PublicStore/refs/heads/main/Icons/notifications_1000dp_434343_FILL0_wght400_GRAD0_opsz48.png")!)
    _lblTitle.text = data.title
    _lblContent.text = data.content
    _lblTime.text = data.time?.timeAgoSinceSelf()
    _lblWasRead.alpha = data.wasRead ? 0 : 1
  }
}
