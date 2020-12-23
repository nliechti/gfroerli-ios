//
//  ChartView.swift
//  iOS
//
//  Created by Marc Kramer on 30.11.20.
//

import SwiftUI

struct HourlyLineChartShape: Shape {
    var data: [Double]
    var pointSize: CGFloat
    var maxVal : Double
    var minVal: Double
    var hours: [Int]
    var tempType: tempType
    var showCircles: Bool
    
    init(pointSize: CGFloat, data: [HourlyAggregation],type: tempType, max: Double, min : Double,showCircles: Bool){
        self.tempType = type
        self.data = HourlyLineChartShape.createData(data: data, type: type)
        self.pointSize = pointSize
        self.maxVal = max
        self.minVal = min
        hours = HourlyLineChartShape.getHours(data: data)
        self.showCircles = showCircles
    }
    
    static func createData(data: [HourlyAggregation], type: tempType)->[Double]{
        //if no data available
        if data.isEmpty {return [0.0]}
        
        switch type{
        case .average:
            // init needed variables
            var temperatureArray = [Double].init(repeating: 0.0, count: 25)
            var currentHour = Calendar.current.component(.hour, from: Date())
            var dataHour = data.first!.hour!
            var tempArrIndex = 0
            var dataIndex = 0
            
            
            //fill hours from -24h until first available point
            for index in 0...(dataHour-currentHour+24)%24{
                temperatureArray[index] = data.first!.avgTemp!
                tempArrIndex=index
            }
            while dataIndex < data.count-1 {
              
            //check if next datapoint is subsequent hour of last entry
            if data[dataIndex+1].hour! == ((data[dataIndex].hour!+1)%24){
                tempArrIndex+=1
                dataIndex+=1
                temperatureArray[tempArrIndex] = data[dataIndex].avgTemp!
            }else{
                //calculate steps BETWEEEN hours and step value
                var steps = (data[dataIndex+1].hour!-data[dataIndex].hour!-1+24)%24
                var stepTemp = (data[dataIndex+1].avgTemp!-data[dataIndex].avgTemp!)/(Double(steps+1))
                var lastTemp = data[dataIndex].avgTemp!
                //fill steps
                for s in 1...steps{
                    tempArrIndex+=1
                    temperatureArray[tempArrIndex] = lastTemp + Double(s)*stepTemp
                }
                //fill value of datapoint
                tempArrIndex+=1
                dataIndex+=1
                temperatureArray[tempArrIndex] = data[dataIndex].avgTemp!
            }
            }
            //fill remaining slots with data of last index
            while tempArrIndex < 24{
                tempArrIndex+=1
                temperatureArray[tempArrIndex]=data.last!.avgTemp!
            }
            return temperatureArray
            
        case .minimum:
            // init needed variables
            var temperatureArray = [Double].init(repeating: 0.0, count: 25)
            var currentHour = Calendar.current.component(.hour, from: Date())
            var dataHour = data.first!.hour!
            var tempArrIndex = 0
            var dataIndex = 0
            
            
            //fill hours from -24h until first available point
            for index in 0...(dataHour-currentHour+24)%24{
                temperatureArray[index] = data.first!.minTemp!
                tempArrIndex=index
            }
            while dataIndex < data.count-1 {
              
            //check if next datapoint is subsequent hour of last entry
            if data[dataIndex+1].hour! == ((data[dataIndex].hour!+1)%24){
                tempArrIndex+=1
                dataIndex+=1
                temperatureArray[tempArrIndex] = data[dataIndex].minTemp!
            }else{
                //calculate steps BETWEEEN hours and step value
                var steps = (data[dataIndex+1].hour!-data[dataIndex].hour!-1+24)%24
                var stepTemp = (data[dataIndex+1].minTemp!-data[dataIndex].minTemp!)/(Double(steps+1))
                var lastTemp = data[dataIndex].minTemp!
                //fill steps
                for s in 1...steps{
                    tempArrIndex+=1
                    temperatureArray[tempArrIndex] = lastTemp + Double(s)*stepTemp
                }
                //fill value of datapoint
                tempArrIndex+=1
                dataIndex+=1
                temperatureArray[tempArrIndex] = data[dataIndex].minTemp!
            }
            }
            //fill remaining slots with data of last index
            while tempArrIndex < 24{
                tempArrIndex+=1
                temperatureArray[tempArrIndex]=data.last!.minTemp!
            }
            return temperatureArray
        case .maximum:
            // init needed variables
            var temperatureArray = [Double].init(repeating: 0.0, count: 25)
            var currentHour = Calendar.current.component(.hour, from: Date())
            var dataHour = data.first!.hour!
            var tempArrIndex = 0
            var dataIndex = 0
            
            
            //fill hours from -24h until first available point
            for index in 0...(dataHour-currentHour+24)%24{
                temperatureArray[index] = data.first!.maxTemp!
                tempArrIndex=index
            }
            while dataIndex < data.count-1 {
              
            //check if next datapoint is subsequent hour of last entry
            if data[dataIndex+1].hour! == ((data[dataIndex].hour!+1)%24){
                tempArrIndex+=1
                dataIndex+=1
                temperatureArray[tempArrIndex] = data[dataIndex].maxTemp!
            }else{
                //calculate steps BETWEEEN hours and step value
                var steps = (data[dataIndex+1].hour!-data[dataIndex].hour!-1+24)%24
                var stepTemp = (data[dataIndex+1].maxTemp!-data[dataIndex].maxTemp!)/(Double(steps+1))
                var lastTemp = data[dataIndex].maxTemp!
                //fill steps
                for s in 1...steps{
                    tempArrIndex+=1
                    temperatureArray[tempArrIndex] = lastTemp + Double(s)*stepTemp
                }
                //fill value of datapoint
                tempArrIndex+=1
                dataIndex+=1
                temperatureArray[tempArrIndex] = data[dataIndex].maxTemp!
            }
            }
            //fill remaining slots with data of last index
            while tempArrIndex < 24{
                tempArrIndex+=1
                temperatureArray[tempArrIndex]=data.last!.maxTemp!
            }
            return temperatureArray
        }
        
    }
    
    
    
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let xMultiplier = rect.width / CGFloat(data.count - 1)
        let yMultiplier = rect.height / CGFloat(maxVal-minVal)
        
