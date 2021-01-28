//
//  LakeOverView.swift
//  iOS
//
//  Created by Marc Kramer on 22.08.20.
//

import SwiftUI
import MapKit

struct LakeOverView: View {
    var lake : Lake
    @ObservedObject var sensors : SensorListViewModel
    @Binding var loadingState: loadingState
    var body: some View {
    
        VStack(alignment: .leading,spacing: 0) {
                    topMap(lake: lake, region: lake.region, sensors: sensors)
                             .navigationBarTitle(lake.name)
                    switch loadingState{
                    case .loading:
                        LoadingView().background(Color.systemGroupedBackground.ignoresSafeArea())
                    case .loaded:
                        ScrollView(showsIndicators: true){
                            HStack{
                                Text("Locations").font(.title).bold().padding([.top,.horizontal])
                                Spacer()
                            }
                        ForEach(sensors.sensorArray){ sensor in
                            if(lake.sensors.contains(String(sensor.id))){
                                SensorListItem(sensor: sensor).padding(.horizontal)
                            }
                        }
                        Spacer()
                        }.background(Color.systemGroupedBackground.ignoresSafeArea())
                        
                    case .error:
                        ErrorView().background(Color.systemGroupedBackground.ignoresSafeArea())
                    }
                }.padding()
                .background(Color.systemGroupedBackground.ignoresSafeArea())
            }
    
}

struct LakeOverView_Previews: PreviewProvider {
    static var previews: some View {
        LakeOverView(lake: lakeOfZurich, sensors: testSensorVM, loadingState: .constant(.loaded)).makePreViewModifier()
    }
}

struct topMap: View{
    var lake: Lake
    @State var region: MKCoordinateRegion
    @ObservedObject var sensors: SensorListViewModel
    var body: some View{
        
        Map (coordinateRegion: $region,
             annotationItems: sensors.sensorArray, annotationContent: { pin in
            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: pin.latitude!, longitude: pin.longitude!), content: {
                
                NavigationLink(
                    destination: /*@START_MENU_TOKEN@*/Text("Destination")/*@END_MENU_TOKEN@*/,
                    label: {
                        Text(String(format: "%.1f", pin.latestTemp!)+"°")
                            .minimumScaleFactor(0.3)
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .frame(width: 40, height: 40)
                            .background(Color.blue)
                            .cornerRadius(90)
                    })
            })
            
             }).disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/3.5, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        
        .onAppear(perform: {
            region = MKCoordinateRegion(center: lake.region.center, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta:0.2))
            
        })
        
        
    }
    
}
