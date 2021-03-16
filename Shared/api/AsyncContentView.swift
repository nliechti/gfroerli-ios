//
//  AsyncContentView.swift
//  Gfror.li
//
//  Created by Marc on 28.01.21.
//

import SwiftUI

struct AsyncContentView<Source: LoadableObject, Content: View>: View {
    
    @ObservedObject var source: Source
    var content: (Source.Output) -> Content
    init(source: Source,
         @ViewBuilder content: @escaping (Source.Output) -> Content) {
        self.source = source
        self.content = content
    }
    
    var body: some View {
        switch source.state {
        case .idle:
            Color.clear.onAppear(perform: source.load)
        case .loading:
            LoadingView()
        case .failed:
            ErrorView(source: source)
        case .loaded(let output):
            content(output)
        }
    }
    
}

struct AsyncContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}


