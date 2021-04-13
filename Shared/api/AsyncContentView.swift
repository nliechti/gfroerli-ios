//
//  AsyncContentView.swift
//  Gfror.li
//
//  Created by Marc on 28.01.21.
//

import SwiftUI

struct AsyncContentView<Source: LoadableObject, LoadingView: View,Content: View>: View {
    
    @ObservedObject var source: Source
    var loadingView: LoadingView
    var content: (Source.Output) -> Content
    init(source: Source,loadingView: LoadingView ,
         @ViewBuilder content: @escaping (Source.Output) -> Content) {
        self.source = source
        self.content = content
        self.loadingView = loadingView
    }
    
    var body: some View {
        switch source.state {
        case .idle:
            Color.clear.onAppear(perform: source.load)
        case .loading:
            loadingView
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

typealias DefaultProgressView = ProgressView<EmptyView, EmptyView>

extension AsyncContentView where LoadingView == DefaultProgressView {
    init(
        source: Source,
        @ViewBuilder content: @escaping (Source.Output) -> Content
    ) {
        self.init(
            source: source,
            loadingView: ProgressView(),
            content: content
        )
    }
}
