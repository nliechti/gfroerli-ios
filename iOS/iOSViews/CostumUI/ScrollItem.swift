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
    
    var lake: Lake
    var sensorCount: Int
    var name: String
    @State var region: MKCoordinateRegion
    
    init(lake: Lake){
        self.lake = lake
        sensorCount = self.lake.sensors.count
        name=self.lake.name
        _region = State(wrappedValue: lake.region)
    }
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            Map(coordinateRegion: $region, interactionModes: [])
            VStack(alignment: .leading){
                Text(name)
                    .font(.headline)
                HStack {
                    Text("Sensors: " + String(sensorCount))
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                }
            }.padding()
            .background(Color.secondarySystemGroupedBackground)
            
        }
        .frame(width: 300, height: 250, alignment: .leading)
        .cornerRadius(15)
        .shadow(radius: 1)  
    }
}

struct LakeScrollItem_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            ScrollItem(lake: lakeOfZurich)
            ScrollItem(lake: lakeOfZurich).preferredColorScheme(.dark)
        }
        
    }
}

