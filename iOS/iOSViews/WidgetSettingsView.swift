//
//  WidgetSettingsView.swift
//  iOS
//
//  Created by Marc Kramer on 24.08.20.
//

import SwiftUI
import WidgetKit

struct WidgetSettingsView: View {
    @ObservedObject var sensors = SensorViewModel()
    @AppStorage("widgetSensorID", store: UserDefaults(suiteName: "group.ch.test")) var widgetSensorID: Int = -1

    var body: some View {
        VStack{
            Form{
                Section(header: Text("Choose Sensor to Display on Widget")) {
                    ForEach(sensors.sensorArray) {sensor in
                        SingleSelectionRow(title: sensor.device_name!, isSelected: widgetSensorID==sensor.id!) {
                            widgetSensorID=sensor.id!
                            print(widgetSensorID)
                            WidgetCenter.shared.reloadAllTimelines()
                            
                        }
                    }
                    Button {
                        widgetSensorID=2
                        WidgetCenter.shared.reloadAllTimelines()
                    } label: {
                        Text("reset")
                    }

                }
            }
            
        }.navigationTitle("Widget")
    }
}

struct WidgetSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetSettingsView()
    }
}


struct SingleSelectionRow: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        
        HStack {
            Text(self.title)
            Spacer()
            if self.isSelected {
                Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
            }else{
                Image(systemName: "circle")
            }
            Text("")
        }.onTapGesture {
            self.action()
            print("selected")
        }
    }
}
