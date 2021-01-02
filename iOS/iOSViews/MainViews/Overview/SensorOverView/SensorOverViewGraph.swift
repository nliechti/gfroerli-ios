//
//  SensorOverViewGraph.swift
//  iOS
//
//  Created by Marc Kramer on 11.09.20.
//

import SwiftUI

struct SensorOverViewGraph: View {
    
    var sensorID: Int
    @StateObject var tempAggVM = TempAggregationsViewModel()
    @State var pickerSelection = 0
    @State var pickerOptions = [NSLocalizedString("Day", comment: ""), NSLocalizedString("Week", comment: ""), NSLocalizedString("Month", comment: "")]
    
    @State var dayLoading: loadingState = .loading
    @State var weekLoading: loadingState = .loading
    @State var monthLoading: loadingState = .loading
    
    @State var showMin = false
    @State var showMax = false
    @State var showAvg = true
    @State var showCircles = true

    
    init(sensorID: Int) {
        self.sensorID = sensorID
        
    }
    var body: some View {
        VStack(alignment: .leading){
            Text("History").font(.title).bold()
            
            Picker(selection: $pickerSelection, label: Text("")) {
                ForEach(0..<pickerOptions.count) { index in
                    Text(self.pickerOptions[index]).tag(index)
                }
            }.pickerStyle(SegmentedPickerStyle())
            .padding(.bottom)
            
            switch pickerSelection{
            case 0: DayChart(tempAggregVM: tempAggVM, loadingState: $dayLoading, showMin: $showMin, showMax: $showMax, showAvg: $showAvg, showCircles: $showCircles).onTapGesture {
                showCircles.toggle()
            }
            case 1: WeekChart(tempAggregVM: tempAggVM, loadingState: $weekLoading, showMin: $showMin, showMax: $showMax, showAvg: $showAvg, showCircles: $showCircles).onTapGesture {
                showCircles.toggle()
            }
            default : MonthChart(tempAggregVM: tempAggVM, loadingState: $monthLoading, showMin: $showMin, showMax: $showMax, showAvg: $showAvg, showCircles: $showCircles).onTapGesture {
                showCircles.toggle()
            }
            }
            Text("Tap to show:").padding(.top)
            HStack{
                Button {
                    showAvg.toggle()
                } label: {
                    Image(systemName: showAvg ? "checkmark.circle.fill": "circle").foregroundColor(.green)
                    Text("Average").lineLimit(1)
                        .minimumScaleFactor(0.1)
                }
                Spacer()
                Button {
                    showMin.toggle()
                } label: {
                    Image(systemName: showMin ? "checkmark.circle.fill": "circle").foregroundColor(.blue)
                    Text("Minimum").lineLimit(1)
                        .minimumScaleFactor(0.1)
                }
                Spacer()
                Button {
                    showMax.toggle()
                } label: {
                    Image(systemName: showMax ? "checkmark.circle.fill": "circle").foregroundColor(.red)
                    Text("Maximum").lineLimit(1)
                        .minimumScaleFactor(0.1)
                }
            }.padding(.top,3)
            
        }.padding()
        .onAppear(perform: {
            tempAggVM.loadAggregationsDay(sensorID: sensorID) { (result) in
                switch result {
                case .success(_):
                    dayLoading = .loaded
                case .failure(let error):
                    dayLoading = .error
                    switch error {
                    case .badURL:
                        print("Bad URL")
                    case .requestFailed:
                        print("Network problems")
                    case.decodeFailed:
                        print("Decoding data failed")
                    case .unknown:
                        print("Unknown error")
                    }
                }
            }
            tempAggVM.loadAggregationsWeek(sensorID: sensorID) { (result) in
                switch result {
                case .success(_):
                    weekLoading = .loaded
                case .failure(let error):
                    weekLoading = .error
                    switch error {
                    case .badURL:
                        print("Bad URL")
                    case .requestFailed:
                        print("Network problems")
                    case.decodeFailed:
                        print("Decoding data failed")
                    case .unknown:
                        print("Unknown error")
                    }
                }
            }
            tempAggVM.loadAggregationsMonth(sensorID: sensorID) { (result) in
                switch result {
                case .success(_):
                    monthLoading = .loaded
                case .failure(let error):
                    monthLoading = .error
                    switch error {
                    case .badURL:
                        print("Bad URL")
                    case .requestFailed:
                        print("Network problems")
                    case.decodeFailed:
                        print("Decoding data failed")
                    case .unknown:
                        print("Unknown error")
                    }
                }
            }
        })
    }
}

struct SensorOverViewGraph_Previews: PreviewProvider {
    static var previews: some View {
        SensorOverViewGraph(sensorID: 1)
            .makePreViewModifier()
        
    }
}
struct DayChart: View {
    @ObservedObject var tempAggregVM : TempAggregationsViewModel
    @Binding var loadingState : loadingState
    @Binding var showMin : Bool
    @Binding var showMax : Bool
    @Binding var showAvg : Bool
    @Binding var showCircles: Bool

    var body: some View {
        VStack{
            GeometryReader{ geo in
                switch loadingState{
                case .loading:
                    LoadingView().frame(height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    
                case .loaded:
                    VStack(alignment:.leading){
                    if tempAggregVM.dataDay.count>1 {
                        HourlyChartView(showMax: $showMax, showMin: $showMin, showAvg: $showAvg, showCircles: $showCircles, data: tempAggregVM.dataDay, frame: geo.frame(in: .local))
                    
                    }else{
                        Spacer()
                        HStack {
                            Spacer()
                            Text("No data available").font(.callout).foregroundColor(.secondary)
                            Spacer()
                        }
                        Spacer()
                    }
                    }
                case .error:
                    ErrorView().frame(height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                }
            }
        }
    }
    
}
struct WeekChart: View {
    @ObservedObject var tempAggregVM : TempAggregationsViewModel
    @Binding var loadingState : loadingState
    @Binding var showMin : Bool
    @Binding var showMax : Bool
    @Binding var showAvg : Bool
    @Binding var showCircles: Bool
    
    var body: some View {
        VStack{
            GeometryReader{ geo in
                switch loadingState{
                case .loading:
                    LoadingView().frame(height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    
                case .loaded:
                    VStack(alignment:.leading){
                        
                        DailyChartView(showMax: $showMax, showMin: $showMin, showAvg: $showAvg, showCircles: $showCircles, daySpan: .week, data: tempAggregVM.dataWeek, frame: geo.frame(in: .local))
                    }
                case .error:
                    ErrorView().frame(height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                }
            }
        }
    }
}
struct MonthChart: View {
    @ObservedObject var tempAggregVM : TempAggregationsViewModel
    @Binding var loadingState : loadingState
    @Binding var showMin : Bool
    @Binding var showMax : Bool
    @Binding var showAvg : Bool
    @Binding var showCircles: Bool

    var body: some View {
        VStack{
            GeometryReader{ geo in
                switch loadingState{
                case .loading:
                    LoadingView().frame(height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    
                case .loaded:
                    VStack(alignment:.leading){
                        
                        DailyChartView(showMax: $showMax, showMin: $showMin, showAvg: $showAvg, showCircles: $showCircles, daySpan: .month, data: tempAggregVM.dataMonth, frame: geo.frame(in: .local))
                    }
                case .error:
                    ErrorView().frame(height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                }
            }
        }
    }
}
