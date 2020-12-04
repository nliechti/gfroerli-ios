//
//  OverView.swift
//  iOS
//
//  Created by Marc Kramer on 22.08.20.
//

import SwiftUI
import MapKit
struct OverView: View {
    @ObservedObject var sensors : SensorListViewModel
    @Binding var loadingState : loadingState
    var featuredSensorID = 1
    
    var body: some View {
        NavigationView{
            ScrollView(.vertical){
                VStack(alignment: .leading, spacing: 0){
                    
                    Text("Featured")
                        .font(.title)
                        .bold()
                        .padding(.horizontal)
                    
                    switch loadingState{
                    case .loading:
                        LoadingView().frame(width: UIScreen.main.bounds.width, height: 250)
                    case .loaded:
                        NavigationLink(
                            destination: SensorOverView(id: featuredSensorID),
                            label: {
                                SensorScrollItem(sensor: sensors.sensorArray.first(where: {$0.id == featuredSensorID})!)
                            }).buttonStyle(PlainButtonStyle())
                    case .error:
                        ErrorView().frame(width: UIScreen.main.bounds.width, height: 250)
                    }
                    Text("Lakes")
                        .font(.title)
                        .bold()
                        .padding([.horizontal,.top])
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing:0){
                            ForEach(lakes){ lake in
                                NavigationLink(
                                    destination: LakeOverView(lake: lake, sensors: sensors, loadingState: $loadingState),
                                    label: {
                                        ScrollItem(lake:lake)
                                    }).buttonStyle(PlainButtonStyle())
                                    .padding()
                            }
                        }
                    }
                }
                Spacer()
            }.background(Color.systemGroupedBackground.ignoresSafeArea())
            .navigationTitle("Gfrör.li")
            
        }
        
    }
}

struct OverView_Previews: PreviewProvider {
    static var previews: some View {
        OverView(sensors: testSensorVM, loadingState: .constant(.loading)).makePreViewModifier()
    }
}
