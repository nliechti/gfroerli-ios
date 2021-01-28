//
//  MonthlyChartShape.swift
//  Gfror.li
//
//  Created by Marc on 28.01.21.
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
