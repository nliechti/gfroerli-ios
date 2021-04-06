//
//  SponsorsViewModel.swift
//  Gfror.li
//
//  Created by Marc Kramer on 05.10.20.
//

import Foundation
import Combine

class SponsorListViewModel: LoadableObject {
    typealias Output = Sponsor
    
    @Published private(set) var state = LoadingState<Output>.idle
    @Published var sponsor: Sponsor! { didSet { didChange.send(())}}
    
    let didChange = PassthroughSubject<Void, Never>()
    var id: Int = 0
    
    func load() {
        
        var url = URLRequest(url: URL(string: "https://watertemp-api.coredump.ch//api/mobile_app/sensors/\(id)/sponsor")!)
        url.setValue("Bearer XTZA6H0Hg2f02bzVefmVlr8fIJMy2FGCJ0LlDlejj2Pi0i1JvZiL0Ycv1t6JoZzD", forHTTPHeaderField: "Authorization")
        url.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                do {
                    if let data = data {
                        let jsonDecoder = JSONDecoder()
                        let sponsor = try jsonDecoder.decode(Sponsor.self, from: data)
                        self.sponsor = sponsor
                        self.state = .loaded(sponsor)
                    }else{
                        self.state = .failed
                    }
                }catch{
                    print(error.localizedDescription)
                    self.state = .failed
                }
            }
        }.resume()
    }
}

protocol LoadableObject: ObservableObject {
    associatedtype Output
    var state: LoadingState<Output> { get }
    func load()
}

enum LoadingState<Value> {
    case idle
    case loading
    case failed
    case loaded(Value)
}
