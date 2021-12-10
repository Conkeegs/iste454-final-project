//
//  ImageContainer.swift
//  ImageContainer
//
//  Created by Conor Keegan on 12/10/21.
//

import SwiftUI

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
    @Binding var rotatingImage: Bool
    @Binding var showingSaveButton: Bool
    
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
                                    
                                    withAnimation(.easeInOut) {
                                        showingSaveButton = false
                                    }
                                    
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
                                
                                withAnimation(.easeInOut) {
                                    showingSaveButton = false
                                }
                                
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
                                
                                withAnimation(.easeInOut) {
                                    showingSaveButton = false
                                }
                                
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
