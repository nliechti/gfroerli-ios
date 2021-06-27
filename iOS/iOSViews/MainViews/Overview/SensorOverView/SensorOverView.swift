//
//  SensorOverView.swift
//  iOS
//
//  Created by Marc Kramer on 22.08.20.
//

import SwiftUI

struct SensorOverView: View {
    
    @StateObject var sensorVM = SingleSensorViewModel()
    @State var isFav = false
    @State var favorites = [Int]()
    
    var sensorID: Int
    var sensorName: String
    
    var body: some View {
        VStack {
            ScrollView {
                switch sensorVM.loadingState {
                case .loaded, .loading:
                    
                    VStack {
                        SensorOverviewLastMeasurementView(sensorVM: sensorVM)
                            .boxStyle()
                        
                        SensorOverViewGraph(sensorID: sensorID)
                            .boxStyle()
                            .dynamicTypeSize(.xSmall ... .large)
                        
                        SensorOverviewMap(sensorVM: sensorVM)
                            .boxStyle()
                        
                        SensorOverviewSponsorView(sensorID: sensorID)
                            .boxStyle()
                    }
                    .padding(.vertical)
                    .onAppear(perform: {
                        async { await sensorVM.load(sensorId: sensorID)}
                        setFavs()
                        isFav = favorites.contains(sensorID)
                    })
                    
                case .failed:
                    HStack {
                        Spacer()
                        VStack {
                            Spacer()
                            Text("Loading Location failed. Reason:").foregroundColor(.gray)
                            Text(sensorVM.errorMsg).foregroundColor(.gray)
                            Button("Try again") {
                                async { await sensorVM.load(sensorId: sensorID)}
                            }
                            .buttonStyle(.bordered)
                            Spacer()
                        }
                        Spacer()
                    }
                    .multilineTextAlignment(.center)
                    .padding()
                    .boxStyle()
                    .padding(.vertical)
                }// switch end
            }
        }
        .navigationBarTitle(sensorName, displayMode: .inline)
        .background(Color.systemGroupedBackground.ignoresSafeArea())
        .navigationBarItems(trailing:
                                Button {
            isFav ? removeFav() : makeFav()
        } label: {
            Image(systemName: isFav ? "star.fill" : "star")
                .foregroundColor(isFav ? .yellow : .none)
                .imageScale(.large)
        })
    }
    
    /// adds sensorID to userDefaults
    func makeFav() {
        favorites.append(sensorID)
        isFav = true
        UserDefaults(suiteName: "group.ch.gfroerli")?.set(favorites, forKey: "favoritesIDs")
    }
    /// removes sensorID from userDefaults
    func removeFav() {
        favorites.removeFirst(sensorID)
        isFav=false
        UserDefaults(suiteName: "group.ch.gfroerli")?.set(favorites, forKey: "favoritesIDs")
    }
    /// loads favs from UserDefaults
    func setFavs() {
        favorites  = UserDefaults(suiteName: "group.ch.gfroerli")?.array(forKey: "favoritesIDs") as? [Int] ?? [Int]()
    }
}

struct SensorOverView_Previews: PreviewProvider {
    static var previews: some View {
        SensorOverView(sensorID: 1, sensorName: "Test")
            .environment(\.sizeCategory, .extraExtraExtraLarge)
            .makePreViewModifier()
    }
}
