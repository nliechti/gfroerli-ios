//
//  WidgetAPILoaders.swift
//  iOS
//
//  Created by Marc on 29.01.21.
//

import Foundation
import SwiftUI
import CoreData


struct SingleSensorGraphLoader{
    
    static func loadSens(id: Int, completion: @escaping(Result<Sensor,Error>) -> Void) {
        var url = URLRequest(url: URL(string: "https://watertemp-api.coredump.ch/api/mobile_app/sensors/\(id)")!)
        url.setValue("Bearer XTZA6H0Hg2f02bzVefmVlr8fIJMy2FGCJ0LlDlejj2Pi0i1JvZiL0Ycv1t6JoZzD", forHTTPHeaderField: "Authorization")
        url.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                do {
                    if let data = data {
                        // success: convert to  Sensors
                        let jsonDecoder = JSONDecoder()
                        let sensor = try jsonDecoder.decode(Sensor.self, from: data)
                        completion(.success(sensor))
                        
                    } else {
                        // other cases
                        completion(.failure(error!))
                    }
                    // decoding failed
                }catch{
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    static func loadDailyAggs(id: Int, completion: @escaping(Result<[HourlyAggregation?],Error>) -> Void) {
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let start = df.string(from: Calendar.current.date(byAdding: .day, value:-1, to:Date())!)
        let end = df.string(from: Calendar.current.date(byAdding: .day, value:0, to:Date())!)
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
                        let hour = Calendar.current.component(.hour, from: Date())
                        //remove entries older than 24 hours
                        for i in (0..<aggregs.count).reversed(){
                            if aggregs[i].hour! <= hour{
                                aggregs.remove(at: i)
                            }else{
                                break
                            }
                        }
                        var array = [HourlyAggregation?].init(repeating: nil, count: 24)
                        for agg in aggregs{
                            print("Insert: \(agg.avgTemp!)  at \(agg.hour!)")
                            array[agg.hour!] = agg
                        }
                        
                        array.rotateLeft(positions: hour+1)
                        completion(.success(array))
                        
                    } else {
                        completion(.failure(error!))
                    }
                }catch{
                    completion(.failure(error))
                    
                }
            }
        }.resume()
    }
    
    static func loadMonthlyAggs(id: Int, completion: @escaping(Result<[DailyAggregation],Error>) -> Void) {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let start = df.string(from: Calendar.current.date(byAdding: .day, value:-31, to:Date())!)
        let end = df.string(from: Calendar.current.date(byAdding: .day, value:0, to:Date())!)
        
        var url = URLRequest(url: URL(string: "https://watertemp-api.coredump.ch/api/mobile_app/sensors/\(id)/daily_temperatures?from=\(start)&to=\(end)&limit=32")!)
        
        url.setValue("Bearer XTZA6H0Hg2f02bzVefmVlr8fIJMy2FGCJ0LlDlejj2Pi0i1JvZiL0Ycv1t6JoZzD", forHTTPHeaderField: "Authorization")
        url.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                do {
                if let data = data {
                    // success: convert to  Measuring, and set according List
                    let jsonDecoder = JSONDecoder()
                    let aggregs = try jsonDecoder.decode([DailyAggregation].self, from: data)
                    completion(.success(aggregs.reversed()))

                    
                } else {
                    completion(.failure(error!))
                }
                }catch{
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    static func loadWeeklyAggs(id: Int, completion: @escaping(Result<[DailyAggregation],Error>) -> Void) {
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let start = df.string(from: Calendar.current.date(byAdding: .day, value:-7, to:Date())!)
        let end = df.string(from: Calendar.current.date(byAdding: .day, value:0, to:Date())!)
        var url = URLRequest(url: URL(string: "https://watertemp-api.coredump.ch/api/mobile_app/sensors/\(id)/daily_temperatures?from=\(start)&to=\(end)&limit=8")!)
        
        url.setValue("Bearer XTZA6H0Hg2f02bzVefmVlr8fIJMy2FGCJ0LlDlejj2Pi0i1JvZiL0Ycv1t6JoZzD", forHTTPHeaderField: "Authorization")
        url.httpMethod = "GET"
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                do {
                if let data = data {
                    // success: convert to  Measuring, and set according List
                    let jsonDecoder = JSONDecoder()
                    let aggregs = try jsonDecoder.decode([DailyAggregation].self, from: data)
                    completion(.success(aggregs.reversed()))
                }else {
                    completion(.failure(error!))
                }
                }catch{
                    completion(.failure(error))
                }
            }
        }.resume()

    }
}
