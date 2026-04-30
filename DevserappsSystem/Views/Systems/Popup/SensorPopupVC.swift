//
//  SensorPopupVC.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 10/04/2025.
//

import UIKit
import DPCharts

class SensorPopupVC: UIViewController {
  var shouldSetupViews = true
  var shouldPopulateDataFromSensor = true
  var shouldRefreshViews = false
  
  @IBOutlet weak var _lblTitle: UILabel!
  @IBOutlet weak var _lblSubtitle: UILabel!
  @IBOutlet weak var _vLineChart: DPLineChartView!
  
  var sensors: [Sensor] = []
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if shouldSetupViews {
      _setupViews()
      shouldSetupViews = false
    }
    
    if shouldPopulateDataFromSensor {
      _populateDataFromSensor()
      shouldPopulateDataFromSensor = false
    }
    
    if shouldRefreshViews {
      _refreshViews()
      shouldRefreshViews = false
    }
  }
  
  private func _setupViews() {
    _vLineChart.datasource = self
    _vLineChart.bezierCurveEnabled = false
    _vLineChart.areaEnabled = true
    _vLineChart.yAxisInverted = false
    _vLineChart.yAxisMarkersWidthRetained = true
  }
  
  private func _populateDataFromSensor() {
    
  }
  
  private func _refreshViews() {
  }
  
  @IBAction func handleBackgroundTapped(_ sender: Any) {
    self.dismiss(animated: true)
  }
}

extension SensorPopupVC: DPLineChartViewDataSource {
  func lineChartView(_ lineChartView: DPLineChartView, colorForLineAtIndex lineIndex: Int) -> UIColor {
    return .blue
  }
  
  func lineChartView(_ lineChartView: DPCharts.DPLineChartView, valueForLineAtIndex lineIndex: Int, forPointAtIndex index: Int) -> CGFloat {
    let rst = CGFloat.random(in: 1...10)
    print(index, rst)
    return rst
  }
  
  func numberOfLines(_ lineChartView: DPCharts.DPLineChartView) -> Int {
    return 1
  }
  
  func numberOfPoints(_ lineChartView: DPCharts.DPLineChartView) -> Int {
    return 10
  }
  
  func lineChartView(_ lineChartView: DPLineChartView, xAxisLabelAtIndex index: Int) -> String? {
    return String(index*2)
  }
  
  func lineChartView(_ lineChartView: DPLineChartView, yAxisLabelAtIndex index: Int, for value: CGFloat) -> String? {
    if index == 5 {
      return nil
    } else {
      return String(index*2)
    }
  }
}
