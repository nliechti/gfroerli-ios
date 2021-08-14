//
//  ViewExtensions.swift
//  iOS
//
//  Created by Marc on 28.01.21.
//

import Foundation
import SwiftUI

extension View {

    func boxStyle() -> some View {
        self
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity)
            .background(Color.secondarySystemGroupedBackground)
            .cornerRadius(15)
            .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(.tertiary, lineWidth: 0.2)
                )
            .padding(.bottom)
            .padding(.horizontal)
    }

}
