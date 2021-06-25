//
//  WhatsNewView.swift
//  Gfror.li
//
//  Created by Marc on 23.03.21.
//

import SwiftUI

struct WhatsNewView: View {

    @Environment(\.presentationMode) private var presentationMode
    var lastVersion: String
    var showDismiss: Bool

    var body: some View {

        ScrollView {

            ForEach(ChangeNote.allChangeNotes) { changeNote in

                if changeNote.version > lastVersion {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Version: "+changeNote.version+":").font(.title).bold()
                            Spacer()
                        }
                        if !changeNote.changes.isEmpty {
                            Text("Changes").font(.title2).padding(.vertical, 1)
                            ForEach(changeNote.changes, id: \.self ) {change in
                                Text("- "+change)
                            }.padding([.horizontal])
                        }
                        if !changeNote.fixes.isEmpty {
                            Text("Fixes").font(.title2).padding(.vertical, 2)
                            ForEach(changeNote.fixes, id: \.self ) {fix in
                                Text("- "+fix)
                            }.padding([.horizontal])
                        }
                    }.padding()
                    .background(Color(.secondarySystemGroupedBackground))
                    .cornerRadius(15)
                    .padding()
                    .shadow(radius: 1)
                }

            }

            // Dismiss Button
            if showDismiss {
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    HStack {
                        Spacer()
                        Text("Continue")
                            .foregroundColor(.white)
                            .frame(width: 200, height: 40)
                            .background(Color.blue)
                            .cornerRadius(15)
                        Spacer()
                    }
                }.padding(.bottom)
            }
        }
        .navigationBarTitle("What's new?", displayMode: .inline)
        .background(Color.systemGroupedBackground)
        .onDisappear {
            UserDefaults(suiteName: "group.ch.gfroerli")?.set(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0", forKey: "lastVersion")

        }
    }
}

struct WhatsNewView_Previews: PreviewProvider {
    static var previews: some View {
        WhatsNewView(lastVersion: "1.0", showDismiss: true)
    }
}
