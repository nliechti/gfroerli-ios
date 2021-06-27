//
//  Helpers.swift
//  Gfror.li
//
//  Created by Marc Kramer on 11.09.20.
//
import UIKit
import Foundation

public func createDatefromString(string: String) -> Date {
    var newDate = string
    newDate.removeLast(5)
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    let date = dateFormatter.date(from: newDate)!
    return date
}

public func createDateStringfromStringDate(string: String) -> String {
    var newDate = string
    newDate.removeLast(5)
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    let date = dateFormatter.date(from: newDate)!
    let stringFormatter = DateFormatter()
    stringFormatter.dateFormat = "HH:mm, d. MMMM y"
    return stringFormatter.string(from: date)

}

public func createStringFromDate(date: Date, format: String = "HH:mm, d. MMMM y") -> String {

    let stringFormatter = DateFormatter()
    stringFormatter.dateFormat = format
    return stringFormatter.string(from: date)

}

public func areSameDay(date1: Date, date2: Date) -> Bool {
    let calendar = Calendar.current
    let dayComp2 = calendar.dateComponents([.day], from: date1)
    let dayComp1 = calendar.dateComponents([.day], from: date2)

    if dayComp1.day == dayComp2.day {
        return true
    }
    return false
}

enum NetworkError: Error {
    case badURL, requestFailed, decodeFailed, unknown
}

// swiftlint:disable:next type_name
enum loadingState: Equatable {
    case loading, loaded, error
}
enum TimeFrame: Equatable {
    case day, week, month
}

/**
 Returns autogenerated string for feedback & bug-reports
 ~Marc
 */
public func getEmailBody() -> String {
    let version = ("App-Version: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unkown")")
    let model = "Device-Model: \(machineName())"
    let systemVersion = "OS-Version: \(UIDevice.current.systemName) \(UIDevice.current.systemVersion)"
    let lang = "Language: \(Locale.current.languageCode ?? "unkown")"
    let str = NSLocalizedString("email_text", comment: "")
    return "</br></br></br></br></br>\(str)</br></br>Info:</br>\(version)</br>\(model)</br>\(systemVersion)</br>\(lang)"

}


func machineName() -> String {
  var systemInfo = utsname()
  uname(&systemInfo)
  let machineMirror = Mirror(reflecting: systemInfo.machine)
  return machineMirror.children.reduce("") { identifier, element in
    guard let value = element.value as? Int8, value != 0 else { return identifier }
    return identifier + String(UnicodeScalar(UInt8(value)))
  }
}

func makeTemperatureStringFromDouble(double: Double, precision: Int = 1) -> String {
    let formatter = MeasurementFormatter()
    formatter.numberFormatter.maximumFractionDigits = 1
    formatter.numberFormatter.minimumFractionDigits = 1
    let unit = Measurement<UnitTemperature>(value: double, unit: .celsius)
    return formatter.string(from: unit)
}

func makeTemperatureString(double: Double, precision: Int = 1) -> String {
    let formatter = MeasurementFormatter()
    formatter.numberFormatter.maximumFractionDigits = 1
    let unit = Measurement<UnitTemperature>(value: double, unit: .celsius)
    return formatter.string(from: unit)
}
