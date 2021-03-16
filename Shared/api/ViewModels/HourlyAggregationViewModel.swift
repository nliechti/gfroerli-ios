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

    let didChange = PassthroughSubject<Void, Never>()
    var id: Int = 0
        
    public func load() {
        
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
                        array[agg.hour!] = agg
                    }
                   
                    array.rotateLeft(positions: hour+1)
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
