//
//  SingleSensorViewModel.swift
//  Gfror.li
//
//  Created by Marc Kramer on 19.09.20.
//

import Foundation
import Combine
import SwiftUI

class SingleSensorViewModel: ObservableObject {

    @Published var sensor: Sensor? = nil { didSet { didChange.send(())}}
    @Published var loadingState: NewLoadingState = .loading { didSet { didChange.send(())}}
    @Published var errorMsg: LocalizedStringKey = "" { didSet { didChange.send(())}}
    
    let didChange = PassthroughSubject<Void, Never>()

    /// Loads a single sensor from backend and assigns it to VM
    /// - Parameter sensorID: Integer describing the sensor ID
    func load(sensorId: Int) async {
        
        loadingState = .loading
        
        let url = URL(string: "https://watertemp-api.coredump.ch//api/mobile_app/sensors/\(sensorId)")!
        var request = URLRequest(url: url)
        request.setValue(BearerToken.token, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        do {
            // Test for network connection
            if !Reachability.isConnectedToNetwork() {
                throw LoadingErrors.noConnectionError
            }
            // send request
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // check response status code
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw LoadingErrors.fetchError
            }
            // try to decode
            guard let decodedSponsor = try? JSONDecoder().decode(Sensor.self, from: data) else {
                throw LoadingErrors.decodeError
            }
            // update view model
            sensor = decodedSponsor
            loadingState = .loaded
            
        } catch {
            switch error {
            case LoadingErrors.decodeError:
                errorMsg = "Could not decode Sponsor."
            case LoadingErrors.fetchError:
                errorMsg = "Invalid server response."
            case LoadingErrors.noConnectionError:
                errorMsg = "No internet connection."
            default:
                errorMsg = LocalizedStringKey( error.localizedDescription )
            }
            loadingState = .failed
        }
    }

}
