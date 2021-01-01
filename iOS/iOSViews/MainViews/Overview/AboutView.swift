//
//  AboutView.swift
//  iOS
//
//  Created by Marc Kramer on 01.01.21.
//

import SwiftUI

struct AboutView: View {
    @Binding var showView: Bool
    
    var body: some View {
        NavigationView{
            VStack {
                GroupBox{
                    DisclosureGroup(
                        content: { Text("A1_String") },
                        label: { Text("Q1_String").font(.headline) })
                    Divider()
                    DisclosureGroup(
                        content: { Text("A2_String")
                            Link("www.gfrör.li", destination: URL(string: "https://xn--gfrr-7qa.li/")!)
                        },
                        label: { Text("Q2_String").font(.headline) })
                    
                }
                Spacer()
            }.padding()
            .navigationTitle("About")
            .navigationBarItems(leading:
                                    Button(action: {showView=false}
                                           , label: {
                                            Text("Close")
                                           }))
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView(showView: .constant(true))
    }
}
