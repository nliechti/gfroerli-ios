//
//  GraphView.swift
//  iOS
//
//  Created by Marc on 18.05.21.
//

import SwiftUI

struct GraphView: View {
    
    @State var nrOfLines: Int = 5
    
    @State var data = [10.0,2.5,1.0,7.5,5.0,4.0]
    
    var body: some View {
        
        VStack{
            HStack{
                Y_LabelsView(data: $data,nrOfLines: nrOfLines)
                ChartView(data: $data, nrOfLines: nrOfLines)
            }
            HStack{
                Text("00").hidden().padding(.leading)
                X_LabelsView(timeFrame: .week, day: 1, month: 12, year: 2000)
            }
        }.padding()
        .onTapGesture {
            data = data.reversed()
        }
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView()
    }
}
