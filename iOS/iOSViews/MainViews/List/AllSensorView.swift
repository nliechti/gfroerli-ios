//
//  AllSensorView.swift
//  iOS
//
//  Created by Marc Kramer on 11.09.20.
//

import SwiftUI

struct AllSensorView: View {
    @ObservedObject var sensorsVm : SensorViewModel
    @State var id : String?
    @State var searchText = ""
    @State var isSearching = false
    var body: some View {
        NavigationView{
            VStack{
                
                if sensorsVm.sensorArray.isEmpty{
                    ProgressView().progressViewStyle(CircularProgressViewStyle())
                }else{
                    SearchBar(searchText: $searchText, isSearching: $isSearching)

                    List{
                        ForEach(sensorsVm.sensorArray.filter({ "\($0.device_name!)".localizedCaseInsensitiveContains(searchText) || searchText.isEmpty })){ sensor in
                            NavigationLink(destination: SensorOverView(sensor: sensor),tag: String(sensor.id!), selection: $id, label: {Text(sensor.device_name!)})
                            
                        }
                    }.listStyle(InsetListStyle())
                    Spacer()
                }
                
            }.navigationTitle("All Sensors")
        }
    }
}

struct AllSensorView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            AllSensorView(sensorsVm: SensorViewModel())
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro Max"))
                .previewDisplayName("iPhone 11 Pro Max")
            AllSensorView(sensorsVm: SensorViewModel())
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
                .previewDisplayName("iPhone 11 Pro")
            AllSensorView(sensorsVm: SensorViewModel())
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .previewDisplayName("iPhone SE")
        }
        Group{
            AllSensorView(sensorsVm: SensorViewModel())
                .preferredColorScheme(.dark)
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro Max"))
                .previewDisplayName("iPhone 11 Pro Max Dark")
            AllSensorView(sensorsVm: SensorViewModel())
                .preferredColorScheme(.dark)
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
                .previewDisplayName("iPhone 11 Pro Dark")
            AllSensorView(sensorsVm: SensorViewModel())                .preferredColorScheme(.dark)
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .previewDisplayName("iPhone SE Dark")
                
        }
    }
}
