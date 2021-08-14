//
//  ChangelogView.swift
//  ChangelogView
//
//  Created by Marc Kramer on 14.08.21.
//

import SwiftUI

struct ChangelogView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    var lastVersion: String
    var showDismiss: Bool
    
    var body: some View {
        ScrollView {
            
            ForEach(ChangeNote.allChangeNotes) { changeNote in
                if changeNote.version > lastVersion {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Version: "+changeNote.version+":")
                                .font(.title)
                                .bold()
                            Spacer()
                        }
                        if !changeNote.changes.isEmpty {
                            Text("Changes")
                                .font(.title2)
                                .padding(.vertical, 1)
                            ForEach(changeNote.changes, id: \.self ) {change in
                                Text("• "+change)
                            }
                            .padding([.horizontal])
                        }
                        if !changeNote.fixes.isEmpty {
                            Text("Fixes")
                                .font(.title2)
                                .padding(.vertical, 2)
                            ForEach(changeNote.fixes, id: \.self ) {fix in
                                Text("• "+fix)
                            }.padding([.horizontal])
                        }
                    }
                    .padding()
                    .boxStyle()
                }
            }
        }
        .navigationBarTitle("Changelog", displayMode: .inline)
        .background(Color.systemGroupedBackground)
    }
}

struct ChangelogView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
