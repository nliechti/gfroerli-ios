//
//  OverView.swift
//  iOS
//
//  Created by Marc Kramer on 22.08.20.
//

import SwiftUI
import MapKit
struct OverView: View {
    @State var showAbout: Bool = false
    @Binding var showDetail: Bool
    @Binding var pathComp: String?
    @ObservedObject var sensorsVM : SensorListViewModel
    var featuredSensorID = 1
    var body: some View {
        NavigationView{
            ScrollView(.vertical){
                VStack(alignment: .leading, spacing: 0){
                    Text("Featured")
                        .font(.title)
                        .bold()
                        .padding(.horizontal)
                    
                    AsyncContentView(source: sensorsVM) { sensors in
                        NavigationLink(
                            destination: SensorOverView(id: featuredSensorID),
                            label: {
                                SensorScrollItem(sensor: sensors.first(where: {$0.id == featuredSensorID})!)
                            }).buttonStyle(PlainButtonStyle())
                    }
                    
                    Text("Water Bodies")
                        .font(.title)
                        .bold()
                        .padding([.horizontal,.top])
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing:0){
                            ForEach(lakes){ lake in
                                NavigationLink(
                                    destination: LakeOverView(lake: lake, sensorsVM: sensorsVM),
                                    label: {
                                        ScrollItem(lake:lake)
                                    }).buttonStyle(PlainButtonStyle())
                                    .padding()
                            }
                        }
                    }
                }
                Spacer()
            }
            .background(Color.systemGroupedBackground.ignoresSafeArea())
            .navigationTitle("Gfrör.li")
            .toolbar{
                ToolbarItem{
                    Button {
                        showAbout=true
                    } label: {
                        Image(systemName: "info.circle")
                    }
                }
            }.sheet(isPresented: $showAbout, content: {
                FAQView(showView: $showAbout)
            })
        }.sheet(isPresented: $showDetail, content: {
            NavigationView{
                SensorOverView(id:Int(pathComp!)!).navigationBarItems(leading: Button(action: {showDetail=false}, label: {Text("Close")}))
            }
        })
    }
}

struct OverView_Previews: PreviewProvider {
    static var previews: some View {
        OverView(showDetail: .constant(false), pathComp: .constant(nil), sensorsVM: testSensorVM ).makePreViewModifier()
    }
}
