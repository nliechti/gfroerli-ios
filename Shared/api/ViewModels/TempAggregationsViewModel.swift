//
//  MeasurementViewModel.swift
//  Gfror.li
//
//  Created by Marc Kramer on 19.09.20.
//

import Foundation
import Combine

class MonthlyAggregationsViewModel: LoadableObject{
    
    typealias Output = [DailyAggregation]

    @Published var dataMonth = [DailyAggregation]() { didSet { didChange.send(())}}
    @Published private(set) var state = LoadingState<Output>.idle

    let didChange = PassthroughSubject<Void, Never>()
    var id: Int = 0
    var date: Date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: Date()))!{
        didSet {
            load()
        }
    }
    public func load() {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let start = df.string(from: date.addingTimeInterval(TimeInterval(-2592000)))
        let end = df.string(from:date)
        
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
                    self.dataMonth=aggregs.reversed()
                    self.state = .loaded(aggregs.reversed())
                    
                } else {
                    self.state = .failed
                }
                }catch{
                    self.state = .failed
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

