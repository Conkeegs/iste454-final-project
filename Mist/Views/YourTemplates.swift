//
//  YourWatermarks.swift
//  YourWatermarks
//
//  Created by Conor Keegan and Max Gerber on 11/19/21.
//

import SwiftUI

struct YourTemplates: View {
    var body: some View {
        VStack{
            VStack{
                Text("Placeholder top")
                    .offset(x: 0, y: -20)
                    .font(.system(size: 40))
                HStack{
                    Image("p_4")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .scaledToFit()
                        .cornerRadius(70)
                    Image("p_5")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .scaledToFit()
                        .cornerRadius(70)

                    Image("p_6")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .scaledToFit()
                        .cornerRadius(70)

                }//HStack for rectangles
            }//VStack
            .padding(.bottom, 130)
            
            VStack{
                Text("Placeholder bottom")
                    .font(.system(size: 40))
                HStack{
                    Image("p_1")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .scaledToFit()
                        .cornerRadius(70)

                    Image("p_2")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .scaledToFit()
                        .cornerRadius(70)

                    Image("p_3")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .scaledToFit()
                        .cornerRadius(70)


                }//HStack for rectangles
            }//VStack
            Spacer()
        }//VStack
    }//Body
}//View
