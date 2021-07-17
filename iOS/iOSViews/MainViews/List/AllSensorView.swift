//
//  AllSensorView.swift
//  iOS
//
//  Created by Marc Kramer on 11.09.20.
//

import SwiftUI

struct AllSensorView: View {
    @ObservedObject var sensorsVm: SensorListViewModel
    @State var id: String?
    @State var searchText = ""
    @State var isSearching = false
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                SearchBar(searchText: $searchText, isSearching: $isSearching)

                if !sensorsVm.sensorArray.isEmpty {
                    Text("List")
                } else {
                    VStack {
                        Spacer()
                        Text("No Sensors").font(.largeTitle).foregroundColor(.gray)
                        Spacer()
                    }
                }
                Spacer()
            }.background(Color.systemGroupedBackground.ignoresSafeArea())
            .navigationTitle("All Sensors")
        }
    }
}

struct AllSensorView_Previews: PreviewProvider {
    static var previews: some View {
        AllSensorView(sensorsVm: SensorListViewModel()).makePreViewModifier()
    }
}
