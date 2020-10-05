//
//  MeasurementViewModel.swift
//  Gfror.li
//
//  Created by Marc Kramer on 19.09.20.
//

import Foundation
import Combine

class MeasuringListViewModel: ObservableObject{
    let didChange = PassthroughSubject<Void, Never>()
    
    @Published var measuringListDay = [Measuring]() { didSet { didChange.send(())}}
    @Published var measuringListWeek = [Measuring]() { didSet { didChange.send(())}}
    @Published var measuringListMonth = [Measuring]() { didSet { didChange.send(())}}
    
    init() {
    }

    init(measurements: [Measuring]) {
        measuringListDay = measurements
        measuringListWeek = measurements
        measuringListMonth = measurements
    }
    func loadMeasurings(sensorID: Int, timeFrame: TimeFrame, completion: @escaping (Result<String, NetworkError>) -> Void) {
        
        var days = 0
        switch timeFrame {
        case .day:
             days = 1
        case .week:
             days = 7
        case .month:
             days = 30
        }
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-ddThh:mm:ss"
        let now = df.string(from: Calendar.current.date(byAdding: .day, value:-(days), to:Date())!)
        var url = URLRequest(url: URL(string: "https://watertemp-api.coredump.ch/api/measurements?id=\(sensorID)&created_after=\(now)")!)
        
        url.setValue("Bearer XTZA6H0Hg2f02bzVefmVlr8fIJMy2FGCJ0LlDlejj2Pi0i1JvZiL0Ycv1t6JoZzD", forHTTPHeaderField: "Authorization")
        url.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                do {
                if let data = data {
                    // success: convert to  Measuring, and set according List
                    let jsonDecoder = JSONDecoder()
                    let measurings = try jsonDecoder.decode([Measuring].self, from: data)
                    switch timeFrame {
                    case .day:
                        self.measuringListDay = measurings
                    case .week:
                        self.measuringListWeek = measurings
                    case .month:
                        self.measuringListMonth = measurings
                    }
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
    
    
    func makeDailyAvg(data: [Measuring])->[Double]{
        var plotData = [Double]()
        let maxDate = createGoodDate(string: data[0].created_at!)
        let minDate = createGoodDate(string: data[data.count-1].created_at!)
        let dayCount = Calendar.current.dateComponents([.day], from: maxDate, to: minDate).day!
        
        for day in 0..<dayCount{
            var meas = [Double]()
            for measuring in 0..<data.count{
                if Calendar.current.isDate(createGoodDate(string: data[measuring].created_at!), inSameDayAs: Calendar.current.date(byAdding: .day, value: day*1, to: maxDate)!){
                    meas.append(data[measuring].temperature!)
                }
            }
            var total = 0.0
            for double in meas{
                total+=double
            }
            let avg = total/Double(meas.count)
            plotData.append(avg)
        }
        return plotData
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
