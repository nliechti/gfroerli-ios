//
//  SettingsView.swift
//  iOS
//
//  Created by Marc Kramer on 22.08.20.
//

import SwiftUI
import WidgetKit
import StoreKit
import CoreLocation

struct SettingsView: View {
    @State var alertShowing = false
    @State var lastVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "_"
    @Environment(\.openURL) var openURL
    
    var body: some View {
        NavigationView{
            VStack{
                List{
                    HStack{
                        Image("AppIcon-1024").resizable().aspectRatio(contentMode: .fit).cornerRadius(15)
                            .padding(.trailing)
                        VStack(alignment: .leading){
                            Text("Gfrör.li").font(.title).bold()
                            Text("Version: \(lastVersion)").foregroundColor(.gray)
                            Text("by Marc & Niklas\nfor Coredump Rapperswil").foregroundColor(.gray)
                        }.lineLimit(2)
                        .minimumScaleFactor(0.1)
                        Spacer()
                    }.frame(maxHeight: 100)
                    .padding([.top,.bottom],5)
                    
                    Section(header: Text("General")){
                        // FAQ
                        HStack{
                            NavigationLink(destination: FAQView() ,label: {
                                Label(
                                    title: { Text("About").foregroundColor(Color("textColor"))},
                                    icon: { Image(systemName: "info.circle").resizable().aspectRatio(contentMode: .fit).foregroundColor(.white).padding(3)
                                        .frame(width: 25, height: 25, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).background(Color.blue).cornerRadius(3) })
                            })}
                        //Changelog
                        HStack{
                            NavigationLink(destination: WhatsNewView(lastVersion: "0.0", showDismiss: false),label: {
                                Label(
                                    title: { Text("Changelog").foregroundColor(Color("textColor"))},
                                    icon: { Image(systemName: "sparkles").resizable().aspectRatio(contentMode: .fit).foregroundColor(.white).padding(3)
                                        .frame(width: 25, height: 25, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).background(Color.green).cornerRadius(3) })
                            })}
                    }
                    
                    Section(header:Text("Links")){
                        //Rate
                        Button(action: {
                            var components = URLComponents(url: URL(string: "https://apps.apple.com/us/app/gfr%C3%B6r-li/id1451431723")!, resolvingAgainstBaseURL: false)
                            
                            components?.queryItems = [
                                URLQueryItem(name: "action", value: "write-review")
                            ]
                            guard let writeReviewURL = components?.url else {
                                return
                            }
                            openURL(writeReviewURL)
                            
                        }, label: {
                            Label(
                                title: { Text("Rate").foregroundColor(Color("textColor")) },
                                icon: { Image(systemName: "heart.fill").resizable().aspectRatio(contentMode: .fit).foregroundColor(.white).padding(5)
                                    .frame(width: 25, height: 25, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).background(Color.red).cornerRadius(3)})
                        })
                        //Contact
                        Button(action: {
                            let email = "appdev@coredump.ch"
                            let subject = "Feedback iOS Version: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "fail")"
                            let body = getEmailBody()
                            guard let url = URL(string: "mailto:\(email)?subject=\(subject.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")&body=\(body.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")") else { return }
                            UIApplication.shared.open(url)
                            
                        }, label: {
                            Label(
                                title: { Text("Contact").foregroundColor(Color("textColor")) },
                                icon: { Image(systemName: "envelope.fill").resizable().aspectRatio(contentMode: .fit).foregroundColor(.white).padding(4)
                                    .frame(width: 25, height: 25, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).background(Color.blue).cornerRadius(3)})
                        })
                        
                        Link(destination: URL(string: "https://xn--gfrr-7qa.li/about")!, label: {
                            Label(
                                title: { Text("Privacy Policy").foregroundColor(Color("textColor")) },
                                icon: { Image(systemName: "hand.raised.fill").resizable().aspectRatio(contentMode: .fit).foregroundColor(.white).padding(4)
                                    .frame(width: 25, height: 25, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).background(Color.blue).cornerRadius(3) })
                        })
                        
                        Button(action: {
                            UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                            
                        }, label: {
                            Label(
                                title: { Text("Change Language").foregroundColor(Color("textColor"))},
                                icon: { Image(systemName: "globe").resizable().foregroundColor(.white).padding(5)
                                    .background(Color.gray).frame(width: 25, height: 25, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/) })
                        })
                        
                        Link(destination: URL(string: "https://xn--gfrr-7qa.li")!, label: {
                            Label(
                                title: { Text("gfrör.li").foregroundColor(Color("textColor")) },
                                icon: { Image(systemName: "safari").resizable().foregroundColor(.blue).padding(4)
                                    .background(Color.white).frame(width: 25, height: 25, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 3)
                                            .stroke(Color.gray, lineWidth: 0.2)
                                    ) })
                        })
                        
                        Link(destination: URL(string: "https://www.coredump.ch/")!, label: {
                            Label(
                                title: { Text("coredump.ch").foregroundColor(Color("textColor")) },
                                icon: { Image(systemName: "safari").resizable().foregroundColor(.blue).padding(4)
                                    .background(Color.white).frame(width: 25, height: 25, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 3)
                                            .stroke(Color.gray, lineWidth: 0.2)
                                    ) })
                        })
                        
                        Link(destination: URL(string: "https://twitter.com/coredump_ch")!, label: {                                Label(
                            title: { Text("@coredump_ch").foregroundColor(Color("textColor")) },
                            icon: { Image("twitterIcon").resizable().frame(width: 25, height: 25, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
                            })
                        })
                        
                        Link(destination: URL(string: "https://github.com/gfroerli")!, label: {
                            Label(
                                title: { Text("Code on Github").foregroundColor(Color("textColor")) },
                                icon: { Image("githubIcon").resizable().frame(width: 25, height: 25, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                    .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/) })
                        })
                    }
                }.listStyle(GroupedListStyle())
            }.background(Color.systemGroupedBackground.ignoresSafeArea())
            .navigationBarTitle("Settings", displayMode: .inline)
            .navigationBarItems(trailing:
                                    Button(action: {alertShowing=true}, label: {
                                        Text("Reset App").fontWeight(.regular)
                                    }).alert(isPresented: $alertShowing, content: {
                                        Alert(
                                            title: Text("Are you sure?"),
                                            message: Text("Do you want to reset the app?"),
                                            primaryButton: .destructive(Text("Reset"), action: resetContent),
                                            secondaryButton: .cancel(Text("Cancel"), action: {})
                                        )
                                    }) )
        }
    }
    func resetContent(){
        UserDefaults(suiteName: "group.ch.gfroerli")?.set([], forKey: "favoritesIDs")
        UserDefaults(suiteName: "group.ch.gfroerli")?.set("0.0", forKey: "lastVersion")
        WidgetCenter.shared.reloadAllTimelines()
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().makePreViewModifier()
    }
}
