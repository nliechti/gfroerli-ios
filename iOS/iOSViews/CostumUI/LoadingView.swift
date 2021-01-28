//
//  LoadingView.swift
//  iOS
//
//  Created by Marc Kramer on 18.09.20.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack{
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
        }.background(Color.systemGroupedBackground)
    }
}

struct ErrorView: View {
    var body: some View {
        VStack{
            Spacer()
            HStack {
                Spacer()
                Text("Error while fetching data.").foregroundColor(.gray)
                Spacer()
            }
            Spacer()
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
