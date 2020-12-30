//
//  SensorOverView.swift
//  iOS
//
//  Created by Marc Kramer on 22.08.20.
//

import SwiftUI

struct SensorOverView: View {
    
    @StateObject var sensorVM = SingleSensorViewModel()
    var id : Int
    @State var isFav = false
    @State var favorites  = UserDefaults(suiteName: "group.ch.gfroerli")?.array(forKey: "favoritesIDs") as? [Int] ?? [Int]()
    @State var loadingState: loadingState = .loading

    
    var body: some View {
        VStack{
        switch loadingState {
        case .loading:
            LoadingView()
                .background(Color.systemGroupedBackground.ignoresSafeArea())

        case .loaded:
            ScrollView{
                VStack{
                    SensorOverviewLastMeasurementView(sensor: sensorVM.sensor!)
                        .fixedSize(horizontal: false, vertical: true)
                        .background(Color.secondarySystemGroupedBackground)
                        .cornerRadius(15)
                        .shadow(radius: 1) 
                        .padding(.bottom)
                        .padding(.horizontal)
                    SensorOverViewGraph(sensorID: sensorVM.sensor!.id!)
                        .frame(minHeight: 400)
                        .background(Color.secondarySystemGroupedBackground)
                        .cornerRadius(15)
                        .shadow(radius: 1)
                        .padding(.bottom)
                        .padding(.horizontal)
                    SensorOverviewMap(inSensor: sensorVM.sensor!)
                        .frame(minHeight: 400)
                        .background(Color.secondarySystemGroupedBackground)
                        .cornerRadius(15)
                        .shadow(radius: 1)
                        .padding(.bottom)
                        .padding(.horizontal)
                    SensorOverviewSponsorView(sensor: sensorVM.sensor!)
                        .fixedSize(horizontal: false, vertical: true)
                        .background(Color.secondarySystemGroupedBackground)
                        .cornerRadius(15)
                        .shadow(radius: 1)
                        .padding(.horizontal)
                    
                }
                .padding(.vertical)
                .background(Color.systemGroupedBackground.ignoresSafeArea())
                .navigationTitle(loadingState == .loaded ? sensorVM.sensor!.device_name : "")
                .navigationBarItems(trailing:
                                        HStack{
                                            Button {
                                                loadingState = .loading
                                                load()
                                            } label: {
                                                Image(systemName:"arrow.triangle.2.circlepath")
                                                    
                                            }
                                        Button {
                                            isFav ? removeFav() : makeFav()
                                            UserDefaults(suiteName: "group.ch.gfroerli")?.set(favorites, forKey: "favoritesIDs")
                                        } label: {
                                            Image(systemName: isFav ? "star.fill" : "star")
                                                .foregroundColor(isFav ? .yellow : .none)
                                        }})
                                        
            }
            
        case .error:
            ErrorView().background(Color.systemGroupedBackground.ignoresSafeArea())
        }
        
        }.background(Color.systemGroupedBackground.ignoresSafeArea()).onAppear(perform: {
            load()
        })
        

        
    }
    func load(){
        loadingState = .loading
        sensorVM.getSensor(id: id) {(result) in
            switch result {
            case .success(let str):
                
                favorites  = UserDefaults(suiteName: "group.ch.gfroerli")?.array(forKey: "favoritesIDs") as? [Int] ?? [Int]()
                isFav = favorites.contains(sensorVM.sensor!.id!)
                loadingState = .loaded
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
    }
    
    func makeFav(){
        favorites.append(sensorVM.sensor!.id!)
        isFav = true
        UserDefaults(suiteName: "group.ch.gfroerli")?.set(favorites, forKey: "favoritesIDs")
        
    }
    func removeFav(){
        favorites.removeFirst(sensorVM.sensor!.id!)
        isFav=false
        UserDefaults(suiteName: "group.ch.gfroerli")?.set(favorites, forKey: "favoritesIDs")
    }
    
    
}

struct SensorOverView_Previews: PreviewProvider {
    static var previews: some View {
        SensorOverView(id: 1).makePreViewModifier()
    }
}
