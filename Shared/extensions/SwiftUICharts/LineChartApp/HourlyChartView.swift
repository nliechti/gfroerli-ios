//
//  ChartView.swift
//  iOS
//
//  Created by Marc Kramer on 30.11.20.
//

import SwiftUI

struct HourlyLineChartShape: Shape {
    var data: [HourlyAggregation]
    var pointSize: CGFloat
    var maxVal : Double
    var minVal: Double
    var tempType: tempType
    var showCircles: Bool
    
    init(pointSize: CGFloat, data: [HourlyAggregation],type: tempType, max: Double, min : Double,showCircles: Bool){
        self.tempType = type
        self.data = data
        self.pointSize = pointSize
        self.maxVal = max
        self.minVal = min
        self.showCircles = showCircles
    }
        
    
    //Calulates whole path
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let xMultiplier = rect.width / CGFloat(24)
        let yMultiplier = rect.height / CGFloat(maxVal-minVal)
        let currentHour = Calendar.current.component(.hour, from: Date())
        let dataHour = data.first!.hour!
        
        //path to first point, adds line if hours are missing
        var step = (dataHour-currentHour+24)%24
        var x = xMultiplier
        var y = yMultiplier * CGFloat(getTemp(dataPoint: data.first!)-minVal)
        y = rect.height - y
        x += rect.minX
        y += rect.minY
        path.move(to: CGPoint(x: x, y: y))
        x = xMultiplier * CGFloat(step)
        x += rect.minX
        path.addLine(to:CGPoint(x: x, y: y))
        
        //paths between data points
        for index in 0..<data.count-1 {
            //draw line to point
            var x = xMultiplier * CGFloat(step)
            var y = yMultiplier * CGFloat(getTemp(dataPoint: data[index])-minVal)
            
            y = rect.height - y
            x += rect.minX
            y += rect.minY
            path.addLine(to:CGPoint(x: x, y: y))

            
            // draw cirlce at point
            if showCircles{
            x -= pointSize / 2
            y -= pointSize / 2
            path.addEllipse(in: CGRect(x: x , y: y, width: pointSize, height: pointSize))
            path.move(to: CGPoint(x: x+pointSize/2, y: y+pointSize/2))
            }
            //calculate multilier step of next index
            if data[index+1].hour! != ((data[index].hour!+1)%24){
                //calculate hours to next datapoint and step value
                step += (data[index+1].hour!-data[index].hour!+24)%24
            }else{
                step+=1
            }
            print(step)
        }
        //last data point
         x = xMultiplier * CGFloat(step)
         y = yMultiplier * CGFloat(getTemp(dataPoint: data[data.count-1])-minVal)
        
        y = rect.height - y
        x += rect.minX
        y += rect.minY
        path.addLine(to:CGPoint(x: x, y: y))

        // draw cirlce at point
        if showCircles{
            x -= pointSize / 2
            y -= pointSize / 2
            path.addEllipse(in: CGRect(x: x , y: y, width: pointSize, height: pointSize))
            path.move(to: CGPoint(x: x+pointSize/2, y: y+pointSize/2))
        }
        
        // fill graph for hours after last datapoint
        x = xMultiplier * CGFloat(24)
        y = yMultiplier * CGFloat(getTemp(dataPoint: data[data.count-1])-minVal)
       
       y = rect.height - y
       x += rect.minX
       y += rect.minY
       path.addLine(to: CGPoint(x: x,y: y))
        return path
        
    }
    
    func getTemp(dataPoint: HourlyAggregation)->Double{
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
struct HourlyChartView: View{
    @Binding var showMax : Bool
    @Binding var showMin : Bool
    @Binding var showAvg : Bool
    @Binding var showCircles : Bool

    let data: [HourlyAggregation]
    var lineWidth: CGFloat = 2
    var pointSize: CGFloat = 8
    var frame: CGRect
    var avgColor: Color = .green
    
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
