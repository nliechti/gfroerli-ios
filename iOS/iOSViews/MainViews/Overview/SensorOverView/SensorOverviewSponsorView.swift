//
//  SensorOverviewSponsorView.swift
//  iOS
//
//  Created by Marc Kramer on 11.09.20.
//

import SwiftUI

struct SensorOverviewSponsorView: View {
    @StateObject var sponsorListVM = SponsorListViewModel()
    
    var sensor: Sensor
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Sponsored by:").font(.title).bold()
        AsyncContentView(source: sponsorListVM) { sponsor in 
            VStack{
                HStack{
                    Text(sponsor.name).font(.largeTitle).bold()
                    Spacer()
                }.padding(.bottom)
                Text( sponsor.description)
                Spacer()
            }
        }
        }.padding()
        .onAppear(perform: {
                    sponsorListVM.id = sensor.id
                    sponsorListVM.load()})
    }
}

struct SensorOverviewSponsorView_Previews: PreviewProvider {
    static var previews: some View {
        SensorOverviewSponsorView(sensor: testSensor).makePreViewModifier()
    }
}
