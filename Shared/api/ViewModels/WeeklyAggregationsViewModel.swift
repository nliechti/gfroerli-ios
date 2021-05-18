//
//  WeeklyAggregationsViewModel.swift
//  Gfror.li
//
//  Created by Marc on 28.01.21.
//

import Foundation
import Foundation
import Combine

class WeeklyAggregationsViewModel: LoadableObject{
    
    typealias Output = [DailyAggregation]

    @Published var dataWeek = [DailyAggregation]() { didSet { didChange.send(())}}
    @Published private(set) var state = LoadingState<Output>.idle

    let didChange = PassthroughSubject<Void, Never>()
    var id: Int = 0
    var date: Date = Calendar.current.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: Date()).date!{
        didSet {
            load()
        }
    }
    
    public func load() {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let start = df.string(from: date)
        let end = df.string(from:Calendar.current.date(byAdding: .day, value: 6, to: date)!)
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
                    self.dataWeek=aggregs.reversed()
                    self.state = .loaded(aggregs.reversed())
                }else {
                    self.state = .failed
                }
                }catch{
                    self.state = .failed
                }
            }
        }.resume()
    }
    
    
}
