//
//  CommonTypes.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 04/03/2025.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

struct CConstants {
  static let kAesKey = ""
  static let kAesIv = ""
}

typealias ObjectQueryResultHandler2 = (_ result: NSDictionary?, _ error: Error?) -> ()
typealias ObjectQueryResultHandler = (_ result: MBase?, _ error: Error?) -> ()
typealias CollectionQueryResultHandler2 = (_ results: [String: NSDictionary], _ error: Error?) -> ()
typealias CollectionQueryResultHandler = (_ results: [MBase], _ error: Error?) -> ()
typealias StatusReturnHandler = (_ status: Bool, _ error: Error?) -> ()
typealias ErrorHandler = (Error?) -> ()
typealias UpdateValueHandler = (Error?, DatabaseReference) -> ()

let NotFoundError: NSError = {
  return NSError(domain: "Not found", code: -1002, userInfo: [NSLocalizedDescriptionKey: "Result(s) not found"])
}()

let NilFoundError: NSError = {
  return NSError(domain: "Found nil", code: -1003, userInfo: [NSLocalizedDescriptionKey: "Result(s) not found"])
}()

enum QueryClausesEnum: String {
  case OrderedChildKey = "OrderedChildKey"
  case StartValue = "StartValue"
  case EndValue = "EndValue"
  case ExactValue = "ExactValue"
}

enum ModelValidationError {
  case Valid
  case InvalidId
  case InvalidTimestamp
  case InvalidBlankAttribute
}

enum MainSbVCID: String {
  case SystemsNCID = "SystemsNCID"
  case ScheduleNCID = "ScheduleNCID"
  case NotificationsNCID = "NotificationsNCID"
  case MenuNCID = "MenuNCID"
  case NotificationsSettingsNCID = "NotificationsSettingsNCID"
  case SyncNCID = "SyncNCID"
  case ProblemsToProviderNCID = "ProblemsToProviderNCID"
  case AboutNCID = "AboutNCID"
  case ProblemToProviderNCID = "ProblemToProviderNCID"
  
  case HardToHandleErrorVCID = "HardToHandleErrorVCIdentifier"
  case LogInVCID = "LogInVCIdentifier"
  case SystemVCID = "SystemVCIdentifier"
  case MainTBCID = "MainTBCIdentifier"
  case EmailVerificationNCID = "EmailVerificationNCIdentifier"
  case SearchPopupVCID = "SearchPopupVCIdentifier"
  case BasicControlPopupVCID = "BasicControlPopupVCIdentifier"
  case SettingsVCID = "SettingsVCID"
  case ProfileVCID = "ProfileVCID"
  case ProfileNCID = "ProfileNCID"
  case AccountVCID = "AccountVCID"
  case AccountNCID = "AccountNCID"
  case HomeSystemsVCID = "HomeSystemsVCID"
  case TankSystemsVCID = "TankSystemsVCID"
  case OtherSystemsVCID = "OtherSystemsVCID"
  case AppearanceNCID = "AppearanceNCID"
  case LanguageNCID = "LanguageNCID"
  case ErasedListPopupVCID = "ErasedListPopupVCID"
  case CountryCodesVCID = "CountryCodesVCID"
  case NotificationSettingsVCID = "NotificationSettingsVCID"
  case SyncVCID = "SyncVCID"
  case ProblemsToProviderVCID = "ProblemsToProviderVCID"
  case ProblemToProviderVCID = "ProblemToProviderVCID"
  case AboutVCID = "AboutVCID"
  case ResourcesVCID = "ResourcesVCID"
  case SensorPopupVCID = "SensorPopupVCID"
  case NoConnectionVCID = "NoConnectionVCID"
}

enum DeviceSbVCID: String {
  case DeviceHomeNCID = "DeviceHomeNCIdentifier"
}

extension Date {
  func isFuture() -> Bool {
    return (self > Date())
  }
}

enum ReuseID: String {
  case BasicSearchCell = "BasicSearchCellIdentifier"
  case SystemCell = "SystemCellIdentifier"
  case SensorCell = "SensorCellIdentifier"
  case ButtonCell = "ButtonCellIdentifier"
  case ContextCell = "ContextCellIdentifier"
  case ControlCell = "ControlCellIdentifier"
  case SystemCollectionHeaderView = "SystemCollectionHeaderViewIdentifier"
  case HistoryCell = "HistoryCellIdentifier"
  case ErasedInfoCell = "ErasedInfoCellID"
  case CountryCodeCell = "CountryCodeCellID"
  case ResourceCell = "ResourceCellID"
  case ProblemToProviderCell = "ProblemToProviderCellID"
}

enum SegueID: String {
  case ProvinceSearch = "ProvinceSearchSegueIdentifier"
  case DistrictSearch = "DistrictSearchIdentifier"
  case WardSearch = "WardSearchSegueIdentifier"
  case BackPinMap = "BackPinMapSegueIdentifier"
  case DonePinMap = "DonePinMapSegueIdentifier"
  case AddNewMapPin = "AddNewMapPinSegueID"
  case EditMapPin = "EditMapPinSegueID"
  case NewProblemToProvider = "NewProblemToProviderSegueID"
  case ViewProblemToProvider = "ViewProblemToProviderSegueID"
}

extension String {
  func removeDiacritics(withLocale locale: Locale = Locale(identifier: "vi_VN")) -> String {
    return self.folding(options: .diacriticInsensitive, locale: locale)
  }
  
  func viToASCII() -> String {
    var ascii = self.removeDiacritics()
    ascii = ascii.replacingOccurrences(of: "Đ", with: "D")
    ascii = ascii.replacingOccurrences(of: "đ", with: "d")
    return ascii
  }
  
  func toBool() -> Bool {
    return (self as NSString).boolValue
  }
}

func search(withText text: String, listParam: [String]) -> [String] {
  if text.isEmpty {
    return listParam
  }
  
  return listParam.filter { item in
    let lowercasedSearch = text.lowercased()
    let lowercasedItem = item.lowercased()
    
    if lowercasedItem.contains(lowercasedSearch) {
      return true
    }
    
    let lowercasedItemWithASCIINormalization = lowercasedItem.viToASCII()
    let lowercasedSearchWithASCIINormalization = lowercasedSearch.viToASCII()
    
    if lowercasedItemWithASCIINormalization.contains(lowercasedSearchWithASCIINormalization) {
      return true
    }
    
    return false
  }
}

extension Date {
  func ddMMyyyy() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy"
    return formatter.string(from: self)
  }
  
  func hhmm() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "hh:mm"
    return formatter.string(from: self)
  }
}
