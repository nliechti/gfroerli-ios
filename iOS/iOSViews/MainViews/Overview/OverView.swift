//
//  OverView.swift
//  iOS
//
//  Created by Marc Kramer on 22.08.20.
//

import SwiftUI
import MapKit
struct OverView: View {
    @Binding var showDetail: Bool
    @Binding var pathComp: String?
    @ObservedObject var sensorsVM : SensorListViewModel
    var body: some View {
        NavigationView{
            ScrollView(.vertical){
                VStack(alignment: .leading, spacing: 0){
                    AsyncContentView(source: sensorsVM) { sensors in
                        TopTabView(sensors: sensors)
                    }
                    Text("Water Bodies")
                        .font(.title)
                        .bold()
                        .padding([.horizontal,.top])
                    ForEach(lakes){ lake in
                        NavigationLink(
                            destination: LakeOverView(lake: lake, sensorsVM: sensorsVM),
                            label: {
                                LakeListItem(lake: lake).shadow(radius: 1)
                            }).buttonStyle(PlainButtonStyle())
                            .padding()
                    }
                }
                Spacer()
            }
            .background(Color.systemGroupedBackground.ignoresSafeArea())
            .navigationTitle("Overview")
        }.sheet(isPresented: $showDetail, content: {
            NavigationView{
                SensorOverView(id:Int(pathComp!)!).navigationBarItems(leading: Button(action: {showDetail=false}, label: {Text("Close")}))
            }
        })
    }
}

struct TopTabView: View{
    @State var sensors : [Sensor]
    @State var newestSensor = testSensor1
    @State var randomSensor = testSensor1
    @State var latestSensor = testSensor1
    @State var newestRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: testSensor1.latitude!, longitude: testSensor1.longitude!), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    @State var latesRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: testSensor1.latitude!, longitude: testSensor1.longitude!), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    @State var randomRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: testSensor1.latitude!, longitude: testSensor1.longitude!), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    var body: some View{
        ScrollView(.horizontal,showsIndicators: false){
            HStack{
                NavigationLink(
                    destination: SensorOverView(id: newestSensor.id),
                    label: {
                        SensorScrollItem(region: $newestRegion, sensor: $newestSensor, title: "Newest")
                    }).buttonStyle(PlainButtonStyle())
                NavigationLink(
                    destination: SensorOverView(id: latestSensor.id),
                    label: {
                        SensorScrollItem(region: $latesRegion, sensor: $latestSensor, title: "Latest")
                    }).buttonStyle(PlainButtonStyle())
                NavigationLink(
                    destination: SensorOverView(id: randomSensor.id),
                    label: {
                        SensorScrollItem(region: $randomRegion, sensor: $randomSensor, title: "Random")
                    }).buttonStyle(PlainButtonStyle())
            }.padding(.horizontal)
        }
        .onAppear(perform: {
            newestSensor = sensors.sorted(by: {$0.id > $1.id}).first!
            latestSensor = sensors.sorted(by: {$0.lastTempTime! > $1.lastTempTime!}).first!
            randomSensor = sensors.randomElement()!
            newestRegion =  MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: newestSensor.latitude!, longitude: newestSensor.longitude!), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            latesRegion =  MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latestSensor.latitude!, longitude: latestSensor.longitude!), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            randomRegion =  MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: randomSensor.latitude!, longitude: randomSensor.longitude!), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            })
        
    }
}

struct OverView_Previews: PreviewProvider {
    static var previews: some View {
       /* OverView(showDetail: .constant(false), pathComp: .constant(nil), sensorsVM: testSensorVM ).makePreViewModifier()*/
        EmptyView()
    }
}
