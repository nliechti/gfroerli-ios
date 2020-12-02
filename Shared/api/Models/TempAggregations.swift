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
    

}

struct DailyAggregation : Codable, Identifiable, Aggregation{
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
