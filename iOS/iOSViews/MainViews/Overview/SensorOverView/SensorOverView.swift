//
//  SensorOverView.swift
//  iOS
//
//  Created by Marc Kramer on 22.08.20.
//

import SwiftUI

struct SensorOverView: View {
    @ObservedObject var measurementsVM = measurementsViewModel()
    @State var sensor: Sensor
    @State var isFav = false
    @State var pickerSelection = 0
    @State var pickerOptions = ["Day", "Week", "Month"]
    
    @State var favorites  = UserDefaults(suiteName: "group.ch.gfroerli.gfroerli")?.array(forKey: "favoritesIDs") as? [Int] ?? [Int]()
    var body: some View {
        
        VStack(alignment:.leading){
            
            VStack(alignment: .leading){
                HStack {
                    Text("Last Measurement").font(.headline)
                    Spacer()
                }
                Text(String(format: "%.1f", sensor.last_measurement!.temperature!)+"°" ?? "Unavailable").font(.system(size: 50))
                HStack {
                    Text(createGoodDate(string: sensor.last_measurement!.created_at!), style: .time)
                    Text(createGoodDate(string: sensor.last_measurement!.created_at!), style: .date)
                }
                HStack {
                    Text("History").font(.headline)
                    Spacer()
                }
                Picker(selection: $pickerSelection, label: Text("What is your favorite color?")) {
                    ForEach(0..<pickerOptions.count) { index in
                        Text(self.pickerOptions[index]).tag(index)
                    }
                }.pickerStyle(SegmentedPickerStyle())
                
                switch pickerSelection{
                case 0: DayChart(measurementsVM: measurementsVM)
                case 1: WeekChart(measurementsVM: measurementsVM)
                default : MonthChart(measurementsVM: measurementsVM)
                }
                HStack {
                    Text("Description").font(.headline)
                    Spacer()
                }
                Text(sensor.caption!)
                HStack {
                    Text("Sponsor").font(.headline)
                    Spacer()
                }
            }
            Text("TBD")
            Spacer()
        }.padding()
        .onAppear {
            isFav = favorites.contains(sensor.id!)
        }.navigationTitle(Text(sensor.device_name!))
        .navigationBarItems(trailing:
                                Button {
                                    isFav ? removeFav() : makeFav()
                                    UserDefaults(suiteName: "group.ch.gfroerli.gfroerli")?.set(favorites, forKey: "favoritesIDs")
                                } label: {
                                    Image(systemName: isFav ? "star.fill" : "star")
                                        .foregroundColor(isFav ? .yellow : .none)
                                })
    }
    
    
    func makeFav(){
        favorites.append(sensor.id!)
        isFav = true
    }
    func removeFav(){
        favorites.removeFirst(sensor.id!)
        isFav=false
    }
    func createGoodDate(string: String)->Date{
        var newDate = string
        newDate.removeLast(5)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date = dateFormatter.date(from:newDate)!
        return date
    }
    
}

struct SensorOverView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            SensorOverView(sensor: testSensor)
        }
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
