//
//  SystemsViewController.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 03/03/2025.
//

import UIKit
import AlamofireImage
import SwiftUI

class SystemViewController: UICollectionViewController {
  var shouldRefreshViews: Bool = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    _setupViews()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if shouldRefreshViews {
      _refreshViews()
      shouldRefreshViews = false
    }
    
    _customNavAndTabBar()
  }

  private func _refreshViews() {
  }
  
  private func _customNavAndTabBar() {
    let nameAct = UIAction(title: "Name", image: UIImage(systemName: "abc")) { _ in
    }
    let photoAct = UIAction(title: "Photo", image: UIImage(systemName: "photo")) { _ in
    }
    let addressAct = UIAction(title: "Address", image: UIImage(systemName: "mappin.and.ellipse")) { _ in
    }
    let colorAct = UIAction(title: "Background", image: UIImage(systemName: "paintbrush.fill")) { _ in
    }
    let menu = UIMenu(title: "Settings", children: [nameAct, photoAct, addressAct, colorAct])
    let rightBarButton = UIBarButtonItem(
      image: UIImage(systemName: "ellipsis.circle.fill"),
      menu: menu
    )
    rightBarButton.tintColor = .label
    self.navigationItem.rightBarButtonItem = rightBarButton
  }
  
  private func _setupViews() {
    let background = UIImageView(frame: super.view.bounds)
    background.backgroundColor = .clear
    background.contentMode = .scaleAspectFill
    
    let blackOver = UIView(frame: background.bounds)
    blackOver.backgroundColor = .black
    blackOver.alpha = 0.3
    background.addSubview(blackOver)
    
    if let backgroundURL = URL(string: "https://static.vecteezy.com/system/resources/previews/040/890/255/non_2x/ai-generated-empty-wooden-table-on-the-natural-background-for-product-display-free-photo.jpg") {
      background.af.setImage(withURL: backgroundURL)
    }
    
//    collectionView.backgroundView = background
    collectionView.collectionViewLayout = _createLayout()
  }
  
  @objc func rightButtonTapped() {
  }
  
  private func _createLayout() -> UICollectionViewCompositionalLayout {
    UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
      if self == nil { return nil }
      
      if sectionIndex == 0 {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .estimated(60), heightDimension: .fractionalHeight(1)))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .estimated(128), heightDimension: .absolute(60)), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 16
        section.contentInsets = .init(top: 16, leading: 16, bottom: 20, trailing: 16)
        
        return section
      }
      
      if sectionIndex == 1 {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .estimated(128), heightDimension: .fractionalHeight(1)))
        
        let trailingEdgeSpacing = NSCollectionLayoutSpacing.fixed(16)
        item.edgeSpacing = .init(leading: nil, top: nil, trailing: trailingEdgeSpacing, bottom: nil)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        section.contentInsets = .init(top: 0, leading: 16, bottom: 20, trailing: 0)
        if let supplementaryHeaderItem = self?._supplementaryHeaderItem() {
          section.boundarySupplementaryItems = [supplementaryHeaderItem]
        }
        section.supplementariesFollowContentInsets = false
        
        return section
      }
      
      if sectionIndex == 2 {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(60)))
        
        let groupW = (self!.view.bounds.width-16*3)/2
        
        let leftGroup = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .absolute(groupW), heightDimension: .estimated(60)), repeatingSubitem: item, count: 4)
        
        leftGroup.interItemSpacing = .fixed(16)

        leftGroup.edgeSpacing = .init(leading: nil, top: nil, trailing: .fixed(16), bottom: nil)
        
        let rightGroup = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .absolute(groupW), heightDimension: .estimated(60)), repeatingSubitem: item, count: 4)
        
        rightGroup.interItemSpacing = .fixed(16)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(60)), subitems: [leftGroup, rightGroup])
        
        let section = NSCollectionLayoutSection(group: group)
                
        section.contentInsets = .init(top: 0, leading: 16, bottom: 16, trailing: 16)
        if let supplementaryHeaderItem = self?._supplementaryHeaderItem() {
          section.boundarySupplementaryItems = [supplementaryHeaderItem]
        }
        section.supplementariesFollowContentInsets = false
        
        return section
      }
      
      return nil
    }
  }
  
  private func _supplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
    .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
  }
}

extension SystemViewController {
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 3
  }
  
  override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    switch kind {
    case UICollectionView.elementKindSectionHeader:
      let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ReuseID.SystemCollectionHeaderView.rawValue, for: indexPath) as! SystemCollectionHeaderView
      
      if indexPath.section == 1 {
        header.updateView(with: "Context", rightBtnAct: {
        })
      } else if indexPath.section == 2 {
        header.updateView(with: "Device & Group", rightBtnAct: {
        })
      }
      
      return header
    default:
      return UICollectionReusableView()
    }
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch section {
    case 0: return 5
    case 1: return 5
    case 2: return 8
    default: return -9
    }
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    var id: String!
    
    if indexPath.section == 0 {
      if indexPath.row == 0 || indexPath.row == 1 {
        id = ReuseID.ButtonCell.rawValue
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath) as! ButtonCell
        cell.setupCellView()
        cell.updateCell(WithTitle: indexPath.row == 0 ? "ON": "OFF", state: indexPath.row == 0)
        return cell
      } else {
        id = ReuseID.SensorCell.rawValue
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath) as! SensorCell
        cell.setupCellView()
        return cell
      }
    }
    
    if indexPath.section == 1 {
      id = ReuseID.ContextCell.rawValue
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath) as! ContextCell
      
      switch indexPath.row {
      case 0: cell.stringContent = "haha"
      case 1: cell.stringContent = "haha haha"
      case 2: cell.stringContent = "haha haha haha"
      case 3: cell.stringContent = "haha haha haha haha"
      case 4: cell.stringContent = "hi"
      default: cell.stringContent = ""
      }
      
      cell.setupCellView()
      
      return cell
    }
    
    if indexPath.section == 2 {
      
      var cell: UICollectionViewCell!
      
      if indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 4 || indexPath.row == 7 {
        id = ReuseID.SensorCell.rawValue
        let sensorCell = collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath) as! SensorCell
        sensorCell.setupCellView()
        cell = sensorCell
      } else {
        id = ReuseID.ControlCell.rawValue
        let controlCell = collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath) as! ControlCell
        controlCell.setupCellView()
        cell = controlCell
      }
      
      cell.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(_handleCellLongPressed)))
      
      return cell
    }
    
    return UICollectionViewCell()
  }
  
  @objc private func _handleCellLongPressed() {
    let deviceHomeNC = StoryboardHelper.newDeviceHomeNC()
    self.present(deviceHomeNC, animated: true)
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if indexPath.section == 0 && indexPath.row > 1 {
      let sensorPopupVC = StoryboardHelper.newSensorPopupVC()
      self.present(sensorPopupVC, animated: true)
    }
    
    if indexPath.section == 2 {
      let basicControlVC = StoryboardHelper.newBasicControlPopupVC()
      self.present(basicControlVC, animated: true)
    }
  }
}
