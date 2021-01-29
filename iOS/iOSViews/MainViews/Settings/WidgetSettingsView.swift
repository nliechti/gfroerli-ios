//
//  WidgetSettingsView.swift
//  iOS
//
//  Created by Marc Kramer on 24.08.20.
//

import SwiftUI
import WidgetKit

struct WidgetSettingsView: View {
    @ObservedObject var sensorsVM : SensorListViewModel
    @Binding var loadingState: loadingState
    @AppStorage("widgetSensorID", store: UserDefaults(suiteName: "group.ch.gfroerli")) var widgetSensorID: Int = -1

    var body: some View {
        VStack{
            Form{
                Section(header: Text("Choose Sensor to Display on Widget")) {
                    AsyncContentView(source: sensorsVM) { sensors in
                        ForEach(sensors) {sensor in
                            SingleSelectionRow(title: sensor.device_name, isSelected: widgetSensorID==sensor.id) {
                                widgetSensorID=sensor.id
                                WidgetCenter.shared.reloadAllTimelines()
                                
                            }
                        }
                    
                    }
                    
                    
                    Button {
                        widgetSensorID = -1
                        WidgetCenter.shared.reloadAllTimelines()
                    } label: {
                        Text("Reset selection").foregroundColor(.red)
                    }

                }
            }
            
        }.navigationTitle("Widget")
    }
}

struct WidgetSettingsView_Previews: PreviewProvider {
    static var previews: some View {
            WidgetSettingsView(sensorsVM: SensorListViewModel(), loadingState: .constant(.loaded)).makePreViewModifier()
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
        }
    }
}
