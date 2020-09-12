//
//  CostumTabBar.swift
//  iOS
//
//  Created by Marc Kramer on 22.08.20.
//

import SwiftUI


struct CostumTabBarButton: View {
    @Binding var tab: String
    var title: String
    var imageName: String
    var body: some View{
        
        Button(action: {tab=title}, label: {
            VStack{
                
                if tab==title{
                    Image(systemName: imageName+".fill")
                        .resizable()
                        .frame(width:20,height:20)
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    Text(title)
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                        .font(.system(size: 15))
                    
                }else{
                    Image(systemName: imageName)
                        .resizable()
                        .frame(width:20,height:20)
                        .foregroundColor(.gray)
                    Text(title)
                        .foregroundColor(.gray)
                        .font(.system(size: 15))
                }
            }
        })
    }
}


struct CostumTabBarButton_Previews: PreviewProvider {
    
    static var previews: some View {
        HStack{
        CostumTabBarButton(tab: .constant("testtab"), title: "testtab", imageName: "circle")
        CostumTabBarButton(tab: .constant("othre"), title: "testtab", imageName: "circle")
        }
    }
}