        for (index, dataPoint) in data.enumerated() {
            if dataPoint == 0.0{
                continue
            }
            
            var x = xMultiplier * CGFloat(index)
            var y = yMultiplier * CGFloat(dataPoint-minVal)
            
            y = rect.height - y
            x += rect.minX
            y += rect.minY
            
            if index == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x,y: y))
            }
            if showCircles{
            x -= pointSize / 2
            y -= pointSize / 2
            if (self.hours.contains(index)){
                path.addEllipse(in: CGRect(x: x , y: y, width: pointSize, height: pointSize))
                path.move(to: CGPoint(x: x+pointSize/2, y: y+pointSize/2))
                
            }
        }
        }
       
        return path
        
    }
    static func getHours(data:[HourlyAggregation])->[Int]{
        var hours = [Int]();
        var offset = Calendar.current.component(.hour, from: Date())-1
        for p in data{
            if p.hour! >= offset{
                hours.append(p.hour! - offset)
            }else{
                hours.append(p.hour! + (23-offset))
        }
        
    }
        return hours
    }
}
struct HourlyChartView: View{
    @Binding var showMax : Bool
    @Binding var showMin : Bool
    @Binding var showAvg : Bool
    @Binding var showCircles : Bool

    let data: [HourlyAggregation]
    var lineWidth: CGFloat = 2
    var pointSize: CGFloat = 8
    var frame: CGRect
    
    var maxVal : Double {var highestPoint = data.max { $0.maxTemp! < $1.maxTemp! }
        return highestPoint?.maxTemp ?? 1}
    var minVal : Double {var lowestPoint = data.min { $0.minTemp! < $1.minTemp! }
        return lowestPoint?.minTemp ?? 1}
    var xLabels: [String]{
        return getXLabels(data: data)
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Legend(frame: frame, xLabels: getXLabels(data: data), max: CGFloat(maxVal), min:CGFloat(minVal))
            
            HourlyLineChartShape(pointSize: pointSize, data: data, type: .minimum, max: maxVal, min: minVal, showCircles: showCircles)
                .stroke(showMin ? Color.blue : Color.clear,style: StrokeStyle(lineWidth: 2,lineCap: .round, lineJoin: .round)).frame(width: frame.width-40, height: frame.height).offset(x:+20)
            HourlyLineChartShape(pointSize: pointSize, data: data, type: .maximum, max: maxVal, min: minVal, showCircles: showCircles)
                .stroke(showMax ? Color.red : Color.clear, style: StrokeStyle(lineWidth: 2,lineCap: .round, lineJoin: .round)).frame(width: frame.width-40, height: frame.height).offset(x:+20)
            HourlyLineChartShape(pointSize: pointSize, data: data, type: .average,  max: maxVal, min: minVal, showCircles: showCircles)
                .stroke(showAvg ? Color.green : Color.clear,style: StrokeStyle(lineWidth: 2,lineCap: .round, lineJoin: .round)).frame(width: frame.width-40, height: frame.height).offset(x:+20)
                
        }
        HStack{
            Text("0.00").foregroundColor(.clear)
                .font(.caption)
            Text(xLabels[0]).foregroundColor(Color(.systemGray4))
                .font(.caption)
            Spacer()
            Text(xLabels[1]).foregroundColor(Color(.systemGray4))
                .font(.caption)
            Spacer()
            Text(xLabels[2]).foregroundColor(Color(.systemGray4))
                .font(.caption)
        }
        
        
    }
    func getXLabels(data: [HourlyAggregation]) -> [String] {
        var labels = [String]()
        let hour = Calendar.current.component(.hour, from: Date())
        labels.append(String(hour)+":00")
        labels.append(String((hour+12)%24)+":00")
        labels.append(String(hour)+":00")
        return labels
    }
    
    
}
struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
        /* GeometryReader{ geo in
         HourlyChartView(data: [
         HourlyAggregation(id: "1", date: "2020-11-27", hour: 0, maxTemp: 20.0, minTemp: 1.0, avgTemp: 0.0),
         HourlyAggregation(id: "4", date: "2020-11-27", hour: 6, maxTemp: 20.0, minTemp: 7.0, avgTemp: 10.0),
         HourlyAggregation(id: "5", date: "2020-11-27", hour: 12, maxTemp: 20.0, minTemp: 9.0, avgTemp: 20.0),
         HourlyAggregation(id: "6", date: "2020-11-27", hour: 15, maxTemp: 20.0, minTemp: 25.0, avgTemp:25.0),
         HourlyAggregation(id: "7", date: "2020-11-27", hour: 23, maxTemp: 20.0, minTemp: 30.0, avgTemp: 30.0)],pointSize: 5, frame: geo.frame(in: .local))
         }.frame(width: 300,height: 200)
         }*/
    }
}
