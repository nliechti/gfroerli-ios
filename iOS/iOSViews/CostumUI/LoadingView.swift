//
//  LoadingView.swift
//  iOS
//
//  Created by Marc Kramer on 18.09.20.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                ProgressView().progressViewStyle(CircularProgressViewStyle())
                    .padding(.bottom, 2)
                Text("LOADING").foregroundColor(.secondary)
                Spacer()
            }
            Spacer()
        }.padding()
    }
}

struct ErrorView<Source: LoadableObject>: View {
    @ObservedObject var source: Source
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text("Error while fetching data.").foregroundColor(.gray)
                Spacer()
            }
            Button(action: {
                source.load()
            }, label: {
                Text("Try again")
            })
            Spacer()
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
