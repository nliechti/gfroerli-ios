//
//  HourlyAggregationViewModel.swift
//  Gfror.li
//
//  Created by Marc on 28.01.21.
//

import Foundation
import Combine

class HourlyAggregationsViewModel: LoadableObject{
    
    typealias Output = [HourlyAggregation?]

    @Published var dataDay = [HourlyAggregation?]() { didSet { didChange.send(())}}
    @Published private(set) var state = LoadingState<Output>.idle
    var date: Date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: Date()))!{
        didSet {
            load()
        }
    }
    let didChange = PassthroughSubject<Void, Never>()
    var id: Int = 0
        
    public func load() {
        print(date)
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let start = df.string(from: date)
        let end = df.string(from: date)
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
                    
                    var array = [HourlyAggregation?].init(repeating: nil, count: 24)
                    for agg in aggregs{
                        array[agg.hour!] = agg
                    }
                   
                    
                    self.dataDay = array
                    self.state = .loaded(array)
                } else {
                    self.state = .failed
                }
                }catch{
                    self.state = .failed

                }
            }
        }.resume()
    }
    
    
}
