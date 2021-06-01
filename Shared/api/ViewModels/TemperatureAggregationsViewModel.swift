//
//  TemperatureAggregationsViewModel.swift
//  Gfror.li
//
//  Created by Marc on 25.05.21.
//

import Foundation
import SwiftUI

class TemperatureAggregationsViewModel: ObservableObject{
    
    @Published var minimumsDay = [Double]()
    @Published var averagesDay = [Double]()
    @Published var maximumsDay = [Double]()
    @Published var stepsDay = [Int]()
    
    @Published var minimumsWeek = [Double]()
    @Published var averagesWeek = [Double]()
    @Published var maximumsWeek = [Double]()
    @Published var stepsWeek = [Int]()
    
    @Published var minimumsMonth = [Double]()
    @Published var averagesMonth = [Double]()
    @Published var maximumsMonth = [Double]()
    @Published var stepsMonth = [Int]()
    
    var dateDay: Date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: Date()))!{
        didSet {
            loadDays()
        }
    }
    var startDateWeek: Date = Calendar.current.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: Date()).date!{
        didSet {
            loadWeek()
        }
    }
    var startDateMonth: Date = Calendar.current.dateComponents([.calendar, .month, .year], from: Date()).date!{
        didSet {
            loadMonth()
        }
    }
     
    var id: Int = 1
    
     func loadDays() {
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let start = df.string(from: dateDay)
        let end = df.string(from: dateDay)
        var url = URLRequest(url: URL(string: "https://watertemp-api.coredump.ch/api/mobile_app/sensors/\(id)/hourly_temperatures?from=\(start)&to=\(end)&limit=25")!)
        
        url.setValue("Bearer XTZA6H0Hg2f02bzVefmVlr8fIJMy2FGCJ0LlDlejj2Pi0i1JvZiL0Ycv1t6JoZzD", forHTTPHeaderField: "Authorization")
        url.httpMethod = "GET"
        print(url)
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                do {
                if let data = data {
                    // success: convert to  Measuring, and set according List
                    let jsonDecoder = JSONDecoder()
                    var aggregs = try jsonDecoder.decode([HourlyAggregation].self, from: data)
                    self.minimumsDay.removeAll()
                    self.maximumsDay.removeAll()
                    self.averagesDay.removeAll()
                    self.stepsDay.removeAll()
                    aggregs = aggregs.reversed()
                    for data in aggregs{
                        self.minimumsDay.append(data.minTemp!.roundToDecimal(1))
                        self.maximumsDay.append(data.maxTemp!.roundToDecimal(1))
                        self.averagesDay.append(data.avgTemp!.roundToDecimal(1))
                        self.stepsDay.append(data.hour!)
                    }
                } else {
                    print("")
                }
                }catch{
                    print("")

                }
            }
        }.resume()
    }
    
    public func loadWeek() {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let start = df.string(from: startDateWeek)
        let end = df.string(from:Calendar.current.date(byAdding: .day, value: 6, to: startDateWeek)!)
        
        var url = URLRequest(url: URL(string: "https://watertemp-api.coredump.ch/api/mobile_app/sensors/\(id)/daily_temperatures?from=\(start)&to=\(end)&limit=7")!)
        print(url)
        url.setValue("Bearer XTZA6H0Hg2f02bzVefmVlr8fIJMy2FGCJ0LlDlejj2Pi0i1JvZiL0Ycv1t6JoZzD", forHTTPHeaderField: "Authorization")

        url.httpMethod = "GET"
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                do {
                if let data = data {
                    // success: convert to  Measuring, and set according List
                    let jsonDecoder = JSONDecoder()
                    var aggregs = try jsonDecoder.decode([DailyAggregation].self, from: data)
                    aggregs = aggregs.reversed()
                    
                    self.minimumsWeek.removeAll()
                    self.maximumsWeek.removeAll()
                    self.averagesWeek.removeAll()
                    self.stepsWeek.removeAll()
                    
                    for data in aggregs{
                        self.minimumsWeek.append(data.minTemp!.roundToDecimal(1))
                        self.maximumsWeek.append(data.maxTemp!.roundToDecimal(1))
                        self.averagesWeek.append(data.avgTemp!.roundToDecimal(1))
                        let weekday = Calendar.current.component(.weekday, from: self.makeDateFromString(string: data.date!))
                        self.stepsWeek.append((abs(weekday+5))%7)
                        print(self.stepsWeek)
                        
                    }
                }else {
                    print("")
                }
                }catch{
                    print("")
                }
            }
        }.resume()
    }
    
    
    public func loadMonth() {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let start = df.string(from: startDateMonth)
        let end = df.string(from:Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: startDateMonth)!)
        
        var url = URLRequest(url: URL(string: "https://watertemp-api.coredump.ch/api/mobile_app/sensors/\(id)/daily_temperatures?from=\(start)&to=\(end)&limit=32")!)
    
        url.setValue("Bearer XTZA6H0Hg2f02bzVefmVlr8fIJMy2FGCJ0LlDlejj2Pi0i1JvZiL0Ycv1t6JoZzD", forHTTPHeaderField: "Authorization")
        url.httpMethod = "GET"
    
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                do {
                if let data = data {
                    // success: convert to  Measuring, and set according List
                    let jsonDecoder = JSONDecoder()
                    var aggregs = try jsonDecoder.decode([DailyAggregation].self, from: data)
                    aggregs = aggregs.reversed()
                    self.minimumsMonth.removeAll()
                    self.maximumsMonth.removeAll()
                    self.averagesMonth.removeAll()
                    self.stepsMonth.removeAll()

                    for data in aggregs{
                        
                        self.minimumsMonth.append(data.minTemp!.roundToDecimal(1))
                        self.maximumsMonth.append(data.maxTemp!.roundToDecimal(1))
                        self.averagesMonth.append(data.avgTemp!.roundToDecimal(1))
                        let monthday = Calendar.current.component(.day, from: self.makeDateFromString(string: data.date!))
                        self.stepsMonth.append(monthday-1)
                        
                    }
                    
                    
                } else {
                    print("")
                }
                }catch{
                    print("")
                }
            }
        }.resume()
    }
    
    func makeDateFromString(string: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from:string)!
        return date
    }
    func addWeek(){
        startDateWeek=Calendar.current.date(byAdding: DateComponents( day: 7), to:startDateWeek)!
        
    }
    func subtractWeek(){
        startDateWeek=Calendar.current.date(byAdding: DateComponents( day: -7), to:startDateWeek)!
    }
    
    func addDay(){
        dateDay = Calendar.current.date(byAdding: DateComponents( day: 1), to:dateDay)!
        
    }
    func subtractDay(){
        dateDay=Calendar.current.date(byAdding: DateComponents( day: -1), to:dateDay)!
        
    }
    
    func addMonth(){
        startDateMonth = Calendar.current.date(byAdding: DateComponents(month: 1), to: startDateMonth)!

    }
    func subtractMonth(){
        startDateMonth = Calendar.current.date(byAdding: DateComponents(month: -1), to: startDateMonth)!

    }
    
}

extension Double {
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}
