//
//  MonthlyChartView.swift
//  Gfror.li
//
//  Created by Marc Kramer on 03.01.21.
//

import Foundation

import SwiftUI

struct MothlyLineChartShape: Shape {
    var data: [DailyAggregation]
    var pointSize: CGFloat
    var maxVal : Double
    var minVal: Double
    var hours: [Int]
    var tempType: tempType
    var daySpan: DaySpan
    var showCircles: Bool
    
    init(pointSize: CGFloat, data: [DailyAggregation],type: tempType, span: DaySpan, max: Double, min : Double, showCircles: Bool){
        self.tempType = type
        self.data = data
        self.pointSize = pointSize
        self.maxVal = max.rounded(.up)
        self.minVal = min.rounded(.down)
        hours = WeeklyLineChartShape.getDays(data: data)
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
        
    public  func daysBetween(start: Date, end: Date) -> Int {
       Calendar.current.dateComponents([.day], from: start, to: end).day!
    }
    
    public  func makeDateFromAggreg(string: String)->Date{
        var newDate = string
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from:newDate)!
        return date
        
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let xMultiplier = rect.width / CGFloat(31)
        let yMultiplier = rect.height / CGFloat(maxVal-minVal)
        let start = Calendar.current.date(byAdding: .day, value:-31, to:Date())!
        let end = Calendar.current.date(byAdding: .day, value:0, to:Date())!
        
        //First DataPoint
        var x = xMultiplier * CGFloat(0)
        var y = yMultiplier * CGFloat(getTemp(dataPoint: data[0])-minVal)
        var step = daysBetween(start: start, end: makeDateFromAggreg(string: data[0].date!))
        
        y = rect.height - y
        x += rect.minX
        y += rect.minY
        path.move(to: CGPoint(x: x, y: y))
        x = xMultiplier * CGFloat(step)
        path.addLine(to: CGPoint(x: x,y: y))
        if showCircles{
        x -= pointSize / 2
        y -= pointSize / 2
        
        path.addEllipse(in: CGRect(x: x , y: y, width: pointSize, height: pointSize))
        path.move(to: CGPoint(x: x+pointSize/2, y: y+pointSize/2))
        }
        
        for index in 1..<data.count {
            if daysBetween(start: makeDateFromAggreg(string: data[index-1].date!), end: makeDateFromAggreg(string: data[index].date!)) == 0{
                step+=1
            }else{
                step+=daysBetween(start: makeDateFromAggreg(string: data[index-1].date!), end: makeDateFromAggreg(string: data[index].date!))
            }
            
            
            var x = xMultiplier * CGFloat(step)
            var y = yMultiplier * CGFloat(getTemp(dataPoint: data[index])-minVal)
            
            y = rect.height - y
            x += rect.minX
            y += rect.minY
            
           
            path.addLine(to: CGPoint(x: x,y: y))
        
            if showCircles{
            x -= pointSize / 2
            y -= pointSize / 2
            
            path.addEllipse(in: CGRect(x: x , y: y, width: pointSize, height: pointSize))
            path.move(to: CGPoint(x: x+pointSize/2, y: y+pointSize/2))
            
            }
        }
        
        // last points
        step += daysBetween(start: makeDateFromAggreg(string:data[data.count-1].date!), end: end)
        x = xMultiplier * CGFloat(step)
        y = yMultiplier * CGFloat(getTemp(dataPoint: data[data.count-1])-minVal)
        y = rect.height - y
        x += rect.minX
        y += rect.minY
        path.addLine(to: CGPoint(x: x,y: y))
        return path
        
    }
    
   private func getTemp(dataPoint: DailyAggregation)->Double{
        switch tempType{
        case .average:
            return dataPoint.avgTemp!
        case.maximum:
            return dataPoint.maxTemp!
        case.minimum:
            return dataPoint.minTemp!

        }
    }
    
}

struct MonthlyChartView: View{
    
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
    
    
    var maxVal : Double {let highestPoint = data.max { $0.maxTemp! < $1.maxTemp! }
        return highestPoint?.maxTemp ?? 1}
    var minVal : Double {let lowestPoint = data.min { $0.minTemp! < $1.minTemp! }
        return lowestPoint?.minTemp ?? 1}
    var xLabels: [String]{
        return getXLabels(data: data)
    }
    
    var body: some View {
        VStack{
        ZStack(alignment: .center) {
            
            Legend(frame: frame, xLabels: getXLabels(data: data), max: CGFloat(maxVal.rounded(.up)), min:CGFloat(minVal.rounded(.down)))
            
            MothlyLineChartShape(pointSize: pointSize, data: data, type: .minimum,span: daySpan, max: maxVal, min: minVal, showCircles: showCircles)
                .stroke(showMin ? Color.blue : Color.clear,style: StrokeStyle(lineWidth: 2,lineCap: .round, lineJoin: .round)).frame(width: frame.width-40, height: frame.height).offset(x:+20)
            MothlyLineChartShape(pointSize: pointSize, data: data, type: .maximum,span: daySpan, max: maxVal, min: minVal, showCircles: showCircles)
                .stroke(showMax ? Color.red : Color.clear, style: StrokeStyle(lineWidth: 2,lineCap: .round, lineJoin: .round)).frame(width: frame.width-40, height: frame.height).offset(x:+20)
            MothlyLineChartShape(pointSize: pointSize, data: data, type: .average, span: daySpan, max: maxVal, min: minVal, showCircles: showCircles)
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
        let mid: Int = data.count/2
        labels.append(makeDMString(string: data.first!.date!))
        labels.append(makeDMString(string: data[mid].date!))
        labels.append(makeDMString(string: data.last!.date!))
        return labels
    }
    func makeDMString(string: String)->String{
        var str = string
        str.removeLast(3)
        let str2 = str.suffix(2)
        return string.suffix(2)+"."+str2+"."
    }
}

struct MonthlyChartView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
