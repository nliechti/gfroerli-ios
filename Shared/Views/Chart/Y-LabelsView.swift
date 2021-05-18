//
//  Y-LabelsView.swift
//  iOS
//
//  Created by Marc on 18.05.21.
//

import SwiftUI


struct Y_LabelsView: View {
    @Binding var data: [Double]
    
    var nrOfLines: Int
    var yLabels: [String]{
        
        var max: Double{
            data.max()!
        }
        var min: Double{
            data.min()!
        }
        
        let stepSize = (max-min)/(Double(nrOfLines-1))
        var yLabels = [String]()
        
        for i in 0..<nrOfLines{
            yLabels.append(String(min + Double(i) * stepSize))
        }
        return yLabels.reversed()
    }
    
    
    
    var body: some View {
        VStack(alignment:.trailing){
            ForEach(yLabels.indices){index in
                if index != 0{ Spacer()}
                Text(yLabels[index])
            }
        }
    }
}

struct Y_LabelsView_Previews: PreviewProvider {
    static var previews: some View {
        Y_LabelsView(data: .constant([20.0,0.0]), nrOfLines: 5)
    }
}
