//
//  Legend.swift
//  LineChart
//
//  Created by András Samu on 2019. 09. 02..
//  Copyright © 2019. András Samu. All rights reserved.
//

import SwiftUI

struct Legend: View {
  
    @Binding var frame: CGRect
    @Binding var hideHorizontalLines: Bool
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    let padding:CGFloat = 3

    
    var stepHeight: CGFloat {
        let min = 0.0
        let max = 30.0
        if  min != max {
            if (min < 0){
                return (frame.size.height-padding) / CGFloat(max - min)
            }else{
                return (frame.size.height-padding) / CGFloat(max - min)
            }
        }
        return 0
    }
    
    var min: CGFloat {
        return CGFloat(0.0)
    }
    
    var body: some View {
        ZStack(alignment: .center){
            ForEach((0...6), id: \.self) { height in
                HStack(alignment: .center){
                    Spacer(minLength: 0)
                    if height<2 {
                        Text("  \(self.getYLegendSafe(height: height), specifier: "%0.0f")").offset(x: 0, y: self.getYposition(height: height) )
                            .foregroundColor(Color(.systemGray))
                            .font(.caption)
                    } else {
                        Text("\(self.getYLegendSafe(height: height), specifier: "%0.0f")").offset(x: 0, y: self.getYposition(height: height) )
                            .foregroundColor(Color(.systemGray))
                            .font(.caption)
                    }
                    self.line(atHeight: self.getYLegendSafe(height: height), width: self.frame.width)
                        .stroke(Color(.systemGray4), style: StrokeStyle(lineWidth: 1, lineCap: .round))
                        .opacity((self.hideHorizontalLines && height != 0) ? 0 : 1)
                        .rotationEffect(.degrees(180), anchor: .center)
                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                        .animation(.easeOut(duration: 0.2))
                        .clipped()
                }
               
            }
            
        }
    }
    
    func getYLegendSafe(height:Int)->CGFloat{
        if let legend = getYLegend() {
            return CGFloat(legend[height])
        }
        return 0
    }
    
    func getYposition(height: Int)-> CGFloat {
        if let legend = getYLegend() {
            return (self.frame.height-((CGFloat(legend[height]) - min)*self.stepHeight))-(self.frame.height/2)
        }
        return 0
       
    }
    
    func line(atHeight: CGFloat, width: CGFloat) -> Path {
        var hLine = Path()
        hLine.move(to: CGPoint(x:5, y: (atHeight-min)*stepHeight))
        hLine.addLine(to: CGPoint(x: width, y: (atHeight-min)*stepHeight))
        return hLine
    }
    
    func getYLegend() -> [Double]? {
        let max = 30.0
        let min = 0.0
        let step = Double(max - min)/6
        return [0.1, min+step * 1, min+step * 2, min+step * 3, min+step * 4, min+step * 5, min+step * 6]
    }
}

struct Legend_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader{ geometry in
            Legend( frame: .constant(geometry.frame(in: .local)), hideHorizontalLines: .constant(false))
        }.frame(width: 320, height: 200)
    }
}
