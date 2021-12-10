//
//  WatermarkContainer.swift
//  WatermarkContainer
//
//  Created by Conor Keegan on 12/10/21.
//

import SwiftUI

struct WatermarkContainer: View {
    //binding value to the 'ImageEditor' @State variables so they can be changed here
    @Binding var showingWatermarkSelector: Bool
    @Binding var showingWatermarkImageSelector: Bool
    @Binding var watermarkImageData: Data
    @Binding var showingWatermarkTextInput: Bool
    @Binding var watermarkTextInput: String
    @Binding var showingWatermarkCharacterLimitAlert: Bool
    @Binding var watermarkSelected: Bool
    @Binding var watermarkMarchingAntsValue: CGFloat
    @Binding var watermarkSelectedAtLeastOnce: Bool
    @Binding var showingWatermarkOptions: Bool
    @Binding var watermarkType: String
    @Binding var showingSaveButton: Bool
    
    @Binding var showingImageOptions: Bool
    @Binding var imageSelected: Bool
    
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
                .onAppear(perform: {
                    watermarkSelected = false
                    watermarkSelectedAtLeastOnce = false
                })
                .onTapGesture {
                    if !watermarkSelectedAtLeastOnce {
                        withAnimation(.linear.repeatForever(autoreverses: false), {
                            watermarkMarchingAntsValue -= 20
                        })
                        
                        watermarkSelectedAtLeastOnce = true
                    }
                        
                    if !watermarkSelected {
                        watermarkSelected = true
                        imageSelected = false
                        
                        withAnimation(.easeInOut) {
                            showingSaveButton = false
                        }
                        
                        withAnimation(.easeInOut, {
                            showingWatermarkOptions = true
                        })
                        
                        withAnimation(.easeInOut, {
                            showingImageOptions = false
                        })
                    } else {
                        watermarkSelected = false
                        
                        withAnimation(.easeInOut, {
                            showingWatermarkOptions = false
                        })
                    }
                }
                .overlay(
                    watermarkSelected ? RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(Color.gray, style: StrokeStyle(lineWidth: 4, dash: [10], dashPhase: watermarkMarchingAntsValue)): RoundedRectangle(cornerRadius: 20).strokeBorder(Color.white, style: StrokeStyle(lineWidth: 0, dash: [10], dashPhase: watermarkMarchingAntsValue))
                )
        }
        else if showingWatermarkTextInput {
            ZStack(alignment: .center, content: {
                //the TextField for the user to input a text watermark
                TextField("Enter Text...", text: $watermarkTextInput)
                    .frame(width: 200, height: 50)
                    .font(.custom("Fjalla One", size: 22))
                    .multilineTextAlignment(.center)
                    .onChange(of: watermarkTextInput, perform: { _ in
                        if watermarkTextInput.count == 15 {
                            showingWatermarkCharacterLimitAlert = true
                            watermarkTextInput.removeLast()
                        }
                    })
                    .alert(isPresented: $showingWatermarkCharacterLimitAlert) {
                        Alert(title: Text("Warning"), message: Text("Watermark cannot be more than 15 characters long."), dismissButton: .destructive(Text("Dismiss")))
                    }
            }) //ZStack
                .frame(width: 340, height: 70)
                .background(Color.white)
                .cornerRadius(/*@START_MENU_TOKEN@*/20.0/*@END_MENU_TOKEN@*/)
                .shadow(color: Color(.sRGB, red: 229 / 255, green: 229 / 255, blue: 229 / 255, opacity: 1), radius: 5, x: 0, y: 0)
                .onAppear(perform: {
                    watermarkSelected = false
                    watermarkSelectedAtLeastOnce = false
                })
                .onTapGesture {
                    if !watermarkSelectedAtLeastOnce {
                        withAnimation(.linear.repeatForever(autoreverses: false), {
                            watermarkMarchingAntsValue -= 20
                        })
                        
                        watermarkSelectedAtLeastOnce = true
                    }
                        
                    if !watermarkSelected {
                        watermarkSelected = true
                        imageSelected = false
                        
                        withAnimation(.easeInOut) {
                            showingSaveButton = false
                        }
                        
                        withAnimation(.easeInOut, {
                            showingWatermarkOptions = true
                        })
                        
                        withAnimation(.easeInOut, {
                            showingImageOptions = false
                        })
                    } else {
                        watermarkSelected = false
                        
                        withAnimation(.easeInOut, {
                            showingWatermarkOptions = false
                        })
                    }
                }
                .overlay(
                    watermarkSelected ? RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(Color.gray, style: StrokeStyle(lineWidth: 4, dash: [10], dashPhase: watermarkMarchingAntsValue)): RoundedRectangle(cornerRadius: 20).strokeBorder(Color.white, style: StrokeStyle(lineWidth: 0, dash: [10], dashPhase: watermarkMarchingAntsValue))
                )
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
                .sheet(isPresented: $showingWatermarkSelector, content: {
                    VStack(alignment: .center, spacing: 10, content: {
                        Text("Choose a watermark type")
                            .font(.custom("Fjalla One", size: 30))
                        
                        //button for going with an image watermark
                        Button(action: {
                            showingWatermarkImageSelector.toggle()
                            watermarkType = "Image"
                        }, label: {
                            Text("Image")
                                .font(.custom("Fjalla One", size: 22))
                                .frame(width: 300, height: 60)
                        }) //Button
                            .foregroundColor(Color.white)
                            .background(Color(.sRGB, red: 120 / 255, green: 134 / 255, blue: 255 / 255, opacity: 1))
                            .cornerRadius(/*@START_MENU_TOKEN@*/5.0/*@END_MENU_TOKEN@*/)
                            .sheet(isPresented: $showingWatermarkImageSelector, content: {
                                WatermarkImageSelector(showingWatermarkImageSelector: _showingWatermarkImageSelector, watermarkImageData: _watermarkImageData, showingWatermarkSelector: _showingWatermarkSelector)
                            }) //sheet
                        
                        //button for going with a text watermark
                        Button(action: {
                            showingWatermarkTextInput.toggle()
                            watermarkType = "Text"
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
