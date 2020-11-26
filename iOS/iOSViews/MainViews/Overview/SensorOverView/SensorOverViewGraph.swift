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
            .onAppear(perform: {
                
            })
            Divider()
            switch pickerSelection{
            case 0: DayChart(tempAggregVM: tempAggVM, loadingState: $dayLoading)
            case 1: EmptyView()//WeekChart(measurementsVM: measurementsVM, loadingState: $weekLoading, sensorID: $sensorID).padding(.vertical)
            default : EmptyView()//MonthChart(loadingState: $monthLoading, measurementsVM: measurementsVM, sensorID: $sensorID).padding(.vertical)
            }
        }.padding()
        .onAppear(perform: {
            tempAggVM.loadAggregationsDay(sensorID: sensorID) { (result) in
                switch result {
                case .success(let str):
                    dayLoading = .loaded
                    print(str)
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
    var body: some View {
        switch loadingState{
        case .loading:
            LoadingView().frame(height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            
        case .loaded:
            LineView(data: makeDate(data: tempAggregVM.dataDay))
        case .error:
            ErrorView().frame(height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }
        
    }
    
    func makeDate(data: [HourlyAggregation])->[Double]{
            var plotData = [Double]()
            for entry in data{
                plotData.append(entry.avgTemp!)
            }
            return plotData
        }
    
}
struct WeekChart: View {
    @ObservedObject var tempAggrVM : TempAggregationsViewModel
    @Binding var loadingState : loadingState
    @Binding var sensorID: Int
    var body: some View {
        switch loadingState{
        case .loading:
            LoadingView().frame(height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        case .loaded:
            Text("Add")
        case .error:
            ErrorView().frame(height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }
    }
}
struct MonthChart: View {
    @Binding var loadingState : loadingState
    @ObservedObject var tempAggrVM : TempAggregationsViewModel
    @Binding var sensorID: Int
    var body: some View {
        switch loadingState{
        case .loading:
            LoadingView().frame(height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            
        case .loaded:
            Text("Add")
        case .error:
            ErrorView().frame(height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }
        
    }
}
