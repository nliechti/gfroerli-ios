//
//  ScrollItem.swift
//  iOS
//
//  Created by Marc Kramer on 22.08.20.
//

import SwiftUI
import MapKit

struct LakeScrollItem: View {
    var lake: Lake
    @State var region: MKCoordinateRegion
    
    var body: some View {
        
    
        VStack(alignment: .leading, spacing: 0){
            Map(coordinateRegion: $region, interactionModes: [])
                
                .frame(width: 200, height: 200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .cornerRadius(15)
                .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                .padding(10)
            VStack(alignment:.leading, spacing: 0){
            Text(lake.name)
                .font(.headline)
            Text("Sensors: " + String(lake.sensors.count))
                .font(.footnote)
            }.padding(.horizontal,
                      15)
        }
        
    }
}

struct LakeScrollItem_Previews: PreviewProvider {
    static var previews: some View {
        LakeScrollItem(lake: lakeOfZurich, region: lakeOfZurich.region)
    }
}

extension Map {
    func mapStyle(_ mapType: MKMapType, showScale: Bool = true, showTraffic: Bool = true
    ) -> some View {
            let map = MKMapView.appearance()
            map.mapType = mapType
            map.showsScale = showScale
            map.showsTraffic = showTraffic
            return self
        }
}
