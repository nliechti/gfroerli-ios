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
                    
                    TopTabView(sensorsVM: sensorsVM).frame(height:375)
                    
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
    @ObservedObject var sensorsVM : SensorListViewModel
    @State var newest = 1
    @State var random = 1
    @State var latest = 1
    var body: some View{
        AsyncContentView(source: sensorsVM){ sensors in
            
            TabView{
                NavigationLink(
                    destination: SensorOverView(id: 1),
                    label: {
                        SensorScrollItem(title: "Newest", sensorID: $newest)
                    }).buttonStyle(PlainButtonStyle())
                NavigationLink(
                    destination: SensorOverView(id: 1),
                    label: {
                        SensorScrollItem(title: "Latest", sensorID: $latest)
                    }).buttonStyle(PlainButtonStyle())
                NavigationLink(
                    destination: SensorOverView(id: 1),
                    label: {
                        SensorScrollItem(title: "Random", sensorID: $random)
                    }).buttonStyle(PlainButtonStyle())
            }.padding(.top)
            .tabViewStyle(PageTabViewStyle())
            .onAppear(perform: {
                UIPageControl.appearance().currentPageIndicatorTintColor = .black
                UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
                print(testSensorVM.sensorArray.sorted(by: {$0.id > $1.id}))
                newest = sensorsVM.sensorArray.sorted(by: {$0.id > $1.id}).first!.id
                latest = sensorsVM.sensorArray.sorted(by: {$0.lastTempTime! > $1.lastTempTime!}).first!.id
                random = sensorsVM.sensorArray.randomElement()!.id
            })
        }
    }
}

struct OverView_Previews: PreviewProvider {
    static var previews: some View {
        OverView(showDetail: .constant(false), pathComp: .constant(nil), sensorsVM: testSensorVM ).makePreViewModifier()
    }
}
