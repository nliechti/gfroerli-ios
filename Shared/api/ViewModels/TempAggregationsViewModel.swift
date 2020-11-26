//
//  MeasurementViewModel.swift
//  Gfror.li
//
//  Created by Marc Kramer on 19.09.20.
//

import Foundation
import Combine

class TempAggregationsViewModel: ObservableObject{
    let didChange = PassthroughSubject<Void, Never>()
    
    @Published var dataDay = [HourlyAggregation]() { didSet { didChange.send(())}}
    @Published var measuringListWeek = [DailyAggregation]() { didSet { didChange.send(())}}
    @Published var measuringListMonth = [DailyAggregation]() { didSet { didChange.send(())}}
    
    
    public func loadAggregationsDay(sensorID: Int, completion: @escaping (Result<String, NetworkError>) -> Void) {
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let start = df.string(from: Calendar.current.date(byAdding: .day, value:-1, to:Date())!)
        let end = df.string(from: Calendar.current.date(byAdding: .day, value:-1, to:Date())!)
        var url = URLRequest(url: URL(string: "https://watertemp-api.coredump.ch/api/mobile_app/sensors/\(sensorID)/hourly_temperatures?from=\(start)&to=\(end)&limit=25")!)
        
        url.setValue("Bearer XTZA6H0Hg2f02bzVefmVlr8fIJMy2FGCJ0LlDlejj2Pi0i1JvZiL0Ycv1t6JoZzD", forHTTPHeaderField: "Authorization")
        url.httpMethod = "GET"
        print(url)
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                do {
                if let data = data {
                    // success: convert to  Measuring, and set according List
                    let jsonDecoder = JSONDecoder()
                    let aggregs = try jsonDecoder.decode([HourlyAggregation].self, from: data)
                    self.dataDay = aggregs
                    print("DATAAAAAAAAAAAAAAAAAAAA")
                    print(self.dataDay)
                    completion(.success("Measurings successfuly loaded!"))
                } else if error != nil {
                    // network failures
                    completion(.failure(.requestFailed))
                } else {
                    // other cases
                    completion(.failure(.unknown))
                }
                    // decoding failed
                }catch{
                    completion(.failure(.decodeFailed))
                }
            }
        }.resume()
    }
    
    
    
    func createGoodDate(string: String)->Date{
        var newDate = string
        newDate.removeLast(5)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date = dateFormatter.date(from:newDate)!
        return date
    }
}
