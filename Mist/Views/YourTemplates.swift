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
                Text("The top bar")
                    .offset(x: 0, y: -20)
                    .font(.system(size: 40))
                HStack{
                    Rectangle()
                        .fill(Color.gray)
                        .frame(width: 50, height: 50)
                        .padding(.bottom)
                    Rectangle()
                        .fill(Color.gray)
                        .frame(width: 50, height: 50)
                        .padding(.bottom)
                    Rectangle()
                        .fill(Color.gray)
                        .frame(width: 50, height: 50)
                        .padding(.bottom)
                    Rectangle()
                        .fill(Color.gray)
                        .frame(width: 50, height: 50)
                        .padding(.bottom)
                }//HStack for rectangles
            }//VStack
            .padding(.bottom, 130)
            
            VStack{
                Text("The bottom bar for Your favorites")
                    .font(.system(size: 40))
                HStack{
                    Rectangle()
                        .fill(Color.gray)
                        .frame(width: 50, height: 50)
                    Rectangle()
                        .fill(Color.gray)
                        .frame(width: 50, height: 50)
                    Rectangle()
                        .fill(Color.gray)
                        .frame(width: 50, height: 50)
                    Rectangle()
                        .fill(Color.gray)
                        .frame(width: 50, height: 50)
                }//HStack for rectangles
            }//VStack
            Spacer()
        }//VStack
    }//Body
}//View
