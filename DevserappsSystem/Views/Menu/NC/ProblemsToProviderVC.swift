//
//  ProblemsToProviderVC.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 31/03/2025.
//

import UIKit

class ProblemsToProviderVC: UITableViewController {
  var shouldSetupViews = true
  var shouldPopulateDataFromProblem = true
  var shouldRefreshViews = false
  
  var problems: [Problem] = []
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if shouldSetupViews {
      _setupViews()
      shouldSetupViews = false
    }
    
    if shouldPopulateDataFromProblem {
      _populateDataFromProblem()
      shouldPopulateDataFromProblem = false
    }
    
    if shouldRefreshViews {
      _refreshViews()
      shouldRefreshViews = false
    }
  }
  
  private func _refreshViews() {
  }
  
  private func _setupViews() {
  }
  
  private func _populateDataFromProblem() {
  }
  
  @IBAction func handleBackBtnTapped(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func handleNewProblemBtnTapped(_ sender: Any) {
    let nc = StoryboardHelper.newProblemToProviderNC()
    let vc = nc.viewControllers.first as! ProblemToProviderVC
    if title == "App feedbacks" {
      vc.title = "New app feedback"
    } else if title == "Bug reports" {
      vc.title = "New bug report"
    } else if title == "Help & Support requests" {
      vc.title = "New help & support request"
    }
    vc.delegate = self
    self.present(nc, animated: true)
  }
}

extension ProblemsToProviderVC {
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return problems.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ReuseID.ProblemToProviderCell.rawValue) as! ProblemToProviderCell
    cell.updateViews(with: problems[indexPath.row])
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let problemToProviderNC = StoryboardHelper.newProblemToProviderNC()
    let vc = problemToProviderNC.viewControllers.first as! ProblemToProviderVC
    if title == "App feedbacks" {
      vc.title = "App feedback"
    } else if title == "Bug reports" {
      vc.title = "Bug report"
    } else if title == "Help & Support requests" {
      vc.title = "Help & Support request"
    }
    vc.firstProblem = Problem(problem: problems[indexPath.row])
    self.present(problemToProviderNC, animated: true)
  }
}

extension ProblemsToProviderVC: ProblemToProviderDelegate {
  func problemToProviderVC(problemToProviderVC: ProblemToProviderVC, didSendProblem sentProblem: Problem) {
    if title == "App feedbacks" {
      problems = SettingsStore.currentSettings.appFeedbacks
    } else if title == "Bug reports" {
      problems = SettingsStore.currentSettings.bugReports
    } else if title == "Help & Support requests" {
      problems = SettingsStore.currentSettings.helpAndSupportRequests
    }
    
    tableView.reloadData()
  }
}
