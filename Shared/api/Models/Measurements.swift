/*
Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import Combine

struct Measuring: Codable ,Identifiable{
    init(id: Int?, temperature: Double?, custom_attributes: String?, sensor_id: Int?, created_at: String?, updated_at: String?) {
        self.id = id
        self.temperature = temperature
        self.custom_attributes = custom_attributes
        self.sensor_id = sensor_id
        self.created_at = created_at
        self.updated_at = updated_at
    }
    
    let id : Int?
    let temperature : Double?
    let custom_attributes : String?
    let sensor_id : Int?
    let created_at : String?
    let updated_at : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case temperature = "temperature"
        case custom_attributes = "custom_attributes"
        case sensor_id = "sensor_id"
        case created_at = "created_at"
        case updated_at = "updated_at"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        temperature = try Double(values.decodeIfPresent(String.self, forKey: .temperature)!)
        custom_attributes = try values.decodeIfPresent(String.self, forKey: .custom_attributes)
        sensor_id = try values.decodeIfPresent(Int.self, forKey: .sensor_id)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
    }

}




let measurement1 = Measuring(id: 1, temperature: 0.0, custom_attributes: "", sensor_id: 2, created_at: createStringFromDate(date: Date()), updated_at: createStringFromDate(date: Date()))
let measurement2 = Measuring(id: 1, temperature: 5.0, custom_attributes: "", sensor_id: 2, created_at: createStringFromDate(date: Date()), updated_at: createStringFromDate(date: Date()))
let measurement3 = Measuring(id: 1, temperature: 10.0, custom_attributes: "", sensor_id: 2, created_at: createStringFromDate(date: Date()), updated_at: createStringFromDate(date: Date()))
let measurement4 = Measuring(id: 1, temperature: 15.0, custom_attributes: "", sensor_id: 2, created_at: createStringFromDate(date: Date()), updated_at: createStringFromDate(date: Date()))
let measurement5 = Measuring(id: 1, temperature: 20.0, custom_attributes: "", sensor_id: 2, created_at: createStringFromDate(date: Date()), updated_at: createStringFromDate(date: Date()))
let measurement6 = Measuring(id: 1, temperature: 25.0, custom_attributes: "", sensor_id: 2, created_at: createStringFromDate(date: Date()), updated_at: createStringFromDate(date: Date()))
let measurement7 = Measuring(id: 1, temperature: 30.0, custom_attributes: "", sensor_id: 2, created_at: createStringFromDate(date: Date()), updated_at: createStringFromDate(date: Date()))
let measurement8 = Measuring(id: 1, temperature: 0.0, custom_attributes: "", sensor_id: 2, created_at: createStringFromDate(date: Date()), updated_at: createStringFromDate(date: Date()))
let measurement9 = Measuring(id: 1, temperature: 15.0, custom_attributes: "", sensor_id: 2, created_at: createStringFromDate(date: Date()), updated_at: createStringFromDate(date: Date()))
let measurement10 = Measuring(id: 1, temperature: 25.0, custom_attributes: "", sensor_id: 2, created_at: createStringFromDate(date: Date()), updated_at: createStringFromDate(date: Date()))

let testmeasVM = MeasuringListViewModel(measurements: [measurement1,measurement2,measurement3,measurement4,measurement5,measurement6,measurement7,measurement8,measurement9,measurement10])
