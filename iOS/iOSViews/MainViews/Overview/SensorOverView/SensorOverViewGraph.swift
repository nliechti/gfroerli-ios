//
//  SensorOverViewGraph.swift
//  iOS
//
//  Created by Marc Kramer on 11.09.20.
//

import SwiftUI

struct SensorOverViewGraph: View {
    @State var sensorID: Int
    @StateObject var measurementsVM = MeasuringListViewModel()
    @State var pickerSelection = 0
    @State var pickerOptions = ["Day", "Week", "Month"]
    @State var dayLoading: loadingState = .loading
    @State var weekLoading: loadingState = .loading
    @State var monthLoading: loadingState = .loading
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
            case 0: DayChart(measurementsVM: measurementsVM, loadingState: $dayLoading, sensorID: $sensorID).padding(.vertical)
            case 1: WeekChart(measurementsVM: measurementsVM, loadingState: $weekLoading, sensorID: $sensorID).padding(.vertical)
            default : MonthChart(loadingState: $monthLoading, measurementsVM: measurementsVM, sensorID: $sensorID).padding(.vertical)
            }
            Divider()
            //load data
        }.onAppear(perform: {
            weekLoading = .loading
            measurementsVM.loadMeasurings(sensorID: sensorID, timeFrame: .week) { (result) in
                switch result {
                case .success(let str):
                    weekLoading = .loaded
                    print(str)
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
            
            dayLoading = .loading
            measurementsVM.loadMeasurings(sensorID: sensorID, timeFrame: .day) { (result) in
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
            
            monthLoading = .loading
            measurementsVM.loadMeasurings(sensorID: sensorID, timeFrame: .month) { (result) in
                switch result {
                case .success(let str):
                    monthLoading = .loaded
                    print(str)
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
        Group{
            SensorOverViewGraph(sensorID: 1, measurementsVM: testmeasVM)
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro Max"))
                .previewDisplayName("iPhone 11 Pro Max")
            SensorOverViewGraph(sensorID: 1, measurementsVM: testmeasVM)
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
                .previewDisplayName("iPhone 11 Pro")
            SensorOverViewGraph(sensorID: 1, measurementsVM: testmeasVM)
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .previewDisplayName("iPhone SE")
        }
        Group{
            SensorOverViewGraph(sensorID: 1, measurementsVM: testmeasVM)
                .preferredColorScheme(.dark)
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro Max"))
                .previewDisplayName("iPhone 11 Pro Max Dark")
            SensorOverViewGraph(sensorID: 1, measurementsVM: testmeasVM)
                .preferredColorScheme(.dark)
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
                .previewDisplayName("iPhone 11 Pro Dark")
            SensorOverViewGraph(sensorID: 1, measurementsVM: testmeasVM)
                .preferredColorScheme(.dark)
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .previewDisplayName("iPhone SE Dark")
                
        }
    }
}
struct DayChart: View {
    @ObservedObject var measurementsVM : MeasuringListViewModel
    @Binding var loadingState : loadingState
    @Binding var sensorID: Int
    var body: some View {
        switch loadingState{
        case .loading:
            LoadingView().frame(height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)

        case .loaded:
            LineView(data: makeDate(data: measurementsVM.measuringListDay))
        case .error:
            ErrorView().frame(height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }
        
    }
    func makeDate(data: [Measuring])->[Double]{
        var plotData = [Double]()
        for meas in data{
            plotData.append(meas.temperature!)
        }
        return plotData
    }
}
struct WeekChart: View {
    @ObservedObject var measurementsVM : MeasuringListViewModel
    @Binding var loadingState : loadingState
    @Binding var sensorID: Int
    var body: some View {
        switch loadingState{
        case .loading:
            LoadingView().frame(height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        case .loaded:
            LineView(data: makeDate(data: measurementsVM.measuringListWeek))
        case .error:
            ErrorView().frame(height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }
    }
    func makeDate(data: [Measuring])->[Double]{
        var plotData = [Double]()
        for meas in data{
            plotData.append(meas.temperature!)
        }
        return plotData
    }
}
struct MonthChart: View {
    @Binding var loadingState : loadingState
    @ObservedObject var measurementsVM : MeasuringListViewModel
    @Binding var sensorID: Int
    var body: some View {
        switch loadingState{
        case .loading:
            LoadingView().frame(height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)

        case .loaded:
            LineView(data: makeDate(data: measurementsVM.measuringListWeek))
        case .error:
            ErrorView().frame(height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }
        
    }
    func makeDate(data: [Measuring])->[Double]{
        var plotData = [Double]()
        for meas in data{
            plotData.append(meas.temperature!)
        }
        return plotData
    }
}
