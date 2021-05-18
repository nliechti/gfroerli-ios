//
//  ChartShape.swift
//  iOS
//
//  Created by Marc on 18.05.21.
//

import Foundation
import SwiftUI

struct LineShape: Shape {
    var data: [Double]
    var minValue: Double {
        data.min()!
    }
    var maxValue: Double {
        data.max()!
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let xMultiplier = rect.width / CGFloat(data.count-1)
        let yMultiplier = rect.height / CGFloat(maxValue-minValue)
        
        //First DataPoint
        var x = xMultiplier * CGFloat(0)
        var y = yMultiplier * CGFloat(data[0]-minValue)
        
        y = rect.height - y
        x += rect.minX
        y += rect.minY
        
        path.move(to: CGPoint(x: x, y: y))
        
        path.addLine(to: CGPoint(x: x,y: y))
        
        for index in 1..<data.count {
            var x = xMultiplier * CGFloat(index)
            var y = yMultiplier * CGFloat(data[index]-minValue)
            
            y = rect.height - y
            x += rect.minX
            y += rect.minY
            
            path.addLine(to: CGPoint(x: x,y: y))
        }
        return path
    }
}
