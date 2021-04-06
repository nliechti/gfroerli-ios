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
                    SponsorImageView(sponsor: sponsor).padding(.vertical)
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
        SensorOverviewSponsorView(sensor: testSensor1).makePreViewModifier()
    }
}

struct SponsorImageView:View{
    @ObservedObject var imageLoader:ImageLoader
    @State var image:UIImage = UIImage()
    
    init(sponsor: Sponsor) {
        imageLoader = ImageLoader(urlString:sponsor.logoUrl)
    }
    var body: some View{
        
        Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width:100, height:100)
                        .onReceive(imageLoader.didChange) { data in
                        self.image = UIImage(data: data) ?? UIImage()
                        }
    }
    
    
    
}
