/*
 Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar
 
 */

import Foundation
import Combine

struct HourlyAggregation : Codable, Identifiable,Aggregation{
    
    internal init(id: String?, date: String?, hour: Int?, maxTemp: Double?, minTemp: Double?, avgTemp: Double?) {
        self.id = id
        self.date = date
        self.hour = hour
        self.maxTemp = maxTemp
        self.minTemp = minTemp
        self.avgTemp = avgTemp
    }
    
    let id: String?
    let date: String?
    let hour: Int?
    let maxTemp: Double?
    let minTemp: Double?
    let avgTemp: Double?
    
    enum CodingKeys: String, CodingKey {
        
        case date = "aggregation_date"
        case hour = "aggregation_hour"
        case minTemp = "minimum_temperature"
        case maxTemp = "maximum_temperature"
        case avgTemp = "average_temperature"
        
    }
    
    init(from decoder: Decoder) throws{
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = UUID().uuidString
        date = try values.decodeIfPresent(String.self, forKey: .date)
        hour = try values.decodeIfPresent(Int.self, forKey: .hour)
        maxTemp = try values.decodeIfPresent(Double.self, forKey: .maxTemp)
        minTemp = try values.decodeIfPresent(Double.self, forKey: .minTemp)
        avgTemp = try values.decodeIfPresent(Double.self, forKey: .avgTemp)
    }
    
    static var example=[
        
        HourlyAggregation(id: "0", date: "00", hour: 21, maxTemp: 22.9, minTemp: 22.6, avgTemp: 22.8),
        HourlyAggregation(id: "0", date: "00", hour: 22, maxTemp: 22.9, minTemp: 22.6, avgTemp: 22.7),
        HourlyAggregation(id: "0", date: "00", hour: 23, maxTemp: 22.5, minTemp: 22.3, avgTemp: 22.4),
        HourlyAggregation(id: "0", date: "00", hour: 24, maxTemp: 22.2, minTemp: 22.0, avgTemp: 22.1),
        HourlyAggregation(id: "0", date: "00", hour: 0, maxTemp: 22.5, minTemp: 22.3, avgTemp: 22.2),
        HourlyAggregation(id: "0", date: "00", hour: 1, maxTemp: 22.8, minTemp: 22.5, avgTemp: 22.7),
        HourlyAggregation(id: "0", date: "00", hour: 2, maxTemp: 22.9, minTemp: 22.8, avgTemp: 22.8),
        HourlyAggregation(id: "0", date: "00", hour: 3, maxTemp: 22.7, minTemp: 22.3, avgTemp: 22.6),
        HourlyAggregation(id: "0", date: "00", hour: 4, maxTemp: 22.5, minTemp: 22.0, avgTemp: 22.2),
        HourlyAggregation(id: "0", date: "00", hour: 5, maxTemp: 22.0, minTemp: 21.6, avgTemp: 21.8),
        HourlyAggregation(id: "0", date: "00", hour: 6, maxTemp: 22.0, minTemp: 21.6, avgTemp: 21.8),
        HourlyAggregation(id: "0", date: "00", hour: 7, maxTemp: 22.4, minTemp: 22.0, avgTemp: 22.2),
        HourlyAggregation(id: "0", date: "00", hour: 8, maxTemp: 22.8, minTemp: 22.3, avgTemp: 22.6),
        HourlyAggregation(id: "0", date: "00", hour: 9, maxTemp: 23.4, minTemp: 23.0, avgTemp: 23.2),
        HourlyAggregation(id: "0", date: "00", hour: 10, maxTemp: 23.6, minTemp: 23.3, avgTemp: 23.5),
        HourlyAggregation(id: "0", date: "00", hour: 11, maxTemp: 23.6, minTemp: 23.2, avgTemp: 23.3),
        HourlyAggregation(id: "0", date: "00", hour: 12, maxTemp: 23.5, minTemp: 23.3, avgTemp: 23.4),
        HourlyAggregation(id: "0", date: "00", hour: 13, maxTemp: 23.4, minTemp: 23.3, avgTemp: 23.3),
        HourlyAggregation(id: "0", date: "00", hour: 14, maxTemp: 23.6, minTemp: 23.2, avgTemp: 23.4),
        HourlyAggregation(id: "0", date: "00", hour: 15, maxTemp: 23.5, minTemp: 23.2, avgTemp: 23.3),
        HourlyAggregation(id: "0", date: "00", hour: 16, maxTemp: 23.6, minTemp: 23.3, avgTemp: 23.5),
        HourlyAggregation(id: "0", date: "00", hour: 17, maxTemp: 23.8, minTemp: 23.5, avgTemp: 23.7),
        HourlyAggregation(id: "0", date: "00", hour: 18, maxTemp: 23.6, minTemp: 23.4, avgTemp: 23.5),
        HourlyAggregation(id: "0", date: "00", hour: 19, maxTemp: 23.5, minTemp: 23.2, avgTemp: 23.3),
    ]

}

struct DailyAggregation : Codable, Identifiable, Aggregation{
    
    internal init(id: String?, date: String?, maxTemp: Double?, minTemp: Double?, avgTemp: Double?) {
        self.id = id
        self.date = date
        self.maxTemp = maxTemp
        self.minTemp = minTemp
        self.avgTemp = avgTemp
    }
    
    let id: String?
    let date: String?
    let maxTemp: Double?
    let minTemp: Double?
    let avgTemp: Double?
    
    enum CodingKeys: String, CodingKey {
        case date = "aggregation_date"
        case minTemp = "minimum_temperature"
        case maxTemp = "maximum_temperature"
        case avgTemp = "average_temperature"
        
    }
    
    init(from decoder: Decoder) throws{
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = UUID().uuidString
        date = try values.decodeIfPresent(String.self, forKey: .date)
        maxTemp = try values.decodeIfPresent(Double.self, forKey: .maxTemp)
        minTemp = try values.decodeIfPresent(Double.self, forKey: .minTemp)
        avgTemp = try values.decodeIfPresent(Double.self, forKey: .avgTemp)

        
    }
    
}

protocol Aggregation{
    var id: String? {get}
    var date:String? {get}
    var minTemp:Double? {get}
    var maxTemp:Double? {get}
    var avgTemp:Double? {get}
}
