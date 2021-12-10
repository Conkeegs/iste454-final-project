//
//  ImageEditor.swift
//  ImageEditor
//
//  Created by Conor Keegan and Max Gerber on 11/19/21.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

/**
 This struct creates the visuals and functionality for the photo/watermark editing view
 */
struct ImageEditor: View {
    //initial values of the variables relating to the main image
    @State private var showingImageSelector = false
    @State private var imageData = Data(count: 0)
    @State private var rotatingImage = false
    @State private var imageMarchingAntsValue: CGFloat = 0
    @State private var imageSelectedAtLeastOnce = false
    @State private var imageSelected = false
    @State private var showingImageOptions = false
    @State private var showingSaveImageAlert = false
    @StateObject var imageFilterValues = ImageFilterValues()
    
    //initial values of the variables relating to the watermark image
    @State private var showingWatermarkSelector = false
    @State private var showingWatermarkImageSelector = false
    @State private var watermarkImageData = Data(count: 0)
    @State private var showingWatermarkTextInput = false
    @State private var watermarkTextInput = ""
    @State private var showingWatermarkCharacterLimitAlert = false
    @State private var showingWatermarkOptions = false
    @State private var watermarkSelected = false
    @State private var watermarkMarchingAntsValue: CGFloat = 0
    @State private var watermarkSelectedAtLeastOnce = false
    @StateObject var watermarkImageFilterValues = WatermarkImageFilterValues()
    @State private var watermarkType = ""
    @StateObject var textFilterValues = TextFilterValues()
    
    var body: some View {
        //vstack to align 'DoneButton' properly
        VStack(alignment: .center, spacing: 0, content: {
            //if clicked, gets rid of all image editing options and allows 'Save' button to be shown instead (at the bottom of the page)
            TopButtons(rotatingImage: $rotatingImage)
            
            //VStack to create all of the image editing UI
            VStack(alignment: .center, spacing: 20, content: {
                //view for the image container and its plus button
                ImageContainer(showingImageSelector: $showingImageSelector, imageData: $imageData, watermarkImageData: $watermarkImageData, watermarkSelected: $watermarkSelected, showingWatermarkOptions: $showingWatermarkOptions, showingWatermarkTextInput: $showingWatermarkTextInput, watermarkTextInput: $watermarkTextInput, imageMarchingAntsValue: $imageMarchingAntsValue, imageSelectedAtLeastOnce: $imageSelectedAtLeastOnce, imageSelected: $imageSelected, showingImageOptions: $showingImageOptions, imageFilterValues: imageFilterValues, watermarkImageFilterValues: watermarkImageFilterValues, textFilterValues: textFilterValues)
                
                //view for the watermark container and its plus button
                WatermarkContainer(showingWatermarkSelector: $showingWatermarkSelector, showingWatermarkImageSelector: $showingWatermarkImageSelector, watermarkImageData: $watermarkImageData, showingWatermarkTextInput: $showingWatermarkTextInput, watermarkTextInput: $watermarkTextInput, showingWatermarkCharacterLimitAlert: $showingWatermarkCharacterLimitAlert, watermarkSelected: $watermarkSelected, watermarkMarchingAntsValue: $watermarkMarchingAntsValue, watermarkSelectedAtLeastOnce: $watermarkSelectedAtLeastOnce, showingWatermarkOptions: $showingWatermarkOptions, watermarkType: $watermarkType, showingImageOptions: $showingImageOptions, imageSelected: $imageSelected)
                
                //options for editing image/watermark, depending on which one is selected
                Options(showingImageOptions: $showingImageOptions, showingWatermarkOptions: $showingWatermarkOptions, imageSelected: $imageSelected, watermarkSelected: $watermarkSelected, watermarkType: $watermarkType, imageFilterValues: imageFilterValues, watermarkImageFilterValues: watermarkImageFilterValues, textFilterValues: textFilterValues)
                
                //This button can either say 'Apply' (to transform the image/watermark) or 'Save' to save the edited image to the user's camera roll (when
                BottomButton(showingSaveImageAlert: $showingSaveImageAlert, imageData: $imageData, watermarkImageData: $watermarkImageData, showingWatermarkTextInput: $showingWatermarkTextInput, watermarkTextInput: $watermarkTextInput, imageFilterValues: imageFilterValues, watermarkImageFilterValues: watermarkImageFilterValues, textFilterValues: textFilterValues)
                    
            }) //VStack
        }) //VStack
    } //body
}

struct ImageContainer: View {
    //binding values for main image values
    @Binding var showingImageSelector: Bool
    @Binding var imageData: Data
    //binding to check if watermark image is selected
    @Binding var watermarkImageData: Data
    @Binding var watermarkSelected: Bool
    @Binding var showingWatermarkOptions: Bool
    //binding to check if watermark text is selected
    @Binding var showingWatermarkTextInput: Bool
    //binding for watermark text value
    @Binding var watermarkTextInput: String
    //bindings for marching ants animation when image is selected
    @Binding var imageMarchingAntsValue: CGFloat
    @Binding var imageSelectedAtLeastOnce: Bool
    @Binding var imageSelected: Bool
    @Binding var showingImageOptions: Bool
    
    //context for editing images
    let ciContext = CIContext(options: nil)
    
    @ObservedObject var imageFilterValues: ImageFilterValues
    @ObservedObject var watermarkImageFilterValues: WatermarkImageFilterValues
    @ObservedObject var textFilterValues: TextFilterValues
    
