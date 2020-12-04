//
//  AllSensorView.swift
//  iOS
//
//  Created by Marc Kramer on 11.09.20.
//

import SwiftUI

struct AllSensorView: View {
    @ObservedObject var sensorsVm : SensorListViewModel
    @Binding var loadingState: loadingState
    @State var id : String?
    @State var searchText = ""
    @State var isSearching = false
    var body: some View {
        NavigationView{
            VStack(spacing:0){
                SearchBar(searchText: $searchText, isSearching: $isSearching)
                
                switch loadingState{
                case .loading:
                    LoadingView()
                    
                case .loaded:
                    if !sensorsVm.sensorArray.isEmpty {
                        List{
                            ForEach(sensorsVm.sensorArray.filter({ "\($0.device_name!)".localizedCaseInsensitiveContains(searchText) || searchText.isEmpty })){ sensor in
                                NavigationLink(destination: SensorOverView(id: sensor.id!),tag: String(sensor.id!), selection: $id, label: {Text(sensor.device_name!)})
                                
                            }
                        }.listStyle(InsetGroupedListStyle())
                        
                    } else {
                        VStack{
                            Spacer()
                            Text("No Sensors").font(.largeTitle).foregroundColor(.gray)
                            Spacer()
                        }
                    }
                    Spacer()
                    
                case .error:
                    ErrorView()
                }
            }.background(Color.systemGroupedBackground.ignoresSafeArea())
            .navigationTitle("All Sensors")
        }
    }
}

struct AllSensorView_Previews: PreviewProvider {
    static var previews: some View {
        AllSensorView(sensorsVm: SensorListViewModel(), loadingState: .constant(.loaded)).makePreViewModifier()
    }
}
