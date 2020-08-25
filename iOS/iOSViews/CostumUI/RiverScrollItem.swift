//
//  RiverScrollItem.swift
//  iOS
//
//  Created by Marc Kramer on 25.08.20.
//

import SwiftUI
import MapKit

struct RiverScrollItem: View {
    var river: River
    @State var region: MKCoordinateRegion
    
    var body: some View {
        
        
        VStack(alignment: .leading, spacing: 0){
            Map(coordinateRegion: $region, interactionModes: [])
                
                .frame(width: 200, height: 200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.gray.opacity(0.1), lineWidth: 2)
                )
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                .padding(.bottom,10)
            VStack(alignment:.leading, spacing: 0){
                Text(river.name)
                    .font(.headline)
                Text("Sensors: " + String(river.sensors.count))
                    .font(.footnote)
            }
        }
        
    }
}

struct RiverScrollItem_Previews: PreviewProvider {
    static var previews: some View {
        RiverScrollItem(river: rhein, region: rhein.region)
    }
}