    var body: some View {
        //if the image selected is successfully created, display it. else, just display the image selector container (the bigger one with the 'plus' button)
        if let uiKitMainImage = UIImage(data: imageData) {
            ZStack(alignment: .center, content: {
                //if watermark image data is not 0 (meaning it was selected), try and display it, but if text watermark is selected, display it. if both of those are false, simply display the main image without a watermark overlayed
                if watermarkImageData.count != 0 {
                    if let uiKitWatermarkImage = UIImage(data: watermarkImageData) {
                        Image(uiImage: FilteredImage.getImageWithWatermarkImage(uiKitMainImage, uiKitWatermarkImage, watermarkPosition: CGPoint(x: uiKitMainImage.size.width * 0.10, y: uiKitMainImage.size.height * 0.75), imageFilterNames: imageFilterValues.imageFilterNames, watermarkImageFilterNames: watermarkImageFilterValues.watermarkImageFilterNames, ciContext: ciContext))
                            .resizable()
                            .frame(minWidth: 340, idealWidth: 340, maxWidth: 340, minHeight: 340, idealHeight: 340, maxHeight: 340, alignment: .center)
                            .aspectRatio(contentMode: .fill)
                            .cornerRadius(20.0)
                            .shadow(color: Color(.sRGB, red: 229 / 255, green: 229 / 255, blue: 229 / 255, opacity: 1), radius: 5, x: 0, y: 0)
                            .onAppear(perform: {
                                imageSelected = false
                                imageSelectedAtLeastOnce = false
                            })
                            .onTapGesture {
                                if !imageSelectedAtLeastOnce {
                                    withAnimation(.linear.repeatForever(autoreverses: false), {
                                        imageMarchingAntsValue -= 20
                                    })
                                    
                                    imageSelectedAtLeastOnce = true
                                }
                                    
                                if !imageSelected {
                                    imageSelected = true
                                    watermarkSelected = false
                                    
                                    withAnimation(.easeInOut, {
                                        showingImageOptions = true
                                    })
                                    
                                    withAnimation(.easeInOut, {
                                        showingWatermarkOptions = false
                                    })
                                } else {
                                    imageSelected = false
                                    
                                    withAnimation(.easeInOut, {
                                        showingImageOptions = false
                                    })
                                }
                            }
                            .overlay(
                                imageSelected ? RoundedRectangle(cornerRadius: 20)
                                    .strokeBorder(Color.white, style: StrokeStyle(lineWidth: 4, dash: [10], dashPhase: imageMarchingAntsValue)): RoundedRectangle(cornerRadius: 20).strokeBorder(Color.white, style: StrokeStyle(lineWidth: 0, dash: [10], dashPhase: imageMarchingAntsValue))
                            )
                    }
                } else if (showingWatermarkTextInput) {
                    Image(uiImage: FilteredImage.getImageWithWatermarkText(uiKitMainImage, watermarkTextInput, watermarkPosition: CGPoint(x: uiKitMainImage.size.width * 0.10, y: uiKitMainImage.size.height * 0.80), imageFilterNames: imageFilterValues.imageFilterNames, textFilterNames: textFilterValues.textFilterNames, ciContext: ciContext))
                        .resizable()
                        .frame(minWidth: 340, idealWidth: 340, maxWidth: 340, minHeight: 340, idealHeight: 340, maxHeight: 340, alignment: .center)
                        .aspectRatio(contentMode: .fill)
                        .cornerRadius(20.0)
                        .shadow(color: Color(.sRGB, red: 229 / 255, green: 229 / 255, blue: 229 / 255, opacity: 1), radius: 5, x: 0, y: 0)
                        .onAppear(perform: {
                            imageSelected = false
                            imageSelectedAtLeastOnce = false
                        })
                        .onTapGesture {
                            if !imageSelectedAtLeastOnce {
                                withAnimation(.linear.repeatForever(autoreverses: false), {
                                    imageMarchingAntsValue -= 20
                                })
                                
                                imageSelectedAtLeastOnce = true
                            }
                                
                            if !imageSelected {
                                imageSelected = true
                                watermarkSelected = false
                                
                                withAnimation(.easeInOut, {
                                    showingImageOptions = true
                                })
                                
                                withAnimation(.easeInOut, {
                                    showingWatermarkOptions = false
                                })
                            } else {
                                imageSelected = false
                                
                                withAnimation(.easeInOut, {
                                    showingImageOptions = false
                                })
                            }
                        }
                        .overlay(
                            imageSelected ? RoundedRectangle(cornerRadius: 20)
                                .strokeBorder(Color.white, style: StrokeStyle(lineWidth: 4, dash: [10], dashPhase: imageMarchingAntsValue)): RoundedRectangle(cornerRadius: 20).strokeBorder(Color.white, style: StrokeStyle(lineWidth: 0, dash: [10], dashPhase: imageMarchingAntsValue))
                        )
                } else {
                    Image(uiImage: FilteredImage.getImage(uiKitMainImage, imageFilterNames: imageFilterValues.imageFilterNames, ciContext: ciContext, imageFilterValues: imageFilterValues))
                        .resizable()
                        .frame(minWidth: 340, idealWidth: 340, maxWidth: 340, minHeight: 340, idealHeight: 340, maxHeight: 340, alignment: .center)
                        .aspectRatio(contentMode: .fill)
                        .cornerRadius(20.0)
                        .shadow(color: Color(.sRGB, red: 229 / 255, green: 229 / 255, blue: 229 / 255, opacity: 1), radius: 5, x: 0, y: 0)
                        .onAppear(perform: {
                            imageSelected = false
                            imageSelectedAtLeastOnce = false
                        })
                        .onTapGesture {
                            if !imageSelectedAtLeastOnce {
                                withAnimation(.linear.repeatForever(autoreverses: false), {
                                    imageMarchingAntsValue -= 20
                                })
                                
                                imageSelectedAtLeastOnce = true
                            }
                                
                            if !imageSelected {
                                imageSelected = true
                                watermarkSelected = false
                                
                                withAnimation(.easeInOut, {
                                    showingImageOptions = true
                                })
                                
                                withAnimation(.easeInOut, {
                                    showingWatermarkOptions = false
                                })
                            } else {
                                imageSelected = false
                                
                                withAnimation(.easeInOut, {
                                    showingImageOptions = false
                                })
                            }
                        }
                        .overlay(
                            imageSelected ? RoundedRectangle(cornerRadius: 20)
                                .strokeBorder(Color.white, style: StrokeStyle(lineWidth: 4, dash: [10], dashPhase: imageMarchingAntsValue)): RoundedRectangle(cornerRadius: 20).strokeBorder(Color.white, style: StrokeStyle(lineWidth: 0, dash: [10], dashPhase: imageMarchingAntsValue))
                        )
                }
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
    @Binding var showingImageOptions: Bool
    @Binding var showingWatermarkOptions: Bool
    @Binding var imageSelected: Bool
    @Binding var watermarkSelected: Bool
    @Binding var watermarkType: String
    
    @ObservedObject var imageFilterValues: ImageFilterValues
    @ObservedObject var watermarkImageFilterValues: WatermarkImageFilterValues
    @ObservedObject var textFilterValues: TextFilterValues
    
    var body: some View {
        VStack(alignment: .center, spacing: 20, content: {
            ZStack(alignment: .center, content: {
                Rectangle()
                    .frame(width: showingImageOptions || showingWatermarkOptions ? 340 : 0, height: showingImageOptions || showingWatermarkOptions ? 70 : 0)
                    .shadow(color: Color(.sRGB, red: 229 / 255, green: 229 / 255, blue: 229 / 255, opacity: 1), radius: 5, x: 0, y: 0)
                    .foregroundColor(.white)
                
                //this holds the actual options (filters etc) to select for the image/watermark
                if showingImageOptions {
                    ImageOptions(imageFilterValues: imageFilterValues)
                        .frame(width: showingImageOptions ? 310 : 0, height: showingImageOptions ? 70 : 0)
                } else if showingWatermarkOptions {
                    WatermarkOptions(imageSelected: $imageSelected, watermarkSelected: $watermarkSelected, watermarkType: $watermarkType, watermarkImageFilterValues: watermarkImageFilterValues, textFilterValues: textFilterValues)
                        .frame(width: showingWatermarkOptions ? 310 : 0, height: showingWatermarkOptions ? 70 : 0)
                }
            })
            
            //this holds the slider or whatever tool is used to change the intensity of an option
            if showingImageOptions {
                if (imageFilterValues.blurFilterSelected) {
                    Slider(value: $imageFilterValues.blurAmount, in: 0...10) { _ in
                        imageFilterValues.imageFilterNames["CIGaussianBlur"] = imageFilterValues.blurAmount
                    }
                        .frame(width: 340)
                } else if (imageFilterValues.vignetteFilterSelected) {
                    Slider(value: $imageFilterValues.vignetteAmount, in: 0...1) { _ in
                        imageFilterValues.imageFilterNames["CIVignette"] = imageFilterValues.vignetteAmount
                    }
                        .frame(width: 340)
                } else if (imageFilterValues.sepiaToneFilterSelected) {
                    Slider(value: $imageFilterValues.sepiaToneAmount, in: 0...1) { _ in
                        imageFilterValues.imageFilterNames["CISepiaTone"] = imageFilterValues.sepiaToneAmount
                    }
                        .frame(width: 340)
                } else if (imageFilterValues.bloomFilterSelected) {
                    Slider(value: $imageFilterValues.bloomAmount, in: 0...1) { _ in
                        imageFilterValues.imageFilterNames["CIBloom"] = imageFilterValues.bloomAmount
                    }
                        .frame(width: 340)
                } else if (imageFilterValues.hueFilterSelected) {
                    Slider(value: $imageFilterValues.hueAmount, in: 0...360) { _ in
                        imageFilterValues.imageFilterNames["CIHueAdjust"] = imageFilterValues.hueAmount
                    }
                        .frame(width: 340)
                }
            } else if showingWatermarkOptions && watermarkType == "Image" {
                if (watermarkImageFilterValues.blurFilterSelected) {
                    Slider(value: $watermarkImageFilterValues.blurAmount, in: 0...10) { _ in
                        watermarkImageFilterValues.watermarkImageFilterNames["CIGaussianBlur"] = watermarkImageFilterValues.blurAmount
                    }
                        .frame(width: 340)
                } else if (watermarkImageFilterValues.vignetteFilterSelected) {
                    Slider(value: $watermarkImageFilterValues.vignetteAmount, in: 0...1) { _ in
                        watermarkImageFilterValues.watermarkImageFilterNames["CIVignette"] = watermarkImageFilterValues.vignetteAmount
                    }
                        .frame(width: 340)
                } else if (watermarkImageFilterValues.sepiaToneFilterSelected) {
                    Slider(value: $watermarkImageFilterValues.sepiaToneAmount, in: 0...1) { _ in
                        watermarkImageFilterValues.watermarkImageFilterNames["CISepiaTone"] = watermarkImageFilterValues.sepiaToneAmount
                    }
                        .frame(width: 340)
                } else if (watermarkImageFilterValues.bloomFilterSelected) {
                    Slider(value: $watermarkImageFilterValues.bloomAmount, in: 0...1) { _ in
                        watermarkImageFilterValues.watermarkImageFilterNames["CIBloom"] = watermarkImageFilterValues.bloomAmount
                    }
                        .frame(width: 340)
                } else if (watermarkImageFilterValues.hueFilterSelected) {
                    Slider(value: $watermarkImageFilterValues.hueAmount, in: 0...360) { _ in
                        watermarkImageFilterValues.watermarkImageFilterNames["CIHueAdjust"] = watermarkImageFilterValues.hueAmount
                    }
                        .frame(width: 340)
                }
            } else if showingWatermarkOptions && watermarkType == "Text" {
                if (textFilterValues.obliquenessSelected) {
                    Slider(value: $textFilterValues.obliquenessAmount, in: 0...1) { _ in
                        textFilterValues.textFilterNames["Obliqueness"] = textFilterValues.obliquenessAmount
                    }
                        .frame(width: 340)
                } else if (textFilterValues.strokeSelected) {
                    Slider(value: $textFilterValues.strokeAmount, in: 3...5) { _ in
                        textFilterValues.textFilterNames["Stroke"] = textFilterValues.strokeAmount
                    }
                        .frame(width: 340)
                } else if (textFilterValues.kernSelected) {
                    Slider(value: $textFilterValues.kernAmount, in: 0...5) { _ in
                        textFilterValues.textFilterNames["Kern"] = textFilterValues.kernAmount
                    }
                        .frame(width: 340)
                }
            }
        }) //VStack
    } //body
}

struct BottomButton: View {
    @Binding var showingSaveImageAlert: Bool
    @Binding var imageData: Data
    @Binding var watermarkImageData: Data
    @Binding var showingWatermarkTextInput: Bool
    @Binding var watermarkTextInput: String
    
    @ObservedObject var imageFilterValues: ImageFilterValues
    @ObservedObject var watermarkImageFilterValues: WatermarkImageFilterValues
    @ObservedObject var textFilterValues: TextFilterValues
    
    let ciContext = CIContext(options: nil)
    
    var body: some View {
        Button(action: {
            if let uiKitMainImage = UIImage(data: imageData) {
                if watermarkImageData.count != 0 {
                    if let uiKitWatermarkImage = UIImage(data: watermarkImageData) {
                        ImageSaver.writeToPhotoAlbum(image: FilteredImage.getImageWithWatermarkImage(uiKitMainImage, uiKitWatermarkImage, watermarkPosition: CGPoint(x: uiKitMainImage.size.width * 0.10, y: uiKitMainImage.size.height * 0.75), imageFilterNames: imageFilterValues.imageFilterNames, watermarkImageFilterNames: watermarkImageFilterValues.watermarkImageFilterNames, ciContext: ciContext))
                    }
                } else if (showingWatermarkTextInput) {
                    ImageSaver.writeToPhotoAlbum(image: FilteredImage.getImageWithWatermarkText(uiKitMainImage, watermarkTextInput, watermarkPosition: CGPoint(x: uiKitMainImage.size.width * 0.10, y: uiKitMainImage.size.height * 0.80), imageFilterNames: imageFilterValues.imageFilterNames, textFilterNames: textFilterValues.textFilterNames, ciContext: ciContext))
                } else {
                    ImageSaver.writeToPhotoAlbum(image: FilteredImage.getImage(uiKitMainImage, imageFilterNames: imageFilterValues.imageFilterNames, ciContext: ciContext, imageFilterValues: imageFilterValues))
                } 
            }
            
            showingSaveImageAlert = true
        }, label: {
            Text("MyButton")
                .font(.custom("Fjalla One", size: 22))
                .frame(width: 120, height: 60)
        }) //Button
            .foregroundColor(Color.white)
            .background(Color(.sRGB, red: 120 / 255, green: 134 / 255, blue: 255 / 255, opacity: 1))
            .cornerRadius(/*@START_MENU_TOKEN@*/5.0/*@END_MENU_TOKEN@*/)
            .alert(isPresented: $showingSaveImageAlert) {
                if imageData.count != 0 {
                    return Alert(title: Text("Success"), message: Text("Photo saved to camera roll."), dismissButton: .default(Text("Ok")))
                } else {
                    return Alert(title: Text("Warning"), message: Text("Please select an image before saving."), dismissButton: .destructive(Text("Dismiss")))
                }
            }
    } //body
}

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

struct TopButtons: View {
    @Binding var rotatingImage: Bool

    var body: some View {
        HStack(alignment: .center, spacing: 0, content: {
            //button for rotating the main image
            Button(action: {
                print("rotate")
            }, label: {
                Image(systemName: "rotate.right")
                    .font(.system(size: 22))
                    .frame(width: 60, height: 60, alignment: .leading)
                    .padding(.leading, 30)
            }) //Button
            
            //spacer for space in between 'Apply' and 'Rotate' buttons
            Spacer()
            
            //button for signaling the user is done editing the image
            Button(action: {
                print("apply")
            }, label: {
                Text("Apply")
                    .font(.custom("Fjalla One", size: 22))
                    .frame(width: 60, height: 60, alignment: .trailing)
                    .padding(.trailing, 30)
            }) //Button
        }) //HStack
            .frame(width: 340, height: 60)
    } //body
}

struct ImageOptions: View {
    @ObservedObject var imageFilterValues: ImageFilterValues
    
    var body: some View {
        //filter options for the main image
        ScrollView(.horizontal, showsIndicators: false, content: {
            HStack(alignment: .center, spacing: 10, content: {
                //blur button
                Button(action: {
                    imageFilterValues.vignetteFilterSelected = false
                    imageFilterValues.sepiaToneFilterSelected = false
                    imageFilterValues.bloomFilterSelected = false
                    imageFilterValues.hueFilterSelected = false
                    
                    if imageFilterValues.imageFilterNames["CIGaussianBlur"] != nil {
                        imageFilterValues.blurFilterSelected = false
                        imageFilterValues.imageFilterNames.removeValue(forKey: "CIGaussianBlur")
                    } else {
                        imageFilterValues.blurFilterSelected = true
                        imageFilterValues.imageFilterNames["CIGaussianBlur"] = imageFilterValues.blurAmount
                    }
                }, label: {
                    Text("Blur")
                        .font(.custom("Fjalla One", size: 22))
                        .frame(width: 120, height: 50)
                        .foregroundColor(imageFilterValues.blurFilterSelected ? Color.yellow : imageFilterValues.imageFilterNames["CIGaussianBlur"] != nil ? Color.white : Color.black)
                }) //Button
                    .foregroundColor(imageFilterValues.imageFilterNames["CIGaussianBlur"] != nil ? Color.white : Color.black)
                    .background(imageFilterValues.imageFilterNames["CIGaussianBlur"] != nil ? Color(.sRGB, red: 120 / 255, green: 134 / 255, blue: 255 / 255, opacity: 1) : nil)
                    .cornerRadius(/*@START_MENU_TOKEN@*/5.0/*@END_MENU_TOKEN@*/)
                
                //vignette button
                Button(action: {
                    imageFilterValues.blurFilterSelected = false
                    imageFilterValues.sepiaToneFilterSelected = false
                    imageFilterValues.bloomFilterSelected = false
                    imageFilterValues.hueFilterSelected = false
                    
                    if imageFilterValues.imageFilterNames["CIVignette"] != nil {
                        imageFilterValues.vignetteFilterSelected = false
                        imageFilterValues.imageFilterNames.removeValue(forKey: "CIVignette")
                    } else {
                        imageFilterValues.vignetteFilterSelected = true
                        imageFilterValues.imageFilterNames["CIVignette"] = imageFilterValues.vignetteAmount
                    }
                }, label: {
                    Text("Vignette")
                        .font(.custom("Fjalla One", size: 22))
                        .frame(width: 120, height: 50)
                        .foregroundColor(imageFilterValues.vignetteFilterSelected ? Color.yellow : imageFilterValues.imageFilterNames["CIVignette"] != nil ? Color.white : Color.black)
                }) //Button
                    .foregroundColor(imageFilterValues.imageFilterNames["CIVignette"] != nil ? Color.white : Color.black)
                    .background(imageFilterValues.imageFilterNames["CIVignette"] != nil ? Color(.sRGB, red: 120 / 255, green: 134 / 255, blue: 255 / 255, opacity: 1) : nil)
                    .cornerRadius(/*@START_MENU_TOKEN@*/5.0/*@END_MENU_TOKEN@*/)
                
                //sepiatone button
                Button(action: {
                    imageFilterValues.blurFilterSelected = false
                    imageFilterValues.vignetteFilterSelected = false
                    imageFilterValues.bloomFilterSelected = false
                    imageFilterValues.hueFilterSelected = false
                    
                    if imageFilterValues.imageFilterNames["CISepiaTone"] != nil {
                        imageFilterValues.sepiaToneFilterSelected = false
                        imageFilterValues.imageFilterNames.removeValue(forKey: "CISepiaTone")
                    } else {
                        imageFilterValues.sepiaToneFilterSelected = true
                        imageFilterValues.imageFilterNames["CISepiaTone"] = imageFilterValues.sepiaToneAmount
                    }
                }, label: {
                    Text("Sepia")
                        .font(.custom("Fjalla One", size: 22))
                        .frame(width: 120, height: 50)
                        .foregroundColor(imageFilterValues.sepiaToneFilterSelected ? Color.yellow : imageFilterValues.imageFilterNames["CISepiaTone"] != nil ? Color.white : Color.black)
                }) //Button
                    .foregroundColor(imageFilterValues.imageFilterNames["CISepiaTone"] != nil ? Color.white : Color.black)
                    .background(imageFilterValues.imageFilterNames["CISepiaTone"] != nil ? Color(.sRGB, red: 120 / 255, green: 134 / 255, blue: 255 / 255, opacity: 1) : nil)
                    .cornerRadius(/*@START_MENU_TOKEN@*/5.0/*@END_MENU_TOKEN@*/)
                
                //bloom button
                Button(action: {
                    imageFilterValues.blurFilterSelected = false
                    imageFilterValues.vignetteFilterSelected = false
                    imageFilterValues.sepiaToneFilterSelected = false
                    imageFilterValues.hueFilterSelected = false
                    
                    if imageFilterValues.imageFilterNames["CIBloom"] != nil {
                        imageFilterValues.bloomFilterSelected = false
                        imageFilterValues.imageFilterNames.removeValue(forKey: "CIBloom")
                    } else {
                        imageFilterValues.bloomFilterSelected = true
                        imageFilterValues.imageFilterNames["CIBloom"] = imageFilterValues.bloomAmount
                    }
                }, label: {
                    Text("Bloom")
                        .font(.custom("Fjalla One", size: 22))
                        .frame(width: 120, height: 50)
                        .foregroundColor(imageFilterValues.bloomFilterSelected ? Color.yellow : imageFilterValues.imageFilterNames["CIBloom"] != nil ? Color.white : Color.black)
                }) //Button
                    .foregroundColor(imageFilterValues.imageFilterNames["CIBloom"] != nil ? Color.white : Color.black)
                    .background(imageFilterValues.imageFilterNames["CIBloom"] != nil ? Color(.sRGB, red: 120 / 255, green: 134 / 255, blue: 255 / 255, opacity: 1) : nil)
                    .cornerRadius(/*@START_MENU_TOKEN@*/5.0/*@END_MENU_TOKEN@*/)
                
                //hue button
                Button(action: {
                    imageFilterValues.blurFilterSelected = false
                    imageFilterValues.vignetteFilterSelected = false
                    imageFilterValues.sepiaToneFilterSelected = false
                    imageFilterValues.bloomFilterSelected = false
                    
                    if imageFilterValues.imageFilterNames["CIHueAdjust"] != nil {
                        imageFilterValues.hueFilterSelected = false
                        imageFilterValues.imageFilterNames.removeValue(forKey: "CIHueAdjust")
                    } else {
                        imageFilterValues.hueFilterSelected = true
                        imageFilterValues.imageFilterNames["CIHueAdjust"] = imageFilterValues.hueAmount
                    }
                }, label: {
                    Text("Hue")
                        .font(.custom("Fjalla One", size: 22))
                        .frame(width: 120, height: 50)
                        .foregroundColor(imageFilterValues.hueFilterSelected ? Color.yellow : imageFilterValues.imageFilterNames["CIHueAdjust"] != nil ? Color.white : Color.black)
                }) //Button
                    .foregroundColor(imageFilterValues.imageFilterNames["CIHueAdjust"] != nil ? Color.white : Color.black)
                    .background(imageFilterValues.imageFilterNames["CIHueAdjust"] != nil ? Color(.sRGB, red: 120 / 255, green: 134 / 255, blue: 255 / 255, opacity: 1) : nil)
                    .cornerRadius(/*@START_MENU_TOKEN@*/5.0/*@END_MENU_TOKEN@*/)
            })
        })
    }
}

struct WatermarkOptions: View {
    @Binding var imageSelected: Bool
    @Binding var watermarkSelected: Bool
    @Binding var watermarkType: String
    
    @ObservedObject var watermarkImageFilterValues: WatermarkImageFilterValues
    @ObservedObject var textFilterValues: TextFilterValues
    
    var body: some View {
        //filter/text options for the watermark that is chosen
        ScrollView(.horizontal, showsIndicators: false, content: {
            HStack(alignment: .center, spacing: 10, content: {
                if watermarkType == "Image" {
                    //blur button
                    Button(action: {
                        watermarkImageFilterValues.vignetteFilterSelected = false
                        watermarkImageFilterValues.sepiaToneFilterSelected = false
                        watermarkImageFilterValues.bloomFilterSelected = false
                        watermarkImageFilterValues.hueFilterSelected = false
                        
                        if watermarkImageFilterValues.watermarkImageFilterNames["CIGaussianBlur"] != nil {
                            watermarkImageFilterValues.blurFilterSelected = false
                            watermarkImageFilterValues.watermarkImageFilterNames.removeValue(forKey: "CIGaussianBlur")
                        } else {
                            watermarkImageFilterValues.blurFilterSelected = true
                            watermarkImageFilterValues.watermarkImageFilterNames["CIGaussianBlur"] = watermarkImageFilterValues.blurAmount
                        }
                    }, label: {
                        Text("Blur")
                            .font(.custom("Fjalla One", size: 22))
                            .frame(width: 120, height: 50)
                            .foregroundColor(watermarkImageFilterValues.blurFilterSelected ? Color.yellow : watermarkImageFilterValues.watermarkImageFilterNames["CIGaussianBlur"] != nil ? Color.white : Color.black)
                    }) //Button
                        .foregroundColor(watermarkImageFilterValues.watermarkImageFilterNames["CIGaussianBlur"] != nil ? Color.white : Color.black)
                        .background(watermarkImageFilterValues.watermarkImageFilterNames["CIGaussianBlur"] != nil ? Color(.sRGB, red: 120 / 255, green: 134 / 255, blue: 255 / 255, opacity: 1) : nil)
                        .cornerRadius(/*@START_MENU_TOKEN@*/5.0/*@END_MENU_TOKEN@*/)
                    
                    //vignette button
                    Button(action: {
                        watermarkImageFilterValues.blurFilterSelected = false
                        watermarkImageFilterValues.sepiaToneFilterSelected = false
                        watermarkImageFilterValues.bloomFilterSelected = false
                        watermarkImageFilterValues.hueFilterSelected = false
                        
                        if watermarkImageFilterValues.watermarkImageFilterNames["CIVignette"] != nil {
                            watermarkImageFilterValues.vignetteFilterSelected = false
                            watermarkImageFilterValues.watermarkImageFilterNames.removeValue(forKey: "CIVignette")
                        } else {
                            watermarkImageFilterValues.vignetteFilterSelected = true
                            watermarkImageFilterValues.watermarkImageFilterNames["CIVignette"] = watermarkImageFilterValues.vignetteAmount
                        }
                    }, label: {
                        Text("Vignette")
                            .font(.custom("Fjalla One", size: 22))
                            .frame(width: 120, height: 50)
                            .foregroundColor(watermarkImageFilterValues.vignetteFilterSelected ? Color.yellow : watermarkImageFilterValues.watermarkImageFilterNames["CIVignette"] != nil ? Color.white : Color.black)
                    }) //Button
                        .foregroundColor(watermarkImageFilterValues.watermarkImageFilterNames["CIVignette"] != nil ? Color.white : Color.black)
                        .background(watermarkImageFilterValues.watermarkImageFilterNames["CIVignette"] != nil ? Color(.sRGB, red: 120 / 255, green: 134 / 255, blue: 255 / 255, opacity: 1) : nil)
                        .cornerRadius(/*@START_MENU_TOKEN@*/5.0/*@END_MENU_TOKEN@*/)
                    
                    //sepiatone button
                    Button(action: {
                        watermarkImageFilterValues.blurFilterSelected = false
                        watermarkImageFilterValues.vignetteFilterSelected = false
                        watermarkImageFilterValues.bloomFilterSelected = false
                        watermarkImageFilterValues.hueFilterSelected = false
                        
                        if watermarkImageFilterValues.watermarkImageFilterNames["CISepiaTone"] != nil {
                            watermarkImageFilterValues.sepiaToneFilterSelected = false
                            watermarkImageFilterValues.watermarkImageFilterNames.removeValue(forKey: "CISepiaTone")
                        } else {
                            watermarkImageFilterValues.sepiaToneFilterSelected = true
                            watermarkImageFilterValues.watermarkImageFilterNames["CISepiaTone"] = watermarkImageFilterValues.sepiaToneAmount
                        }
                    }, label: {
                        Text("Sepia")
                            .font(.custom("Fjalla One", size: 22))
                            .frame(width: 120, height: 50)
                            .foregroundColor(watermarkImageFilterValues.sepiaToneFilterSelected ? Color.yellow : watermarkImageFilterValues.watermarkImageFilterNames["CISepiaTone"] != nil ? Color.white : Color.black)
                    }) //Button
                        .foregroundColor(watermarkImageFilterValues.watermarkImageFilterNames["CISepiaTone"] != nil ? Color.white : Color.black)
                        .background(watermarkImageFilterValues.watermarkImageFilterNames["CISepiaTone"] != nil ? Color(.sRGB, red: 120 / 255, green: 134 / 255, blue: 255 / 255, opacity: 1) : nil)
                        .cornerRadius(/*@START_MENU_TOKEN@*/5.0/*@END_MENU_TOKEN@*/)
                    
                    //bloom button
                    Button(action: {
                        watermarkImageFilterValues.blurFilterSelected = false
                        watermarkImageFilterValues.vignetteFilterSelected = false
                        watermarkImageFilterValues.sepiaToneFilterSelected = false
                        watermarkImageFilterValues.hueFilterSelected = false
                        
                        if watermarkImageFilterValues.watermarkImageFilterNames["CIBloom"] != nil {
                            watermarkImageFilterValues.bloomFilterSelected = false
                            watermarkImageFilterValues.watermarkImageFilterNames.removeValue(forKey: "CIBloom")
                        } else {
                            watermarkImageFilterValues.bloomFilterSelected = true
                            watermarkImageFilterValues.watermarkImageFilterNames["CIBloom"] = watermarkImageFilterValues.bloomAmount
                        }
                    }, label: {
                        Text("Bloom")
                            .font(.custom("Fjalla One", size: 22))
                            .frame(width: 120, height: 50)
                            .foregroundColor(watermarkImageFilterValues.bloomFilterSelected ? Color.yellow : watermarkImageFilterValues.watermarkImageFilterNames["CIBloom"] != nil ? Color.white : Color.black)
                    }) //Button
                        .foregroundColor(watermarkImageFilterValues.watermarkImageFilterNames["CIBloom"] != nil ? Color.white : Color.black)
                        .background(watermarkImageFilterValues.watermarkImageFilterNames["CIBloom"] != nil ? Color(.sRGB, red: 120 / 255, green: 134 / 255, blue: 255 / 255, opacity: 1) : nil)
                        .cornerRadius(/*@START_MENU_TOKEN@*/5.0/*@END_MENU_TOKEN@*/)
                    
                    //hue button
                    Button(action: {
                        watermarkImageFilterValues.blurFilterSelected = false
                        watermarkImageFilterValues.vignetteFilterSelected = false
                        watermarkImageFilterValues.sepiaToneFilterSelected = false
                        watermarkImageFilterValues.bloomFilterSelected = false
                        
                        if watermarkImageFilterValues.watermarkImageFilterNames["CIHueAdjust"] != nil {
                            watermarkImageFilterValues.hueFilterSelected = false
                            watermarkImageFilterValues.watermarkImageFilterNames.removeValue(forKey: "CIHueAdjust")
                        } else {
                            watermarkImageFilterValues.hueFilterSelected = true
                            watermarkImageFilterValues.watermarkImageFilterNames["CIHueAdjust"] = watermarkImageFilterValues.hueAmount
                        }
                    }, label: {
                        Text("Hue")
                            .font(.custom("Fjalla One", size: 22))
                            .frame(width: 120, height: 50)
                            .foregroundColor(watermarkImageFilterValues.hueFilterSelected ? Color.yellow : watermarkImageFilterValues.watermarkImageFilterNames["CIHueAdjust"] != nil ? Color.white : Color.black)
                    }) //Button
                        .foregroundColor(watermarkImageFilterValues.watermarkImageFilterNames["CIHueAdjust"] != nil ? Color.white : Color.black)
                        .background(watermarkImageFilterValues.watermarkImageFilterNames["CIHueAdjust"] != nil ? Color(.sRGB, red: 120 / 255, green: 134 / 255, blue: 255 / 255, opacity: 1) : nil)
                        .cornerRadius(/*@START_MENU_TOKEN@*/5.0/*@END_MENU_TOKEN@*/)
                } else if watermarkType == "Text" {
                    //obliqueness button
                    Button(action: {
                        textFilterValues.strokeSelected = false
                        textFilterValues.kernSelected = false
                        
                        if textFilterValues.textFilterNames["Obliqueness"] != nil {
                            textFilterValues.obliquenessSelected = false
                            textFilterValues.textFilterNames.removeValue(forKey: "Obliqueness")
                        } else {
                            textFilterValues.obliquenessSelected = true
                            textFilterValues.textFilterNames["Obliqueness"] = textFilterValues.obliquenessAmount
                        }
                    }, label: {
                        Text("Obliqueness")
                            .font(.custom("Fjalla One", size: 22))
                            .frame(width: 120, height: 50)
                            .foregroundColor(textFilterValues.obliquenessSelected ? Color.yellow : textFilterValues.textFilterNames["Obliqueness"] != nil ? Color.white : Color.black)
                    }) //Button
                        .foregroundColor(textFilterValues.textFilterNames["Obliqueness"] != nil ? Color.white : Color.black)
                        .background(textFilterValues.textFilterNames["Obliqueness"] != nil ? Color(.sRGB, red: 120 / 255, green: 134 / 255, blue: 255 / 255, opacity: 1) : nil)
                        .cornerRadius(/*@START_MENU_TOKEN@*/5.0/*@END_MENU_TOKEN@*/)
                    
                    //stroke button
                    Button(action: {
                        textFilterValues.obliquenessSelected = false
                        textFilterValues.kernSelected = false
                        
                        if textFilterValues.textFilterNames["Stroke"] != nil {
                            textFilterValues.strokeSelected = false
                            textFilterValues.textFilterNames.removeValue(forKey: "Stroke")
                        } else {
                            textFilterValues.strokeSelected = true
                            textFilterValues.textFilterNames["Stroke"] = textFilterValues.strokeAmount
                        }
                    }, label: {
                        Text("Stroke")
                            .font(.custom("Fjalla One", size: 22))
                            .frame(width: 120, height: 50)
                            .foregroundColor(textFilterValues.strokeSelected ? Color.yellow : textFilterValues.textFilterNames["Stroke"] != nil ? Color.white : Color.black)
                    }) //Button
                        .foregroundColor(textFilterValues.textFilterNames["Stroke"] != nil ? Color.white : Color.black)
                        .background(textFilterValues.textFilterNames["Stroke"] != nil ? Color(.sRGB, red: 120 / 255, green: 134 / 255, blue: 255 / 255, opacity: 1) : nil)
                        .cornerRadius(/*@START_MENU_TOKEN@*/5.0/*@END_MENU_TOKEN@*/)
                    
                    //kern button
                    Button(action: {
                        textFilterValues.obliquenessSelected = false
                        textFilterValues.obliquenessSelected = false
                        
                        if textFilterValues.textFilterNames["Kern"] != nil {
                            textFilterValues.kernSelected = false
                            textFilterValues.textFilterNames.removeValue(forKey: "Kern")
                        } else {
                            textFilterValues.kernSelected = true
                            textFilterValues.textFilterNames["Kern"] = textFilterValues.kernAmount
                        }
                    }, label: {
                        Text("Kern")
                            .font(.custom("Fjalla One", size: 22))
                            .frame(width: 120, height: 50)
                            .foregroundColor(textFilterValues.kernSelected ? Color.yellow : textFilterValues.textFilterNames["Kern"] != nil ? Color.white : Color.black)
                    }) //Button
                        .foregroundColor(textFilterValues.textFilterNames["Kern"] != nil ? Color.white : Color.black)
                        .background(textFilterValues.textFilterNames["Kern"] != nil ? Color(.sRGB, red: 120 / 255, green: 134 / 255, blue: 255 / 255, opacity: 1) : nil)
                        .cornerRadius(/*@START_MENU_TOKEN@*/5.0/*@END_MENU_TOKEN@*/)
                }
            })
        })
    }
}
