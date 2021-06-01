//
//  SensorOverViewGraph.swift
//  iOS
//
//  Created by Marc Kramer on 11.09.20.
//

import SwiftUI

struct SensorOverViewGraph: View {
    
    var sensorId: Int
    @StateObject var temperatureAggregationsVM: TemperatureAggregationsViewModel = TemperatureAggregationsViewModel()
    @StateObject var monthVM = MonthlyAggregationsViewModel()
    @StateObject var weekVM = WeeklyAggregationsViewModel()
    @StateObject var dayVM = HourlyAggregationsViewModel()
    
    @State var showIndicator = false
    @State var selectedIndex = 0
    @State var zoomed = true
    
    @State var pickerSelection = 0
    @State var pickerOptions = [NSLocalizedString("Day", comment: ""), NSLocalizedString("Week", comment: ""), NSLocalizedString("Month", comment: "")]
    
    @State var timeFrame: TimeFrame = .day
    @State var topString = ""
    
    init(sensorID: Int) {
        self.sensorId = sensorID
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .firstTextBaseline) {
                Text("History").font(.title).bold()
                Spacer()
                
                if showIndicator {
                    Text(topString).bold()
                } else {
                    Button(action: {
                        zoomed.toggle()
                    }, label: {
                        if zoomed{
                            Text(Image(systemName: "arrow.down.right.and.arrow.up.left")).font(.title2)
                        }else{
                            Text(Image(systemName: "arrow.up.left.and.arrow.down.right")).font(.title2)
                        }
                    })
                }
            }
            
            HStack(alignment:.center) {
                if !showIndicator {
                    Picker(selection: $pickerSelection, label: Text("")) {
                        ForEach(0..<pickerOptions.count) { index in
                            Text(self.pickerOptions[index]).tag(index)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                } else {
                    Spacer()
                    TemperaturesDetailView(temperatureAggregationsVM: temperatureAggregationsVM, index: $selectedIndex, pickerSelection: $pickerSelection).padding(.top)
                    Spacer()
                }
            }
            
            GraphView(timeFrame: $timeFrame, selectedIndex: $selectedIndex, zoomed: $zoomed, showIndicator: $showIndicator, temperatureAggregationsVM: temperatureAggregationsVM)
            
            HStack{
                Spacer()
                Button(action: {
                    stepBack()
                }, label: {
                    Image(systemName: "arrow.left.circle").imageScale(.large)
                })
                Spacer()
                Text(getLabel())
                Spacer()
                Button(action: {
                    stepForward()
                    
                }, label: {
                    Image(systemName: "arrow.right.circle").imageScale(.large)
                }).disabled(checkTimeFrame())
                Spacer()
            }
        }
        .padding()
        .onAppear(perform: {
            dayVM.id = sensorId
            weekVM.id = sensorId
            monthVM.id = sensorId
        })
        .onChange(of: pickerSelection, perform: { value in
            setTimeFrame()
        })
        .onChange(of: selectedIndex, perform: { value in
            setTopDateString()
        })
    }
    
    func setTimeFrame(){
        switch pickerSelection {
        case 0:
            timeFrame = .day
        case 1:
            timeFrame = .week
        default:
            timeFrame = .month
        }
    }
    
    func stepBack(){
        switch pickerSelection {
        case 0:
            temperatureAggregationsVM.subtractDay()
        case 1:
            temperatureAggregationsVM.subtractWeek()
        default:
            temperatureAggregationsVM.subtractMonth()
        }
    }
    
    func stepForward(){
        switch pickerSelection {
        case 0:
            temperatureAggregationsVM.addDay()
        case 1:
            temperatureAggregationsVM.addWeek()
        default:
            temperatureAggregationsVM.addMonth()
        }
    }
    
    func getLabel() -> String{
        let df = DateFormatter()
    
        switch pickerSelection{
        case 0:
            df.setLocalizedDateFormatFromTemplate("dd MMM")
            return df.string(from: temperatureAggregationsVM.dateDay)
            
        case 1:
            df.setLocalizedDateFormatFromTemplate("dd MMM")
            return df.string(from: temperatureAggregationsVM.startDateWeek) + "-" + df.string(from: Calendar.current.date(byAdding: .day, value: 6, to: temperatureAggregationsVM.startDateWeek)!)
            
        default:
            df.setLocalizedDateFormatFromTemplate("MMMM YYYY")
            return df.string(from: temperatureAggregationsVM.startDateMonth)
        }
    }
    
    func setTopDateString(){
        let df = DateFormatter()
        let calendar = Calendar.current
        
        switch pickerSelection{
        case 0:
            let date = temperatureAggregationsVM.dateDay
            var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
            components.minute = 0
            components.hour = temperatureAggregationsVM.stepsDay[selectedIndex]
            let createdDate = calendar.date(from: components)!
            df.setLocalizedDateFormatFromTemplate("mmHddMMMMY")
            topString =  df.string(from: createdDate)
            
        case 1:
            let date = temperatureAggregationsVM.startDateWeek
            var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
            components.day! += temperatureAggregationsVM.stepsWeek[selectedIndex]
            df.setLocalizedDateFormatFromTemplate("EEEEddMMMMY")
            topString =  df.string(from: calendar.date(from: components)!)
            
        default:
            let date = temperatureAggregationsVM.startDateMonth
            var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
            components.day! += temperatureAggregationsVM.stepsMonth[selectedIndex]
            df.setLocalizedDateFormatFromTemplate("dd MMMM Y")
            topString =  df.string(from: calendar.date(from: components)!)
        }
    }
    
    private func checkTimeFrame()->Bool{
        switch timeFrame {
        case .day:
            return temperatureAggregationsVM.isInSameDay
        case .week:
            return temperatureAggregationsVM.isInSameWeek
        default:
            return temperatureAggregationsVM.isInSameMonth
        }
    }
}

/*struct SensorOverViewGraph_Previews: PreviewProvider {
 static var previews: some View {
 SensorOverViewGraph(sensorID: 1)
 .makePreViewModifier()
 
 }
 }*/


struct TemperaturesDetailView: View{
    
    @ObservedObject var temperatureAggregationsVM: TemperatureAggregationsViewModel
    @Binding var index: Int
    @Binding var pickerSelection: Int
    
    var body: some View{
        
        HStack{
            Spacer()
            VStack(alignment: .center){
                Text("Min:").bold()
                Text(String(getMin()))
            }
            Spacer()
            VStack(alignment: .center){
                Text("Avg:").bold()
                Text(String(getAvg()))
            }
            Spacer()
            VStack(alignment: .center){
                Text("Max:").bold()
                Text(String(getMax()))
            }
            Spacer()
        }
    }
    
    func getMin()->Double{
        if pickerSelection == 0{
            return temperatureAggregationsVM.minimumsDay[index]
        }else if pickerSelection == 1{
            return temperatureAggregationsVM.minimumsWeek[index]
        }else{
            return temperatureAggregationsVM.minimumsMonth[index]
        }
    }
    func getAvg()->Double{
        if pickerSelection == 0{
            return temperatureAggregationsVM.averagesDay[index]
        }else if pickerSelection == 1{
            return temperatureAggregationsVM.averagesWeek[index]
        }else{
            return temperatureAggregationsVM.averagesMonth[index]
        }
    }
    func getMax()->Double{
        if pickerSelection == 0{
            return temperatureAggregationsVM.maximumsDay[index]
        }else if pickerSelection == 1{
            return temperatureAggregationsVM.maximumsWeek[index]
        }else{
            return temperatureAggregationsVM.maximumsMonth[index]
        }
    }
    
}

