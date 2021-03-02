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
    @State var activePath: String?
    @Binding var loadingState: loadingState
    @ObservedObject var sensorsVm : SensorListViewModel
    @Environment(\.openURL) var openURL
    
    var body: some View {
        NavigationView{
            VStack{
                HStack{
                    Image("AppIcon-1024").resizable().aspectRatio(contentMode: .fit).cornerRadius(15)
                    VStack(alignment: .leading){
                        Text("Gfrör.li").font(.title)
                        Text("Version: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "_")").foregroundColor(.gray)
                        Text("by Coredump Rapperswil").foregroundColor(.gray)
                }
                    Spacer()
                }.frame(maxHeight: 100)
                .padding([.top,.leading])
                
                .background(Color.systemGroupedBackground)
                List{
                    Section(header: Text("General")){
                        HStack{
                            NavigationLink(destination: WidgetSettingsView(sensorsVM: sensorsVm, loadingState: $loadingState), tag: "widgetSettings", selection: $activePath ,label: {
                                Label(
                                    title: { Text("Widget Settings") },
                                    icon: { Image(systemName: "gear").resizable().aspectRatio(contentMode: .fit).foregroundColor(.white).padding(3)
                                        .frame(width: 25, height: 25, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).background(Color.gray).cornerRadius(3) })
                                
                                
                            })}
                        
                        Button(action: {
                            UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                            
                        }, label: {
                            HStack{
                                Label(
                                    title: { Text("Change Language") },
                                    icon: { Image(systemName: "globe").resizable().foregroundColor(.white).padding(5)
                                        .background(Color.blue).frame(width: 25, height: 25, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/) })
                                Spacer()
                                Image(systemName: "chevron.right").foregroundColor(.gray)
                            }
                        }).buttonStyle(PlainButtonStyle())
                        
                    }
                    Section(header:Text("About")){
                        //Contact
                        Button(action: {
                            let email = "appdev@coredump.ch"
                            let subject = "Feedback iOS Version: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "fail")"
                            let body = getEmailBody()
                            guard let url = URL(string: "mailto:\(email)?subject=\(subject.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")&body=\(body.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")") else { return }
                            UIApplication.shared.open(url)
                            
                        }, label: {
                            HStack{
                                Label(
                                    title: { Text("Contact") },
                                    icon: { Image(systemName: "envelope.fill").resizable().aspectRatio(contentMode: .fit).foregroundColor(.white).padding(4)
                                        .frame(width: 25, height: 25, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).background(Color.blue).cornerRadius(3)})
                                Spacer()
                                Image(systemName: "chevron.right").foregroundColor(.gray)
                            }
                        }).buttonStyle(PlainButtonStyle())
                        
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
                            HStack{
                                Label(
                                    title: { Text("Rate") },
                                    icon: { Image(systemName: "heart.fill").resizable().aspectRatio(contentMode: .fit).foregroundColor(.white).padding(5)
                                        .frame(width: 25, height: 25, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).background(Color.red).cornerRadius(3)})
                                Spacer()
                                Image(systemName: "chevron.right").foregroundColor(.gray)
                            }
                        }).buttonStyle(PlainButtonStyle())
                        Link(destination: URL(string: "https://xn--gfrr-7qa.li")!, label: {
                            HStack{
                                Label(
                                    title: { Text("gfrör.li") },
                                    icon: { Image(systemName: "safari").resizable().foregroundColor(.white).padding(4)
                                        .background(Color.blue).frame(width: 25, height: 25, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/) })
                                Spacer()
                                Image(systemName: "chevron.right").foregroundColor(.gray)
                            }
                        }).buttonStyle(PlainButtonStyle())
                        
                        Link(destination: URL(string: "https://www.coredump.ch/")!, label: {
                            HStack{
                                Label(
                                    title: { Text("coredump.ch") },
                                    icon: { Image(systemName: "safari").resizable().foregroundColor(.white).padding(4)
                                        .background(Color.blue).frame(width: 25, height: 25, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/) })
                                Spacer()
                                Image(systemName: "chevron.right").foregroundColor(.gray)
                            }
                        }).buttonStyle(PlainButtonStyle())
                        
                        Link(destination: URL(string: "https://twitter.com/coredump_ch")!, label: {
                            HStack{
                                Label(
                                    title: { Text("@coredump_ch") },
                                    icon: { Image("twitterIcon").resizable().frame(width: 25, height: 25, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                        .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
                                    })
                                Spacer()
                                Image(systemName: "chevron.right").foregroundColor(.gray)
                            }
                        }).buttonStyle(PlainButtonStyle())
                        
                        Link(destination: URL(string: "https://github.com/gfroerli")!, label: {
                            HStack{
                                Label(
                                    title: { Text("Github") },
                                    icon: { Image("githubIcon").resizable().frame(width: 25, height: 25, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                        .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/) })
                                Spacer()
                                Image(systemName: "chevron.right").foregroundColor(.gray)
                            }
                        }).buttonStyle(PlainButtonStyle())
                        
                        Link(destination: URL(string: "https://xn--gfrr-7qa.li/about")!, label: {
                            HStack{
                                Label(
                                    title: { Text("Privacy Policy") },
                                    icon: { Image(systemName: "hand.raised.fill").resizable().aspectRatio(contentMode: .fit).foregroundColor(.white).padding(4)
                                        .frame(width: 25, height: 25, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).background(Color.blue).cornerRadius(3) })
                                Spacer()
                                Image(systemName: "chevron.right").foregroundColor(.gray)
                            }
                        }).buttonStyle(PlainButtonStyle())
                        
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
        UserDefaults(suiteName: "group.ch.gfroerli")?.set(0, forKey: "widgetSensorID")
        WidgetCenter.shared.reloadAllTimelines()
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(activePath: nil, loadingState: .constant(.loaded), sensorsVm: SensorListViewModel()).makePreViewModifier()
    }
}
