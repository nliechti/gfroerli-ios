//
//  X-LabelsView.swift
//  iOS
//
//  Created by Marc on 18.05.21.
//

import SwiftUI


struct X_LabelsView: View {
    @ObservedObject var temperatureAggregationsVM: TemperatureAggregationsViewModel
    @Binding var timeFrame: TimeFrame
    @Binding var totalSteps: Int
    
    
    
    var startDate:Date{
        if timeFrame == .day {
            return Date()
        } else if timeFrame == .week{
            return temperatureAggregationsVM.startDateWeek
        } else {
            return temperatureAggregationsVM.startDateMonth

        }
        
    }
    
    var midDate:Date{
        return Calendar.current.date(byAdding: .day,value: totalSteps/2, to: startDate)!
    }
    
    var endDate:Date{
        return Calendar.current.date(byAdding: .day,value: totalSteps, to: startDate)!
        
    }
    

    var body: some View {
        HStack{
            if timeFrame == .day{
                Text("00:00")
                Spacer()
                Text("12:00")
                Spacer()
                Text("24:00")
            }else{
                Text(formatDateText(date: startDate))
                Spacer()
                Text(formatDateText(date: midDate))
                Spacer()
                Text(formatDateText(date: endDate))
            }
        }
    }
    func formatDateText(date:Date)-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("dd MMM")
        let st = dateFormatter.string(from: date)
        
        return st
    }
}

struct X_LabelsView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
