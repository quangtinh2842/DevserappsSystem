import UIKit

@objc protocol LanguageDelegate: NSObjectProtocol {
  @objc optional func languageVC(languageVC: LanguageVC, didSelect selectedLanguage: String)
}

class LanguageVC: UITableViewController {
  var shouldSetupViews = true
  var shouldPopulateDataFromLanguage = true
  var shouldRefreshViews = false
  
  var delegate: LanguageDelegate?
  var language: String?
  
  private var _bottomSeparatorLine: UIView!
  private var _bottomBlurEffectView: UIVisualEffectView!
  private var _currentSelectedRow = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if shouldPopulateDataFromLanguage {
      _populateDataFromLanguage()
      shouldPopulateDataFromLanguage = true
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if shouldSetupViews {
      _setupViews()
      shouldSetupViews = false
    }
    
    if shouldPopulateDataFromLanguage {
      _populateDataFromLanguage()
      shouldPopulateDataFromLanguage = false
    }
    
    if shouldRefreshViews {
      _refreshViews()
      shouldRefreshViews = false
    }
  }
  
  private func _populateDataFromLanguage() {
    if language == "vi" {
      _currentSelectedRow = 0
    } else if language == "en" {
      _currentSelectedRow = 1
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    _handleBottomViewWith(self.tableView, isSwipe: false)
  }
  
  private func _refreshViews() {
  }
  
  private func _setupViews() {
    tableView(tableView, didSelectRowAt: IndexPath(row: _currentSelectedRow, section: 0))
    _setupSaveBtn()
  }
  
  private func _setupSaveBtn() {
    let container = UIView()
    container.frame = .zero
    container.frame.size.width = view.frame.width
    container.frame.size.height = 50*2
    container.frame.origin.x = 0
    container.frame.origin.y = view.frame.height-container.frame.height
    container.backgroundColor = .clear
    
    _bottomSeparatorLine = UIView()
    _bottomSeparatorLine.frame = .zero
    _bottomSeparatorLine.frame.size.width = view.frame.width
    _bottomSeparatorLine.frame.size.height = 1
    _bottomSeparatorLine.backgroundColor = .separator
    
    let blurEffect = UIBlurEffect(style: .systemChromeMaterial)
    _bottomBlurEffectView = UIVisualEffectView(effect: blurEffect)
    _bottomBlurEffectView.frame.size = container.bounds.size
    _bottomBlurEffectView.frame.origin.x = 0
    _bottomBlurEffectView.frame.origin.y = 1
    _bottomBlurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    container.addSubview(_bottomBlurEffectView)
    container.addSubview(_bottomSeparatorLine)
    
    let saveBtn = UIButton(type: .system)
    saveBtn.frame = .zero
    saveBtn.frame.size.width = view.frame.width*0.9
    saveBtn.frame.size.height = 50
    saveBtn.frame.origin.x = (container.frame.width-saveBtn.frame.width)/2
    saveBtn.frame.origin.y = 25
    saveBtn.setTitle("Save", for: .normal)
    saveBtn.titleLabel?.font = .systemFont(ofSize: 17)
    saveBtn.setTitleColor(.white, for: .normal)
    saveBtn.backgroundColor = self.view.tintColor
    saveBtn.layer.cornerRadius = 25
    saveBtn.layer.masksToBounds = true
    saveBtn.addTarget(self, action: #selector(_handleSaveBtnTapped), for: .touchUpInside)
    
    container.addSubview(saveBtn)
    navigationController?.view.addSubview(container)
  }
  
  @objc private func _handleSaveBtnTapped(_ sender: Any) {
    if language != nil {
      delegate?.languageVC?(languageVC: self, didSelect: language!)
      self.dismiss(animated: true)
    }
  }
  
  @IBAction func handleXMarkBtnTapped(_ sender: Any) {
    self.dismiss(animated: true)
  }
}

extension LanguageVC {
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = super.tableView(tableView, cellForRowAt: indexPath) as! AppearanceCell
    cell._btnChoosing.addTarget(self, action: #selector(_handleChoosingBtnTapped), for: .touchUpInside)
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let preSelectedRow = _currentSelectedRow
    _currentSelectedRow = indexPath.row
    
    if _currentSelectedRow == 0 {
      language = "vi"
    } else if _currentSelectedRow == 1 {
      language = "en"
    }
    
    let preSelectedCell = super.tableView.cellForRow(at: IndexPath(row: preSelectedRow, section: 0)) as! AppearanceCell
    preSelectedCell._vContainer.layer.borderWidth = 0
    let preImage = UIImage(systemName: "circle")
    preSelectedCell._btnChoosing.setImage(preImage, for: .normal)
    
    let selectedCell = super.tableView.cellForRow(at: indexPath) as! AppearanceCell
    selectedCell._vContainer.layer.borderWidth = 3
    selectedCell._vContainer.layer.borderColor = UIColor.tintColor.cgColor // consider to optimize
    let selectedImage = UIImage(systemName: "largecircle.fill.circle")
    selectedCell._btnChoosing.setImage(selectedImage, for: .normal)
  }
  
  @objc private func _handleChoosingBtnTapped(_ sender: UIButton) {
    tableView(tableView, didSelectRowAt: IndexPath(row: sender.tag, section: 0))
  }
  
  override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    if section == 0 {
      return 50*2+5
    } else {
      return super.tableView(tableView, heightForFooterInSection: section)
    }
  }
}

extension LanguageVC {
  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    _handleBottomViewWith(scrollView, isSwipe: true)
  }
  
  private func _handleBottomViewWith(_ scrollView: UIScrollView, isSwipe: Bool) {
    var tableViewContentHeight = tableView.contentSize.height
    tableViewContentHeight += (isSwipe ? 0 : (85))
    let scrollInsideContentHeight = tableViewContentHeight-scrollView.contentOffset.y-(50*2)
    let containerY = view.frame.height-(50*2)
    let space = containerY-scrollInsideContentHeight
    
    if space > 6 {
      _bottomSeparatorLine.alpha = 0
      _bottomBlurEffectView.alpha = 0
    } else if space <= 6 && space >= 0 {
      let alpha = 1-(space/6)
      _bottomSeparatorLine.alpha = alpha
      _bottomBlurEffectView.alpha = alpha
    } else {
      _bottomSeparatorLine.alpha = 1
      _bottomBlurEffectView.alpha = 1
    }
  }
}
