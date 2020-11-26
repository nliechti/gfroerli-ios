//
//  SensorOverviewSponsorView.swift
//  iOS
//
//  Created by Marc Kramer on 11.09.20.
//

import SwiftUI

struct SensorOverviewSponsorView: View {
    @StateObject var sponsorListVM = SponsorListViewModel()
    @State var loadingState : loadingState = .loading
    @State var sponsor : Sponsor?
    @Binding var sensor : Sensor
    var body: some View {
        VStack(alignment: .leading){
            Text("Sponsored by:").font(.title).bold()
            
            switch loadingState{
            case .loading:
                LoadingView()
            case .loaded:
                if sponsor != nil {
                    VStack{
                        HStack{
                        Text( sponsor!.name!).font(.largeTitle).bold()
                            Spacer()
                        }.padding(.bottom)
                        Text( sponsor!.description!)
                            Spacer()
                        }
                    }
                
            case .error:
                ErrorView()
            }
        }
        .padding()
        .onAppear(perform: {
            loadingState = .loading
            sponsorListVM.getAllSponsors{ (result) in
                switch result {
                case .success(let str):
                    loadingState = .loaded
                    sponsor = sponsorListVM.sponsorArray.first(where: {$0.id == sensor.id})
                case .failure(let error):
                    loadingState = .error
                    switch error {
                    case .badURL:
                        print("Bad URL")
                    case .requestFailed:
                        print("Network problems")
                    case.decodeFailed:
                        print("Decoding data failed")
                    case .unknown:
                        print("Unknown error")
                    }
                }
                
            }
        })
    }
}

struct SensorOverviewSponsorView_Previews: PreviewProvider {
    static var previews: some View {
        SensorOverviewSponsorView(sensor: Binding.constant(testSensor)).makePreViewModifier()
    }
}
