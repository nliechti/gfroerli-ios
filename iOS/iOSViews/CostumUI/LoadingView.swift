//
//  LoadingView.swift
//  iOS
//
//  Created by Marc Kramer on 18.09.20.
//

import SwiftUI

struct LoadingView: View {
    init() {}
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                ProgressView().progressViewStyle(CircularProgressViewStyle())
                Spacer()
            }
            HStack {
                Spacer()
                Text("Loading").foregroundColor(.gray)
                Spacer()
            }
            Spacer()
        }.frame(maxWidth: .infinity)
        .background(Color.systemGroupedBackground)
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
