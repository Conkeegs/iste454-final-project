//
//  ImageEditor.swift
//  ImageEditor
//
//  Created by Conor Keegan on 11/25/21.
//

import SwiftUI

struct ImageEditor: View {
    var body: some View {
        //this outer VStack allows the 'Done' button to be properly aligned
        VStack(alignment: .center, spacing: 0, content: {
            //if clicked, gets rid of all image editing options and allows 'Save' button to be shown instead (at the bottom of the page)
            DoneButton()
            //s
            
            //VStack to create all of the image editing UI
            VStack(alignment: .center, spacing: 20, content: {
                //view for the image container and its plus button
                ImageContainer()
                
                //view for the watermark container and its plus button
                WatermarkContainer()
                
                //options for editing image/watermark, depening on which one is selected
                Options()
                
                //This button can either say 'Apply' (to transform the image/watermark) or 'Save' to save the edited image to the user's camera roll (when
                BottomButton()
                    
            }) //VStack
        }) //VStack
    } //body
}

struct ImageEditor_Previews: PreviewProvider {
    static var previews: some View {
        ImageEditor()
    }
}

struct ImageContainer: View {
    var body: some View {
        ZStack(alignment: .center, content: {
            Rectangle()
                .frame(width: 340, height: 390)
                .cornerRadius(20.0)
                .shadow(color: Color(.sRGB, red: 229 / 255, green: 229 / 255, blue: 229 / 255, opacity: 1), radius: 5, x: 0, y: 0)
                .foregroundColor(.white)
            
            //plus button to signift image can be added
            Image(systemName: "plus")
                .font(.system(size: 60))
                .opacity(0.5)
        }) //ZStack
    }
}

struct Options: View {
    var body: some View {
        VStack(alignment: .center, spacing: 20, content: {
            //this holds the actual options (filters etc) to select for the image/watermark
            Rectangle()
                .frame(width: 340, height: 70)
                .shadow(color: Color(.sRGB, red: 229 / 255, green: 229 / 255, blue: 229 / 255, opacity: 1), radius: 5, x: 0, y: 0)
                .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
            
            //this hold the slider or whatever tool is used to change the intensity of an option
            Rectangle()
                .frame(width: 340, height: 50)
                .shadow(color: Color(.sRGB, red: 229 / 255, green: 229 / 255, blue: 229 / 255, opacity: 1), radius: 5, x: 0, y: 0)
                .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
        })
    }
}

struct BottomButton: View {
    var body: some View {
        Button(action: {
            print("Hello world")
        }, label: {
            Text("MyButton")
                .font(.custom("Fjalla One", size: 22))
        })
            .frame(width: 120, height: 60)
            .foregroundColor(Color.white)
            .background(Color(.sRGB, red: 120 / 255, green: 134 / 255, blue: 255 / 255, opacity: 1))
            .cornerRadius(/*@START_MENU_TOKEN@*/5.0/*@END_MENU_TOKEN@*/)
    }
}

struct WatermarkContainer: View {
    var body: some View {
        ZStack(alignment: .center, content: {
            Rectangle()
                .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
            
            Image(systemName: "plus")
                .font(.system(size: 40))
                .opacity(0.5)
        })
            .frame(width: 340, height: 70)
            .cornerRadius(/*@START_MENU_TOKEN@*/20.0/*@END_MENU_TOKEN@*/)
            .shadow(color: Color(.sRGB, red: 229 / 255, green: 229 / 255, blue: 229 / 255, opacity: 1), radius: 5, x: 0, y: 0)
    }
}

struct DoneButton: View {
    var body: some View {
        HStack(alignment: .center, spacing: 0, content: {
            Button(action: {
                print("yo")
            }, label: {
                Text("Done")
                    .font(.custom("Fjalla One", size: 22))
            })
                .frame(width: 120, height: 60)
        })
            .frame(width: 340, height: 60, alignment: .trailing)
    }
}
