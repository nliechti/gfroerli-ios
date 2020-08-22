//
//  OverView.swift
//  iOS
//
//  Created by Marc Kramer on 22.08.20.
//

import SwiftUI

struct OverView: View {
    var body: some View {
        NavigationView{
            VStack{
                VStack(alignment: .leading, spacing: 0){
                    Text("Lakes")
                        .font(.title2)
                        .bold()
                        .padding(.horizontal)
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing:0){
                        ForEach(lakes){ lake in
                            NavigationLink(
                                destination: LakeOverView(lake: lake),
                                label: {
                                    LakeScrollItem(lake: lake, region: lake.region)
                                        
                                }).buttonStyle(PlainButtonStyle())
                                .padding()
                        }
                    }
                    }
                }
                Divider()
                Spacer()
            }.navigationTitle("Gfrör.li")
            .background(Color.gray.opacity(0.001))
            
        }
    }
}

struct OverView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            OverView()
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro Max"))
                .previewDisplayName("iPhone 11 Pro Max")
            OverView()
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
                .previewDisplayName("iPhone 11 Pro")
            OverView()
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .previewDisplayName("iPhone SE")
        }
    }
}
