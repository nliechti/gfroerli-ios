//
//  ScrollItem.swift
//  iOS
//
//  Created by Marc Kramer on 22.08.20.
//

import SwiftUI
import MapKit

struct ScrollItem: View {
    @Environment(\.colorScheme) var colorScheme

    
    @State var sensorCount: Int
    @State var name: String
    @State var region: MKCoordinateRegion
    
    var body: some View {
        
        
        VStack(alignment: .leading, spacing: 0){
            Map(coordinateRegion: $region, interactionModes: [])
            VStack(alignment: .leading){
                Text(name)
                    .font(.headline)
                HStack {
                    Text("Sensors: " + String(sensorCount))
                        .font(.footnote)
                    Spacer()
                }
            }.padding()
            .background((colorScheme == .dark ? Color(.systemGray6) : Color.white))
            
        }
                .frame(width: 300, height: 250, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .cornerRadius(15)
                .shadow(color: (colorScheme == .dark ? Color.black.opacity(0.0) : Color.black.opacity(0.2)), radius: 10, x: 10, y: 10)
                .shadow(color: (colorScheme == .dark ? Color.white.opacity(0.0) : Color.white.opacity(0.8)), radius: 10, x: -5, y: -5)
                .padding(.bottom,10)
            
        
        
    }
}

struct LakeScrollItem_Previews: PreviewProvider {
    static var previews: some View {
        Group{
        ScrollItem(sensorCount: lakeOfZurich.sensors.count, name: lakeOfZurich.name, region: lakeOfZurich.region)
            ScrollItem(sensorCount: lakeOfZurich.sensors.count, name: lakeOfZurich.name, region: lakeOfZurich.region).environment(\.colorScheme, .dark)
    }
        
    }
}

