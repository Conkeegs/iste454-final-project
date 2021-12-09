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
    
    var body: some View {
        //vstack to align 'DoneButton' properly
        VStack(alignment: .center, spacing: 0, content: {
            //if clicked, gets rid of all image editing options and allows 'Save' button to be shown instead (at the bottom of the page)
            TopButtons(rotatingImage: $rotatingImage)
            
            //VStack to create all of the image editing UI
            VStack(alignment: .center, spacing: 20, content: {
                //view for the image container and its plus button
                ImageContainer(showingImageSelector: $showingImageSelector, imageData: $imageData, watermarkImageData: $watermarkImageData, watermarkSelected: $watermarkSelected, showingWatermarkOptions: $showingWatermarkOptions, showingWatermarkTextInput: $showingWatermarkTextInput, watermarkTextInput: $watermarkTextInput, imageMarchingAntsValue: $imageMarchingAntsValue, imageSelectedAtLeastOnce: $imageSelectedAtLeastOnce, imageSelected: $imageSelected, showingImageOptions: $showingImageOptions)
                
                //view for the watermark container and its plus button
                WatermarkContainer(showingWatermarkSelector: $showingWatermarkSelector, showingWatermarkImageSelector: $showingWatermarkImageSelector, watermarkImageData: $watermarkImageData, showingWatermarkTextInput: $showingWatermarkTextInput, watermarkTextInput: $watermarkTextInput, showingWatermarkCharacterLimitAlert: $showingWatermarkCharacterLimitAlert, watermarkSelected: $watermarkSelected, watermarkMarchingAntsValue: $watermarkMarchingAntsValue, watermarkSelectedAtLeastOnce: $watermarkSelectedAtLeastOnce, showingWatermarkOptions: $showingWatermarkOptions, showingImageOptions: $showingImageOptions, imageSelected: $imageSelected)
                
                //options for editing image/watermark, depending on which one is selected
                Options(showingImageOptions: $showingImageOptions, showingWatermarkOptions: $showingWatermarkOptions)
                
                //This button can either say 'Apply' (to transform the image/watermark) or 'Save' to save the edited image to the user's camera roll (when
                BottomButton()
                    
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
    
    /**
        This function takes in the main image and the watermark image and layers the watermark image on top, then returns the edited image
     */
    func getImageWithWatermarkImage(_ mainImage: UIImage, _ waterMarkImage: UIImage, watermarkPosition: CGPoint) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: mainImage.size)
        
        return renderer.image { context in
            mainImage.draw(in: CGRect(origin: CGPoint.zero, size: mainImage.size))
            waterMarkImage.draw(in: CGRect(origin: watermarkPosition, size: CGSize(width: mainImage.size.width * 0.15, height: mainImage.size.width * 0.10)))
        }
    }
    
    /**
        This function takes in the main image and the watermark text and layers the watermark text on top, then returns the edited image
     */
    func getImageWithWatermarkText(_ mainImage: UIImage, _ watermarkText: String, watermarkPosition: CGPoint) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: mainImage.size)
        let watermarkTextColor = UIColor.orange
        let watermarkFont = UIFont(name: "Fjalla One", size: mainImage.size.width * 0.05)
        let watermarkTextAttributes = [NSAttributedString.Key.font: watermarkFont, NSAttributedString.Key.foregroundColor: watermarkTextColor] as [NSAttributedString.Key: Any]
        
        return renderer.image { context in
            mainImage.draw(in: CGRect(origin: CGPoint.zero, size: mainImage.size))
            watermarkText.draw(in: CGRect(origin: watermarkPosition, size: CGSize(width: mainImage.size.width, height: mainImage.size.height)), withAttributes: watermarkTextAttributes)
        }
    }
    
    var body: some View {
        //if the image selected is successfully created, display it. else, just display the image selector container (the bigger one with the 'plus' button)
        if let uiKitMainImage = UIImage(data: imageData) {
            ZStack(alignment: .center, content: {
                //if watermark image data is not 0 (meaning it was selected), try and display it, but if text watermark is selected, display it. if both of those are false, simply display the main image without a watermark overlayed
                if watermarkImageData.count != 0 {
                    if let uiKitWatermarkImage = UIImage(data: watermarkImageData) {
                        Image(uiImage: getImageWithWatermarkImage(uiKitMainImage, uiKitWatermarkImage, watermarkPosition: CGPoint(x: uiKitMainImage.size.width * 0.10, y: uiKitMainImage.size.height * 0.75)))
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
                    Image(uiImage: getImageWithWatermarkText(uiKitMainImage, watermarkTextInput, watermarkPosition: CGPoint(x: uiKitMainImage.size.width * 0.10, y: uiKitMainImage.size.height * 0.80)))
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
                    Image(uiImage: uiKitMainImage)
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
    
    var body: some View {
        VStack(alignment: .center, spacing: 20, content: {
            ZStack(alignment: .center, content: {
                Rectangle()
                    .frame(width: showingImageOptions || showingWatermarkOptions ? 340 : 0, height: showingImageOptions || showingWatermarkOptions ? 70 : 0)
                    .shadow(color: Color(.sRGB, red: 229 / 255, green: 229 / 255, blue: 229 / 255, opacity: 1), radius: 5, x: 0, y: 0)
                    .foregroundColor(.white)
                
                //this holds the actual options (filters etc) to select for the image/watermark
                if showingImageOptions {
                    ImageOptions()
                        .frame(width: showingImageOptions ? 310 : 0, height: showingImageOptions ? 70 : 0)
                } else if showingWatermarkOptions {
                    WatermarkOptions()
                        .frame(width: showingWatermarkOptions ? 310 : 0, height: showingWatermarkOptions ? 70 : 0)
                }
            })
            
            //this holds the slider or whatever tool is used to change the intensity of an option
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
    var body: some View {
        //filter options for the main image
        ScrollView(.horizontal, showsIndicators: false, content: {
            HStack(alignment: .center, spacing: 10, content: {
                Button(action: {
                    //apply filter with intensity
                    //toggle filter selected and edit background color
                }, label: {
                    Text("Filter1")
                        .font(.custom("Fjalla One", size: 22))
                        .frame(width: 120, height: 50)
                }) //Button
                    .foregroundColor(Color.white)
                    .background(Color(.sRGB, red: 120 / 255, green: 134 / 255, blue: 255 / 255, opacity: 1))
                    .cornerRadius(/*@START_MENU_TOKEN@*/5.0/*@END_MENU_TOKEN@*/)
                
                Button(action: {
                    print("Filter 2")
                }, label: {
                    Text("Filter2")
                        .font(.custom("Fjalla One", size: 22))
                        .frame(width: 120, height: 50)
                }) //Button
                    .foregroundColor(Color.black)
                
                Button(action: {
                    print("Filter 3")
                }, label: {
                    Text("Filter3")
                        .font(.custom("Fjalla One", size: 22))
                        .frame(width: 120, height: 50)
                }) //Button
                    .foregroundColor(Color.white)
                    .background(Color(.sRGB, red: 120 / 255, green: 134 / 255, blue: 255 / 255, opacity: 1))
                    .cornerRadius(/*@START_MENU_TOKEN@*/5.0/*@END_MENU_TOKEN@*/)
                
                Button(action: {
                    print("Filter 4")
                }, label: {
                    Text("Filter4")
                        .font(.custom("Fjalla One", size: 22))
                        .frame(width: 120, height: 50)
                }) //Button
                    .foregroundColor(Color.black)
            })
        })
    }
}

struct WatermarkOptions: View {
    var body: some View {
        //filter/text options for the watermark that is chosen
        ScrollView(.horizontal, showsIndicators: false, content: {
            HStack(alignment: .center, spacing: 10, content: {
                Button(action: {
                    print("Color 1")
                }, label: {
                    Text("Color1")
                        .font(.custom("Fjalla One", size: 22))
                        .frame(width: 120, height: 50)
                }) //Button
                    .foregroundColor(Color.white)
                    .background(Color(.sRGB, red: 120 / 255, green: 134 / 255, blue: 255 / 255, opacity: 1))
                    .cornerRadius(/*@START_MENU_TOKEN@*/5.0/*@END_MENU_TOKEN@*/)
                
                Button(action: {
                    print("Color 2")
                }, label: {
                    Text("Color2")
                        .font(.custom("Fjalla One", size: 22))
                        .frame(width: 120, height: 50)
                }) //Button
                    .foregroundColor(Color.black)
                
                Button(action: {
                    print("Color 3")
                }, label: {
                    Text("Color3")
                        .font(.custom("Fjalla One", size: 22))
                        .frame(width: 120, height: 50)
                }) //Button
                    .foregroundColor(Color.white)
                    .background(Color(.sRGB, red: 120 / 255, green: 134 / 255, blue: 255 / 255, opacity: 1))
                    .cornerRadius(/*@START_MENU_TOKEN@*/5.0/*@END_MENU_TOKEN@*/)
                
                Button(action: {
                    print("Color 4")
                }, label: {
                    Text("Color4")
                        .font(.custom("Fjalla One", size: 22))
                        .frame(width: 120, height: 50)
                }) //Button
                    .foregroundColor(Color.black)
            })
        })
    }
}
