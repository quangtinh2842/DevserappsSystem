//
//  NotificationVC.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 20/03/2025.
//

import UIKit

class NotificationsVC: UITableViewController {
  var shouldRefreshViews: Bool = false
    
  private var _filteredNotifications: [MNotification] = []
  private let searchController = UISearchController(searchResultsController: nil)
  
  var isFiltering: Bool {
    return searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    _setupViews()
    _refreshAndPopulateNotificationsData()
  }
  
  private func _setupViews() {
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.largeTitleDisplayMode = .always
    
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search..."
    navigationItem.searchController = searchController
    definesPresentationContext = true
    
//    navigationItem.hidesSearchBarWhenScrolling = false
    
    refreshControl?.addTarget(self, action: #selector(_refreshAndPopulateNotificationsData), for: .valueChanged)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if shouldRefreshViews {
      _refreshViews()
      shouldRefreshViews = false
    }
  }
  
  private func _refreshViews() {
    if shouldRefreshViews {
      NotificationsStore.notifications = []
      _populateNotificationsData()
    }
    _refreshAndPopulateNotificationsData()
  }
  
  @objc private func _refreshAndPopulateNotificationsData() {
    MNotification.allNotificationsForCurrentUser { [weak self] results, error in
      self?.refreshControl?.endRefreshing()
      
      if error != nil {
        self?._presentBasicAlert(title: error!.localizedDescription, message: nil)
      } else {
        NotificationsStore.notifications = results as! [MNotification]
        self?._populateNotificationsData()
      }
    }
  }
  
  private func _populateNotificationsData() {
    tableView.reloadData()
    _updateBadgeCount()
  }
  
  private func _updateBadgeCount() {
    let unreadCount = NotificationsStore.notifications.filter { !$0.wasRead }.count
    
    if let tabBarItem = self.navigationController?.tabBarItem {
      tabBarItem.badgeValue = unreadCount > 0 ? "\(unreadCount)" : nil
    }
  }
  
  private func _presentBasicAlert(title: String?, message: String?) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    self.present(alert, animated: true, completion: nil)
  }
}

// MARK: - TableView
extension NotificationsVC {
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return UIView(frame: .zero)
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return isFiltering ? _filteredNotifications.count : NotificationsStore.notifications.count
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ReuseID.NotificationCell.rawValue) as! NotificationCell
    
    let notification = isFiltering ? _filteredNotifications[indexPath.row] : NotificationsStore.notifications[indexPath.row]
    cell.setupCell(with: notification)
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedNotification = isFiltering ? _filteredNotifications[indexPath.row] : NotificationsStore.notifications[indexPath.row]
    
    if selectedNotification.wasRead == false {
      selectedNotification.wasRead = true
      do {
        let _ = try selectedNotification.save(completion: { [weak self] error, _ in
          if error != nil {
            selectedNotification.wasRead = false
            self?._presentBasicAlert(title: "Error", message: error!.localizedDescription)
          } else {
            self?.tableView.reloadRows(at: [indexPath], with: .none)
            self?._updateBadgeCount()
          }
        })
      } catch {
        selectedNotification.wasRead = false
        self._presentBasicAlert(title: "Error", message: error.localizedDescription)
      }
    }
    
    let notificationVC = StoryboardHelper.newNotificationVC()
    if let sheet = notificationVC.sheetPresentationController {
      sheet.detents = [.large()]
      sheet.preferredCornerRadius = 24
    }
    notificationVC.firstNotification = selectedNotification
    self.present(notificationVC, animated: true)
  }
}

extension NotificationsVC: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    let searchText = searchController.searchBar.text ?? ""
    
    _filteredNotifications = NotificationsStore.notifications.filter { (notification: MNotification) -> Bool in
      let titleMatch = notification.title?.lowercased().contains(searchText.lowercased()) ?? false
      let contentMatch = notification.content?.lowercased().contains(searchText.lowercased()) ?? false
      
      return titleMatch || contentMatch
    }
    
    tableView.reloadData()
  }
}
