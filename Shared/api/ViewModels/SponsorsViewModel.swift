//
//  SponsorsViewModel.swift
//  Gfror.li
//
//  Created by Marc Kramer on 05.10.20.
//

import Foundation
import Combine
class SponsorListViewModel: ObservableObject {
    let didChange = PassthroughSubject<Void, Never>()
    
    @Published var sponsorArray = [Sponsor]() { didSet { didChange.send(())}}
    
    init() {
    }
    
    init(sponsors: [Sponsor]) {
        sponsorArray = sponsors
    }
    
    
    
    func getAllSponsors(completion: @escaping (Result<String, NetworkError>) -> Void) {
        
        var url = URLRequest(url: URL(string: "https://watertemp-api.coredump.ch/api/sponsors")!)
        url.setValue("Bearer XTZA6H0Hg2f02bzVefmVlr8fIJMy2FGCJ0LlDlejj2Pi0i1JvZiL0Ycv1t6JoZzD", forHTTPHeaderField: "Authorization")
        url.httpMethod = "GET"

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                do {
                if let data = data {
                    // success: convert to  Sensors
                    let jsonDecoder = JSONDecoder()
                    let sponsors = try jsonDecoder.decode([Sponsor].self, from: data)
                    self.sponsorArray = sponsors
                    print(sponsors)
                    completion(.success("Sponsors successfuly loaded!"))
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
}
