//
//  ChartView.swift
//  iOS
//
//  Created by Marc on 18.05.21.
//

import SwiftUI

struct ChartView: View {
    var data: [Double]
    var nrOfLines: Int
    
    @State private var touchLocation:CGPoint = .zero
    @State private var PositionOfClosestPoint:CGPoint = .zero
    @State private var showIndicator = false
    @State private var currentValue: Double = 2 {
        didSet{
            if (oldValue != self.currentValue) {
                HapticFeedback.playSelection()
            }
            
        }
    }
    
    var body: some View {
        GeometryReader{ geo in
            ZStack{
                LineShape(data: data).stroke(Color.blue,style: StrokeStyle(lineWidth: 2,lineCap: .round, lineJoin: .round))
                VStack(alignment:.center,spacing: 0){
                    ForEach((0..<nrOfLines)){ index in
                        if index != 0 {Spacer()}
                        self.horizontalLine(width: geo.size.width)
                            .stroke((Color.secondary), style: StrokeStyle(lineWidth: 2, lineCap: .round))
                            .rotationEffect(.degrees(180), anchor: .center)
                            .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                            .clipped()
                            .frame(height:1)
                    }
                }
                
                if showIndicator{
                    VStack{
                        Text(String(currentValue))
                            .position(x:PositionOfClosestPoint.x)
                        self.verticalLine(height: geo.size.height, width: PositionOfClosestPoint.x)
                            .stroke((Color.secondary), style: StrokeStyle(lineWidth: 2, lineCap: .round))
                            .rotationEffect(.degrees(180), anchor: .center)
                            .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                            
                            
                    }
                }
                
            }.gesture(DragGesture()
                        .onChanged({ value in
                            self.touchLocation = value.location
                            self.showIndicator = true
                            self.getClosestDataPoint(toPoint: value.location, width:geo.size.width, height: geo.size.height)
                            self.PositionOfClosestPoint = self.getClosestDataPoint(toPoint: value.location, width:geo.size.width, height: geo.size.height)
                            
                        })
                        .onEnded({ value in
                            self.showIndicator = false
                        })
            )
        }
    }
    func horizontalLine(width: CGFloat) -> Path {
        var hLine = Path()
        hLine.move(to: CGPoint(x:0, y: 0.0))
        hLine.addLine(to: CGPoint(x: width, y: 0.0))
        return hLine
    }
    
    func verticalLine(height: CGFloat, width:CGFloat) -> Path {
        var hLine = Path()
        hLine.move(to: CGPoint(x:width, y: 0.0))
        hLine.addLine(to: CGPoint(x: width, y: height))
        return hLine
    }
    
    @discardableResult func getClosestDataPoint(toPoint: CGPoint, width:CGFloat, height: CGFloat) -> CGPoint {
        let points = self.data
        let stepWidth: CGFloat = width / CGFloat(points.count-1)
        let stepHeight: CGFloat = height / CGFloat(points.max()! + points.min()!)
        
        let index:Int = Int(round((toPoint.x)/stepWidth))
        if (index >= 0 && index < points.count){
            self.currentValue = points[index]
            return CGPoint(x: CGFloat(index)*stepWidth, y: CGFloat(points[index])*stepHeight)
        }
        return .zero
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(data: [0.0,1.0,2.0,3.0,4.0], nrOfLines: 5)
    }
}
