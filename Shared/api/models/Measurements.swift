/*
Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import Combine

struct Measurement : Codable {
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

class measurementsViewModel: ObservableObject{
    let didChange = PassthroughSubject<Void, Never>()
    
    @Published var measurementsArrayDay = [Measurement]() { didSet { didChange.send(())}}
    @Published var measurementsArrayWeek = [Measurement]() { didSet { didChange.send(())}}
    @Published var measurementsArrayMonth = [Measurement]() { didSet { didChange.send(())}}
    init() {
        loadMeasurementDataDay()
        loadMeasurementDataWeek()
        loadMeasurementDataMonth()
    }

    func loadMeasurementDataDay() {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-ddThh:mm:ss"
        let now = df.string(from: Calendar.current.date(byAdding: .day, value:-1, to:Date())!)
        print(now)
        var request = URLRequest(url: URL(string: "https://watertemp-api.coredump.ch/api/measurements?id=1&created_after=\(now)")!)
        var request2 = URLRequest(url: URL(string: "http://10.99.0.57:3000/api/measurements?id=1&created_after=\(now)")!)

        request.setValue("Bearer XTZA6H0Hg2f02bzVefmVlr8fIJMy2FGCJ0LlDlejj2Pi0i1JvZiL0Ycv1t6JoZzD", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            do {
                guard let data = data else {return}
                
                let jsonDecoder = JSONDecoder()
                var measurements = try jsonDecoder.decode([Measurement].self, from: data)
                //measurements.removeSubrange(10..<measurements.count)
                measurements.sort(by: {$0.created_at! < $1.created_at!})
                self.measurementsArrayDay = measurements
            } catch let error {
                print(error)
            }
        }).resume()
    }
    func loadMeasurementDataMonth() {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-ddThh:mm:ss"
        let now = df.string(from: Calendar.current.date(byAdding: .month, value:-1, to:Date())!)
        print(now)
        var request = URLRequest(url: URL(string: "https://watertemp-api.coredump.ch/api/measurements?id=1&created_after=\(now)")!)
        var request2 = URLRequest(url: URL(string: "http://10.99.0.57:3000/api/measurements?id=1&created_after=\(now)")!)

        request.setValue("Bearer XTZA6H0Hg2f02bzVefmVlr8fIJMy2FGCJ0LlDlejj2Pi0i1JvZiL0Ycv1t6JoZzD", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            do {
                guard let data = data else {return}
                
                let jsonDecoder = JSONDecoder()
                var measurements = try jsonDecoder.decode([Measurement].self, from: data)
                //measurements.removeSubrange(10..<measurements.count)
                measurements.sort(by: {$0.created_at! < $1.created_at!})
                self.measurementsArrayMonth = measurements
            } catch let error {
                print(error)
            }
        }).resume()
    }
    func loadMeasurementDataWeek() {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-ddThh:mm:ss"
        let now = df.string(from: Calendar.current.date(byAdding: .day, value:-7, to:Date())!)
        print(now)
        var request = URLRequest(url: URL(string: "https://watertemp-api.coredump.ch/api/measurements?id=1&created_after=\(now)")!)
        var request2 = URLRequest(url: URL(string: "http://10.99.0.57:3000/api/measurements?id=1&created_after=\(now)")!)

        request.setValue("Bearer XTZA6H0Hg2f02bzVefmVlr8fIJMy2FGCJ0LlDlejj2Pi0i1JvZiL0Ycv1t6JoZzD", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            do {
                guard let data = data else {return}
                
                let jsonDecoder = JSONDecoder()
                var measurements = try jsonDecoder.decode([Measurement].self, from: data)
                //measurements.removeSubrange(10..<measurements.count)
                measurements.sort(by: {$0.created_at! < $1.created_at!})
                self.measurementsArrayWeek = measurements
            } catch let error {
                print(error)
            }
        }).resume()
    }
}


let measurement1 = Measurement(id: 1, temperature: 22.0022, custom_attributes: "", sensor_id: 2, created_at: "created Date", updated_at: "updatedDate")
