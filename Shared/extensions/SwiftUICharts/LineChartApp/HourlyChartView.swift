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
        if data.isEmpty{
            return[0.0]
        }
        
        
        
        var normedData = [Double].init(repeating: 0.000001, count: 25)
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let string = df.string(from: Date())
        var currHour = Calendar.current.component(.hour, from: Date())
        
        
        switch type {
        case .average:
            var currPos = data.first!.hour!
            var dataInd = 1 // 1 because first index gets handled in forloop
            var currentStep = 0.0
            var lastPos = 0
            
            //Fill entries upto first entries hour with first entries temp
            var currVal = data.first!.avgTemp!
            for i in 0...currPos-currHour{
                normedData[i] = currVal
                lastPos=i
                currHour += 1
            }
            lastPos += 1
            while dataInd < data.count{
            //if next entry is also next hour fill it in else grab next entry and interpolate values until its position
            if data[dataInd].hour! == currHour{
                normedData[lastPos] = data[dataInd].avgTemp!
                currVal = data[dataInd].avgTemp!
                lastPos += 1
                dataInd += 1
                currHour = (currHour+1)%24
            }else{
                var steps = data[dataInd].hour! - currHour  //number of hours between current entry and next entry
                var tempDiff = data[dataInd].avgTemp!-currVal
                if steps < 0{
                    steps += 23
                }
                currentStep = tempDiff/Double(steps+1) // step size
                
                for i in 1..<steps+1{
                    normedData[lastPos] = data[dataInd-1].avgTemp! + Double(i)*currentStep
                    lastPos += 1
                }
                
                normedData[lastPos] = data[dataInd].avgTemp!
                currHour = data[dataInd].hour!
                
            }
            }
            while normedData.count <= 25 {
                normedData.append(data.last!.avgTemp!)
            }
        case .maximum:
            var currPos = data.first!.hour!
            var dataInd = 1 // 1 because first index gets handled in forloop
            var currentStep = 0.0
            var lastPos = 0
            
            //Fill entries upto first entries hour with first entries temp
            var currVal = data.first!.maxTemp!
            for i in 0...currPos-currHour{
                normedData[i] = currVal
                lastPos=i
                currHour += 1
            }
            lastPos += 1
            while dataInd < data.count{
            //if next entry is also next hour fill it in else grab next entry and interpolate values until its position
            if data[dataInd].hour! == currHour{
                normedData[lastPos] = data[dataInd].maxTemp!
                currVal = data[dataInd].maxTemp!
                lastPos += 1
                dataInd += 1
                currHour = (currHour+1)%24
            }else{
                var steps = data[dataInd].hour! - currHour  //number of hours between current entry and next entry
                var tempDiff = data[dataInd].maxTemp!-currVal
                if steps < 0{
                    steps += 23
                }
                currentStep = tempDiff/Double(steps+1) // step size
                
                for i in 1..<steps+1{
                    normedData[lastPos] = data[dataInd-1].maxTemp! + Double(i)*currentStep
                    lastPos += 1
                }
                
                normedData[lastPos] = data[dataInd].maxTemp!
                currHour = data[dataInd].hour!
                
            }
            }
            while normedData.count <= 25 {
                normedData.append(data.last!.maxTemp!)
            }
        case .minimum:
            var currPos = data.first!.hour!
            var dataInd = 1 // 1 because first index gets handled in forloop
            var currentStep = 0.0
            var lastPos = 0
            
            //Fill entries upto first entries hour with first entries temp
            var currVal = data.first!.minTemp!
            for i in 0...currPos-currHour{
                normedData[i] = currVal
                lastPos=i
                currHour += 1
            }
            lastPos += 1
            while dataInd < data.count{
            //if next entry is also next hour fill it in else grab next entry and interpolate values until its position
            if data[dataInd].hour! == currHour{
                normedData[lastPos] = data[dataInd].minTemp!
                currVal = data[dataInd].minTemp!
                lastPos += 1
                dataInd += 1
                currHour = (currHour+1)%24
            }else{
                var steps = data[dataInd].hour! - currHour//number of hours between current entry and next entry
                if steps<0 {
                    steps += 23
                }
                var tempDiff = data[dataInd].minTemp!-currVal
                currentStep = tempDiff/Double(steps+1) // step size
                
                for i in 1..<steps+1{
                    normedData[lastPos] = data[dataInd-1].minTemp! + Double(i)*currentStep
                    lastPos += 1
                }
                
                normedData[lastPos] = data[dataInd].minTemp!
                currHour = data[dataInd].hour!
                
            }
            }
            while normedData.count <= 25 {
                normedData.append(data.last!.minTemp!)
            }
        }
        
        
        return normedData
        
    }
    
    
    
    
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let xMultiplier = rect.width / CGFloat(data.count - 1)
        let yMultiplier = rect.height / CGFloat(maxVal-minVal)
        
        for (index, dataPoint) in data.enumerated() {
            if dataPoint == 0.000001{
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
            print(index)
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
        var offset = Calendar.current.component(.hour, from: Date())
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
