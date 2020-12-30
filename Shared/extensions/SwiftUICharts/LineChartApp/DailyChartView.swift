//
//  DailyChartView.swift
//  iOS
//
//  Created by Marc Kramer on 01.12.20.
//

import SwiftUI

struct DailyLineChartShape: Shape {
    var data: [Double]
    var pointSize: CGFloat
    var maxVal : Double
    var minVal: Double
    var hours: [Int]
    var tempType: tempType
    var daySpan: DaySpan
    var showCircles: Bool
    
    init(pointSize: CGFloat, data: [DailyAggregation],type: tempType, span: DaySpan, max: Double, min : Double, showCircles: Bool){
        self.tempType = type
        self.data = DailyLineChartShape.createData(data: data, type: type,span: span)
        self.pointSize = pointSize
        self.maxVal = max
        self.minVal = min
        hours = DailyLineChartShape.getDays(data: data)
        daySpan = span
        self.showCircles = showCircles
    }
    
    
    
    static func getDays(data:[DailyAggregation])->[Int]{
        var days = [Int]();
        for p in data{
            days.append(Int(p.date!.suffix(2))!)
        }
        return days
    }
    
    static func createData(data: [DailyAggregation], type: tempType, span: DaySpan)->[Double]{
        var normedData = [Double].init(repeating: 0.0, count: data.count)
        
        switch type {
        case .average:
            for i in 0..<data.count{
                normedData[i] = data[i].avgTemp!
            }
            
        case .minimum:
            for i in 0..<data.count{
                normedData[i] = data[i].minTemp!
            }
            
        case .maximum:
            for i in 0..<data.count{
                normedData[i] = data[i].maxTemp!
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
            
            path.addEllipse(in: CGRect(x: x , y: y, width: pointSize, height: pointSize))
            path.move(to: CGPoint(x: x+pointSize/2, y: y+pointSize/2))
            
            }
        }
        return path
        
    }
    
}

struct DailyChartView: View{
    
    @Binding var showMax : Bool
    @Binding var showMin : Bool
    @Binding var showAvg : Bool
    @Binding var showCircles : Bool
    var avgColor: Color?
    var daySpan : DaySpan
    let data: [DailyAggregation]
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
        VStack{
        ZStack(alignment: .center) {
            
            Legend(frame: frame, xLabels: getXLabels(data: data), max: CGFloat(maxVal), min:CGFloat(minVal))
            
            DailyLineChartShape(pointSize: pointSize, data: data, type: .minimum,span: daySpan, max: maxVal, min: minVal, showCircles: showCircles)
                .stroke(showMin ? Color.blue : Color.clear,style: StrokeStyle(lineWidth: 2,lineCap: .round, lineJoin: .round)).frame(width: frame.width-40, height: frame.height).offset(x:+20)
            DailyLineChartShape(pointSize: pointSize, data: data, type: .maximum,span: daySpan, max: maxVal, min: minVal, showCircles: showCircles)
                .stroke(showMax ? Color.red : Color.clear, style: StrokeStyle(lineWidth: 2,lineCap: .round, lineJoin: .round)).frame(width: frame.width-40, height: frame.height).offset(x:+20)
            DailyLineChartShape(pointSize: pointSize, data: data, type: .average, span: daySpan, max: maxVal, min: minVal, showCircles: showCircles)
                .stroke(showAvg ? ((avgColor != nil) ? Color.white : Color.green) : Color.clear,style: StrokeStyle(lineWidth: 2,lineCap: .round, lineJoin: .round)).frame(width: frame.width-40, height: frame.height).offset(x:+20)
            
    
        }
        Spacer()
        HStack{
            Text("0.00").foregroundColor(.clear)
                .font(.caption)
            Text(xLabels[0]).foregroundColor(Color.secondary)
                .font(.caption)
            Spacer()
            Text(xLabels[1]).foregroundColor(Color.secondary)
                .font(.caption)
            Spacer()
            Text(xLabels[2]).foregroundColor(Color.secondary)
                .font(.caption)
        }
        }
    }
    func getXLabels(data: [DailyAggregation]) -> [String] {
        var labels = [String]()
        var mid: Int = data.count/2
        labels.append(makeDMString(string: data.first!.date!))
        labels.append(makeDMString(string: data[mid].date!))
        labels.append(makeDMString(string: data.last!.date!))
        return labels
    }
    func makeDMString(string: String)->String{
        var str = string
        var str1 = str.removeLast(3)
        var str2 = str.suffix(2)
        return string.suffix(2)+"."+str2+"."
    }
}

struct DailyChartView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
