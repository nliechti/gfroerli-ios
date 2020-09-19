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
            VStack{
                SearchBar(searchText: $searchText, isSearching: $isSearching)
                switch loadingState{
                case .loading:
                    LoadingView()
                case .loaded:
                    List{
                        ForEach(sensorsVm.sensorArray.filter({ "\($0.device_name!)".localizedCaseInsensitiveContains(searchText) || searchText.isEmpty })){ sensor in
                            NavigationLink(destination: SensorOverView(sensor: sensor),tag: String(sensor.id!), selection: $id, label: {Text(sensor.device_name!)})
                            
                        }
                    }.listStyle(InsetListStyle())
                    Spacer()

                case .error:
                    ErrorView()
                }
                    

                                    
                
            }.navigationTitle("All Sensors")
        }
    }
}

struct AllSensorView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            AllSensorView(sensorsVm: SensorListViewModel(), loadingState: .constant(.loaded))
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro Max"))
                .previewDisplayName("iPhone 11 Pro Max")
            AllSensorView(sensorsVm: SensorListViewModel(), loadingState: .constant(.loaded))
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
                .previewDisplayName("iPhone 11 Pro")
            AllSensorView(sensorsVm: SensorListViewModel(), loadingState: .constant(.loaded))
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .previewDisplayName("iPhone SE")
        }
        Group{
            AllSensorView(sensorsVm: SensorListViewModel(), loadingState: .constant(.loaded))
                .preferredColorScheme(.dark)
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro Max"))
                .previewDisplayName("iPhone 11 Pro Max Dark")
            AllSensorView(sensorsVm: SensorListViewModel(), loadingState: .constant(.loaded))
                .preferredColorScheme(.dark)
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
                .previewDisplayName("iPhone 11 Pro Dark")
            AllSensorView(sensorsVm: SensorListViewModel(), loadingState: .constant(.loaded))                .preferredColorScheme(.dark)
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .previewDisplayName("iPhone SE Dark")
                
        }
    }
}
