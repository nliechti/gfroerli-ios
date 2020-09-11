//
//  SensorOverViewGraph.swift
//  iOS
//
//  Created by Marc Kramer on 11.09.20.
//

import SwiftUI

struct SensorOverViewGraph: View {
    @StateObject var measurementsVM = measurementsViewModel()
    @State var pickerSelection = 0
    @State var pickerOptions = ["Day", "Week", "Month"]
    
    var body: some View {
        VStack(alignment: .leading){
            Text("History").font(.title).bold()
            
            Picker(selection: $pickerSelection, label: Text("")) {
                ForEach(0..<pickerOptions.count) { index in
                    Text(self.pickerOptions[index]).tag(index)
                }
            }.pickerStyle(SegmentedPickerStyle())
            
            switch pickerSelection{
            case 0: DayChart(measurementsVM: measurementsVM).padding(.vertical)
            case 1: WeekChart(measurementsVM: measurementsVM).padding(.vertical)
            default : MonthChart(measurementsVM: measurementsVM).padding(.vertical)
            }
            
        }
    }
}

struct SensorOverViewGraph_Previews: PreviewProvider {
    static var previews: some View {
        SensorOverViewGraph()
    }
}
struct DayChart: View {
    @ObservedObject var measurementsVM : measurementsViewModel
    var body: some View {
        if measurementsVM.measurementsArrayDay.count != 0{
            LineView(data: makeDate(data: measurementsVM.measurementsArrayDay))
        }else{
            VStack{
                HStack {
                    Spacer()
                    ProgressView().progressViewStyle(CircularProgressViewStyle())
                    Spacer()
                }
                HStack {
                    Spacer()
                    Text("Loading").foregroundColor(.gray)
                    Spacer()
                }
            }.frame(height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }
    }
    func makeDate(data: [Measurement])->[Double]{
        var plotData = [Double]()
        for meas in data{
            plotData.append(meas.temperature!)
        }
        return plotData
    }
}
struct WeekChart: View {
    @ObservedObject var measurementsVM : measurementsViewModel
    var body: some View {
        if measurementsVM.measurementsArrayWeek.count != 0{
            LineView(data: makeDate(data: measurementsVM.measurementsArrayWeek))
        }else{
            VStack{
                HStack {
                    Spacer()
                    ProgressView().progressViewStyle(CircularProgressViewStyle())
                    Spacer()
                }
                HStack {
                    Spacer()
                    Text("Loading").foregroundColor(.gray)
                    Spacer()
                }
            }.frame(height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }
    }
    func makeDate(data: [Measurement])->[Double]{
        var plotData = [Double]()
        for meas in data{
            plotData.append(meas.temperature!)
        }
        return plotData
    }
}
struct MonthChart: View {
    @ObservedObject var measurementsVM : measurementsViewModel
    var body: some View {
        if measurementsVM.measurementsArrayMonth.count != 0{
            LineView(data: measurementsVM.measurementsArrayMonth)
        }else{
            VStack{
                HStack {
                    Spacer()
                    ProgressView().progressViewStyle(CircularProgressViewStyle())
                    Spacer()
                }
                HStack {
                    Spacer()
                    Text("Loading").foregroundColor(.gray)
                    Spacer()
                }
            }.frame(height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }
    }
}
