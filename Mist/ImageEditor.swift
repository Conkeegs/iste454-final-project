//
//  ImageEditor.swift
//  ImageEditor
//
//  Created by Conor Keegan and Max Gerber on 11/19/21.
//

import SwiftUI

/**
 This struct creates the visuals and functionality for the photo/watermark editing view
 */
struct ImageEditor: View {
    //initial values of the variables relating to the main image selection
    @State private var showingImageSelector = false
    @State private var imageData = Data(count: 0)
    
    //initial values of the variables relating to the watermark selection
    @State private var showingWatermarkSelector = false
    @State private var showingWatermarkImageSelector = false
    @State private var watermarkImageData = Data(count: 0)
    
    var body: some View {
        //vstack to align 'DoneButton' properly
        VStack(alignment: .center, spacing: 0, content: {
            //if clicked, gets rid of all image editing options and allows 'Save' button to be shown instead (at the bottom of the page)
            DoneButton()
            
            //VStack to create all of the image editing UI
            VStack(alignment: .center, spacing: 20, content: {
                //view for the image container and its plus button
                ImageContainer(showingImageSelector: $showingImageSelector, imageData: $imageData)
                
                //view for the watermark container and its plus button
                WatermarkContainer(showingWatermarkSelector: $showingWatermarkSelector, showingWatermarkImageSelector: $showingWatermarkImageSelector, watermarkImageData: $watermarkImageData)
                
                //options for editing image/watermark, depending on which one is selected
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
    //binding value to the 'showingImageSelector' and 'imageData' variables defined in the 'ImageEditor' struct so that they may update accordingly for the 'ImageContainer'
    @Binding var showingImageSelector: Bool
    @Binding var imageData: Data
    
    var body: some View {
        //if the image selected is successfully created, display it. else, just display the image selector container (the bigger one with the 'plus' button)
        if let uiKitImage = UIImage(data: imageData) {
            ZStack(alignment: .center, content: {
                Image(uiImage: uiKitImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 340, height: 370)
                    .cornerRadius(20.0)
                    .shadow(color: Color(.sRGB, red: 229 / 255, green: 229 / 255, blue: 229 / 255, opacity: 1), radius: 5, x: 0, y: 0)
            }) //ZStack
        } else {
            //the whole image container is a button so that the user does not have to precisely touch the 'plus' button when selecting a new image
            Button(action: {
                showingImageSelector.toggle()
            }, label: {
                ZStack(alignment: .center, content: {
                    //rectangle for color and shaping/style of container
                    Rectangle()
                        .frame(width: 340, height: 370)
                        .cornerRadius(20.0)
                        .shadow(color: Color(.sRGB, red: 229 / 255, green: 229 / 255, blue: 229 / 255, opacity: 1), radius: 5, x: 0, y: 0)
                        .foregroundColor(.white)
                    
                    //plus button to signify image can be added
                    Image(systemName: "plus")
                        .font(.system(size: 60))
                        .opacity(0.5)
                }) //ZStack
            }) //Button
                .sheet(isPresented: _showingImageSelector, content: {
                    ImageSelector(showingImageSelector: _showingImageSelector, imageData: _imageData)
                }) //sheet
        }
    } //body
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
//            Rectangle()
//                .frame(width: 340, height: 50)
//                .shadow(color: Color(.sRGB, red: 229 / 255, green: 229 / 255, blue: 229 / 255, opacity: 1), radius: 5, x: 0, y: 0)
//                .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
        }) //VStack
    } //body
}

struct BottomButton: View {
    var body: some View {
        Button(action: {
            print("Hello world")
        }, label: {
            Text("MyButton")
                .font(.custom("Fjalla One", size: 22))
                .frame(width: 120, height: 60)
        }) //Button
            .foregroundColor(Color.white)
            .background(Color(.sRGB, red: 120 / 255, green: 134 / 255, blue: 255 / 255, opacity: 1))
            .cornerRadius(/*@START_MENU_TOKEN@*/5.0/*@END_MENU_TOKEN@*/)
    } //body
}

struct WatermarkContainer: View {
    //binding value to the 'showingWatermarkSelector' and 'showingWatermarkImageSelector' and 'watermarkImageData' variables defined in the 'ImageEditor' struct so that they may update accordingly for the 'WatermarkContainer'
    @Binding var showingWatermarkSelector: Bool
    @Binding var showingWatermarkImageSelector: Bool
    @Binding var watermarkImageData: Data
    
    var body: some View {
        //if the waternark image selected is successfully created, display it. else, just display the watermark selector container (the smaller one with the 'plus' button)
        if let uiKitImage = UIImage(data: watermarkImageData) {
            ZStack(alignment: .center, content: {
                Image(uiImage: uiKitImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 50)
            }) //ZStack
                .frame(width: 340, height: 70)
                .background(Color.white)
                .cornerRadius(/*@START_MENU_TOKEN@*/20.0/*@END_MENU_TOKEN@*/)
                .shadow(color: Color(.sRGB, red: 229 / 255, green: 229 / 255, blue: 229 / 255, opacity: 1), radius: 5, x: 0, y: 0)
        }
        else if true {
            ZStack(alignment: .center, content: {
//                TextField(
            }) //ZStack
                .frame(width: 340, height: 70)
                .background(Color.white)
                .cornerRadius(/*@START_MENU_TOKEN@*/20.0/*@END_MENU_TOKEN@*/)
                .shadow(color: Color(.sRGB, red: 229 / 255, green: 229 / 255, blue: 229 / 255, opacity: 1), radius: 5, x: 0, y: 0)
        }
        else {
            Button(action: {
                showingWatermarkSelector.toggle()
            }, label: {
                ZStack(alignment: .center, content: {
                    //the 'plus' system image for when the user had not selected a watermark yet
                    Image(systemName: "plus")
                        .font(.system(size: 40))
                        .opacity(0.5)
                }) //ZStack
                    .frame(width: 340, height: 70)
                    .background(Color.white)
                    .cornerRadius(/*@START_MENU_TOKEN@*/20.0/*@END_MENU_TOKEN@*/)
                    .shadow(color: Color(.sRGB, red: 229 / 255, green: 229 / 255, blue: 229 / 255, opacity: 1), radius: 5, x: 0, y: 0)
            }) //Button
                .sheet(isPresented: _showingWatermarkSelector, content: {
                    VStack(alignment: .center, spacing: 10, content: {
                        Text("Choose a watermark type")
                            .font(.custom("Fjalla One", size: 30))
                        
                        //button for going with an image watermark
                        Button(action: {
                            showingWatermarkImageSelector.toggle()
                        }, label: {
                            Text("Image")
                                .font(.custom("Fjalla One", size: 22))
                                .frame(width: 300, height: 60)
                        }) //Button
                            .foregroundColor(Color.white)
                            .background(Color(.sRGB, red: 120 / 255, green: 134 / 255, blue: 255 / 255, opacity: 1))
                            .cornerRadius(/*@START_MENU_TOKEN@*/5.0/*@END_MENU_TOKEN@*/)
                            .sheet(isPresented: _showingWatermarkImageSelector, content: {
                                WatermarkImageSelector(showingWatermarkImageSelector: _showingWatermarkImageSelector, watermarkImageData: _watermarkImageData, showingWatermarkSelector: _showingWatermarkSelector)
                            }) //sheet
                        
                        //button for going with a text watermark
                        Button(action: {
                            //showingWatermarkTextInput.toggle()
                        }, label: {
                            Text("Text")
                                .font(.custom("Fjalla One", size: 22))
                                .frame(width: 300, height: 60)
                        }) //Button
                            .foregroundColor(Color.white)
                            .background(Color(.sRGB, red: 120 / 255, green: 134 / 255, blue: 255 / 255, opacity: 1))
                            .cornerRadius(/*@START_MENU_TOKEN@*/5.0/*@END_MENU_TOKEN@*/)
                    }) //VStack
                        .offset(y: -220)
                }) //sheet
        }
    } //body
}

struct DoneButton: View {
    var body: some View {
        HStack(alignment: .center, spacing: 0, content: {
            Button(action: {
                print("yo")
            }, label: {
                Text("Done")
                    .font(.custom("Fjalla One", size: 22))
                    .frame(width: 120, height: 60)
            }) //Button
        }) //HStack
            .frame(width: 340, height: 60, alignment: .trailing)
    } //body
}
