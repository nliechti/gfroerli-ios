//
//  SensorOverViewGraph.swift
//  iOS
//
//  Created by Marc Kramer on 11.09.20.
//

import SwiftUI

struct SensorOverViewGraph: View {
    
    var id: Int
    @StateObject var monthVM = MonthlyAggregationsViewModel()
    @StateObject var weekVM = WeeklyAggregationsViewModel()
    @StateObject var dayVM = HourlyAggregationsViewModel()
    
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
        self.id = sensorID
        
    }
    var body: some View {
        VStack(alignment: .leading){
            HStack(alignment: .firstTextBaseline){
                Text("History").font(.title).bold()
                Spacer()
            }
            Picker(selection: $pickerSelection, label: Text("")) {
                ForEach(0..<pickerOptions.count) { index in
                    Text(self.pickerOptions[index]).tag(index)
                }
            }.pickerStyle(SegmentedPickerStyle())
            .padding(.bottom)
            switch pickerSelection{
            case 0: DayChart(hourlyAggVM: dayVM, showMin: $showMin, showMax: $showMax, showAvg: $showAvg, showCircles: $showCircles)
                .onTapGesture {showCircles.toggle()}
                .frame(minHeight: 300)
                
            case 1: WeekChart(weekAggVM: weekVM, showMin: $showMin, showMax: $showMax, showAvg: $showAvg, showCircles: $showCircles)
                .onTapGesture {showCircles.toggle()}
                .frame(minHeight: 300)
                
            default : MonthChart(monthVM: monthVM, showMin: $showMin, showMax: $showMax, showAvg: $showAvg, showCircles: $showCircles).onTapGesture {
                showCircles.toggle()
            }.frame(minHeight: 300)
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
            dayVM.id = id
            weekVM.id = id
            monthVM.id = id
            
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
    @StateObject var hourlyAggVM: HourlyAggregationsViewModel
    @Binding var showMin: Bool
    @Binding var showMax: Bool
    @Binding var showAvg: Bool
    @Binding var showCircles: Bool
    @State var date = Date()
    @State var openDate : Date = Date()
    
    var body: some View {
        VStack{
            GeometryReader{ geo in
                AsyncContentView(source: hourlyAggVM) { data in
                    VStack(alignment:.leading){
                        if notNilCount(data: data)>1 {
                            HourlyChartView(showMax: $showMax, showMin: $showMin, showAvg: $showAvg, showCircles: $showCircles, data: data, frame: geo.frame(in: .local)).padding(.bottom)
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
                }
            }
            Spacer()
            HStack{
                Spacer()
                Button(action: {
                    date = date.addingTimeInterval(TimeInterval(-86400))
                    hourlyAggVM.date = date
                }, label: {
                    Image(systemName: "arrow.left.circle").imageScale(.large)
                })
                Spacer()
                Text(date, style: .date).font(.headline)
                Spacer()
                Button(action: {
                    date = date.addingTimeInterval(TimeInterval(+86400))
                    hourlyAggVM.date = date
                    
                }, label: {
                    Image(systemName: "arrow.right.circle").imageScale(.large)
                }).disabled(date==openDate)
                Spacer()
            }.padding(.top,25)
            
            
        }.onAppear {
            hourlyAggVM.date = openDate
            openDate = date
            hourlyAggVM.load()
        }
    }
    
    func notNilCount(data: [HourlyAggregation?])->Int{
        return data.filter({$0 != nil}).count
    }
}
struct WeekChart: View {
    @StateObject var weekAggVM: WeeklyAggregationsViewModel
    @Binding var showMin: Bool
    @Binding var showMax: Bool
    @Binding var showAvg: Bool
    @Binding var showCircles: Bool
    @State var startDate = Calendar.current.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: Date()).date! {
        didSet{
            endDate = Calendar.current.date(byAdding: .day, value: 6, to: startDate)!
        }
    }
    @State var endDate = Calendar.current.date(byAdding: .day, value: 6, to: Calendar.current.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: Date()).date!)!
    @State var currentDate = Date()
    
    var body: some View {
        VStack{
            GeometryReader{ geo in
                AsyncContentView(source: weekAggVM) { data in
                    VStack(alignment:.leading){
                        if data.count>1 {
                            WeeklyChartView(showMax: $showMax, showMin: $showMin, showAvg: $showAvg, showCircles: $showCircles, daySpan:.week, data: data , frame: geo.frame(in: .local))
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
                }
            }
            Spacer()
            HStack{
                Spacer(minLength: 0)
                Button(action: {
                    startDate = Calendar.current.date(byAdding: .day, value: -7, to: startDate)!
                    weekAggVM.date = startDate
                    
                }, label: {
                    Image(systemName: "arrow.left.circle").imageScale(.large)
                })
                Spacer(minLength: 0)
                Text(formatDateText(start: startDate, end: endDate)).font(.headline)
                Spacer(minLength: 0)
                Button(action: {
                    startDate = Calendar.current.date(byAdding: .day, value: 7, to: startDate)!
                    weekAggVM.date = startDate
                }, label: {
                    Image(systemName: "arrow.right.circle").imageScale(.large)
                }).disabled(currentDate<=endDate)
                Spacer(minLength: 0)
            }.padding(.top,25)
        }.onAppear {
            startDate = Calendar.current.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: Date()).date!
            weekAggVM.load()
        }
        .onDisappear{
            startDate = Calendar.current.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: Date()).date!
            weekAggVM.date = startDate
        }
    }
    func formatDateText(start:Date, end: Date)-> String{
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "dd MMMM yyyy"
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "dd"
        let st = dateFormatter2.string(from: start)
        let en = dateFormatter1.string(from: end)
        return "\(st) - \(en)"
    }
}

struct MonthChart: View {
    @ObservedObject var monthVM: MonthlyAggregationsViewModel
    @Binding var showMin: Bool
    @Binding var showMax: Bool
    @Binding var showAvg: Bool
    @Binding var showCircles: Bool
    @State var startDate = Calendar.current.dateComponents([.calendar, .month, .year], from: Date()).date! {
        didSet{
            endDate = Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: startDate)!
        }
    }
    @State var endDate = Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: Calendar.current.dateComponents([.calendar, .month, .year], from: Date()).date!)!
    @State var currentDate = Date()
    var body: some View {
        VStack{
            GeometryReader{ geo in
                AsyncContentView(source: monthVM) { data in
                    VStack(alignment:.leading){
                        if data.count>1 {
                            MonthlyChartView(showMax: $showMax, showMin: $showMin, showAvg: $showAvg, showCircles: $showCircles, daySpan: .month, data: data, frame: geo.frame(in: .local))
                            
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
                }
            }
            Spacer()
            HStack{
                Spacer(minLength: 0)
                Button(action: {
                    startDate = Calendar.current.date(byAdding: DateComponents(month: -1), to: startDate)!
                    monthVM.date = startDate
                    
                }, label: {
                    Image(systemName: "arrow.left.circle").imageScale(.large)
                })
                Spacer(minLength: 0)
                Text(formatDateText(start: startDate, end: endDate)).font(.headline)
                Spacer(minLength: 0)
                Button(action: {
                    startDate = Calendar.current.date(byAdding: DateComponents(month: 1), to: startDate)!
                    monthVM.date = startDate
                }, label: {
                    Image(systemName: "arrow.right.circle").imageScale(.large)
                }).disabled(currentDate<=endDate)
                Spacer(minLength: 0)
            }.padding(.top,25)
            
            
        }.onAppear {
            startDate = Calendar.current.dateComponents([.calendar, .month, .year], from: Date()).date!
            
            monthVM.load()
        }
        .onDisappear{
            startDate = Calendar.current.dateComponents([.calendar, .month, .year], from: Date()).date!
            monthVM.date = startDate
        }
        
    }
    func formatDateText(start:Date, end: Date)-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        let st = dateFormatter.string(from: start)
        
        return st
    }
}
