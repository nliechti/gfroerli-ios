//
//  Helpers.swift
//  Gfror.li
//
//  Created by Marc Kramer on 11.09.20.
//

import Foundation

public func createDatefromString(string: String)->Date{
    var newDate = string
    newDate.removeLast(5)
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    let date = dateFormatter.date(from:newDate)!
    return date
}

public func createDateStringfromStringDate(string: String)->String{
    var newDate = string
    newDate.removeLast(5)
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    let date = dateFormatter.date(from:newDate)!
    let stringFormatter = DateFormatter()
    stringFormatter.dateFormat = "HH:mm, d. MMMM y"
    return stringFormatter.string(from: date)
    
}

public func createStringFromDate(date: Date)->String{
    
    let stringFormatter = DateFormatter()
    stringFormatter.dateFormat = "HH:mm, d. MMMM y"
    return stringFormatter.string(from: date)
    
}
