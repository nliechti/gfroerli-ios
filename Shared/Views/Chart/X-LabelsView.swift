//
//  X-LabelsView.swift
//  iOS
//
//  Created by Marc on 18.05.21.
//

import SwiftUI


struct X_LabelsView: View {
    var timeFrame: TimeFrame
    @State var day: Int
    var month: Int
    var year: Int
    
    var nrOfDaysInFrame: Int {
        if timeFrame == .week {return 6}
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!

        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        return numDays-1
    }
    
    var startDate:Date{
        if timeFrame == .month {day = 1}
        let dateComponents = DateComponents(year: year, month: month,day:day)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        return date
    }
    
    var midDate:Date{
        let dateComponents = DateComponents(year: year, month: month, day: day+nrOfDaysInFrame/2)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        return date
    }
    
    var endDate:Date{
        let dateComponents = DateComponents(year: year, month: month, day: day+nrOfDaysInFrame)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        return date
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
        dateFormatter.dateFormat = "dd. MMM."
        let st = dateFormatter.string(from: date)
        
        return st
    }
}

struct X_LabelsView_Previews: PreviewProvider {
    static var previews: some View {
        X_LabelsView(timeFrame: .month, day: 1, month: 2, year: 2020)
    }
}
