//
//  FavoritesView.swift
//  iOS
//
//  Created by Marc Kramer on 22.08.20.
//

import SwiftUI
import MapKit

struct FavoritesView: View {
    @State var favorites =  [Int]()
    @ObservedObject var sensorsVm: SensorListViewModel

    var body: some View {
        NavigationView {
            VStack {
                if favorites.isEmpty {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Text("No Favorites").font(.largeTitle).foregroundColor(.gray)
                            Spacer()
                        }
                        Spacer()
                    }
                } else {
                    AsyncContentView(source: sensorsVm) { sensors in
                        ScrollView {
                            ForEach(sensors) { sensor in
                                if favorites.contains(sensor.id) {
                                    NavigationLink(
                                        destination: SensorOverView(sensorID: sensor.id, sensorName: sensor.device_name),
                                        label: {
                                            Item(sensor: sensor)
                                        }).buttonStyle(PlainButtonStyle())
                                }
                            }
                            Spacer()
                        }
                    }
                }
            }
            .background(Color.systemGroupedBackground.ignoresSafeArea())
            .navigationTitle("Favorites")
        }.onAppear {
            favorites = UserDefaults(suiteName: "group.ch.gfroerli")?.array(forKey: "favoritesIDs") as? [Int] ?? [Int]()
        }
    }
}

private struct Item: View {
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    var sensor: Sensor
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            Map(coordinateRegion: $region, interactionModes: [])
            VStack(alignment: .leading) {

                HStack {
                    Text(sensor.device_name)
                        .font(.headline)
                    Spacer()
                }
                Text(sensor.caption!)
                    .font(.footnote)
            }.padding()
        }
        .onAppear(perform: {
            region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: sensor.latitude!, longitude: sensor.longitude!), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        })

        .background(Color.secondarySystemGroupedBackground)
        .frame(width: UIScreen.main.bounds.width, height: 200)
    }
}
struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView(sensorsVm: SensorListViewModel()).makePreViewModifier()
    }
}
