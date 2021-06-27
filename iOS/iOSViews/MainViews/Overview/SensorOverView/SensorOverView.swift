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
    @State var favorites  = UserDefaults(suiteName: "group.ch.gfroerli")?.array(forKey: "favoritesIDs") as? [Int] ?? [Int]()
    
    var id: Int
    var sensorName: String
    
    var body: some View {
        VStack {
            ScrollView {
                switch sensorVM.loadingState {
                case .loaded, .loading:
                    
                    VStack {
                        SensorOverviewLastMeasurementView(VM: sensorVM)
                            .boxStyle()
                        
                        SensorOverViewGraph(sensorID: id)
                         .boxStyle()
                         .dynamicTypeSize(.xSmall ... .large)
                         
                        SensorOverviewMap(sensorVM: sensorVM)
                            .boxStyle()
                        
                        SensorOverviewSponsorView(sensorID: id)
                            .boxStyle()
                    }
                    .padding(.vertical)
                    .onAppear(perform: {
                        async { await sensorVM.load(sensorId: id)}
                        
                        favorites  = UserDefaults(suiteName: "group.ch.gfroerli")?.array(forKey: "favoritesIDs") as? [Int] ?? [Int]()
                        isFav = favorites.contains(id)
                    })
                    
                case .failed:
                    HStack {
                        Spacer()
                        VStack {
                            Spacer()
                            Text("Loading Location failed. Reason:").foregroundColor(.gray)
                            Text(sensorVM.errorMsg).foregroundColor(.gray)
                            Button("Try again") {
                                async { await sensorVM.load(sensorId: id)}
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
                UserDefaults(suiteName: "group.ch.gfroerli")?.set(favorites, forKey: "favoritesIDs")
            } label: {
                Image(systemName: isFav ? "star.fill" : "star")
                    .foregroundColor(isFav ? .yellow : .none)
                    .imageScale(.large)
            })
    }
    
    func makeFav() {
        favorites.append(id)
        isFav = true
        UserDefaults(suiteName: "group.ch.gfroerli")?.set(favorites, forKey: "favoritesIDs")
    }
    
    func removeFav() {
        favorites.removeFirst(id)
        isFav=false
        UserDefaults(suiteName: "group.ch.gfroerli")?.set(favorites, forKey: "favoritesIDs")
    }
}

struct SensorOverView_Previews: PreviewProvider {
    static var previews: some View {
        SensorOverView(id: 1, sensorName: "Test").environment(\.sizeCategory, .extraExtraExtraLarge).makePreViewModifier()
    }
}
