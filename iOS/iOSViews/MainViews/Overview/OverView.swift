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
                AboutView(showView: $showAbout)
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
        OverView(showDetail: .constant(false), pathComp: .constant(nil), sensors: testSensorVM, loadingState: .constant(.loading)).makePreViewModifier()
    }
}
