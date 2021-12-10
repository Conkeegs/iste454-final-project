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
    
    @State private var showingSaveButton = false
    
    var body: some View {
        //vstack to align 'DoneButton' properly
        VStack(alignment: .center, spacing: 0, content: {
            //if clicked, gets rid of all image editing options and allows 'Save' button to be shown instead (at the bottom of the page)
            TopButtons(rotatingImage: $rotatingImage, imageSelected: $imageSelected, watermarkSelected: $watermarkSelected, showingImageOptions: $showingImageOptions, showingWatermarkOptions: $showingWatermarkOptions, showingSaveButton: $showingSaveButton)
            
            //VStack to create all of the image editing UI
            VStack(alignment: .center, spacing: 20, content: {
                //view for the image container and its plus button
                ImageContainer(showingImageSelector: $showingImageSelector, imageData: $imageData, watermarkImageData: $watermarkImageData, watermarkSelected: $watermarkSelected, showingWatermarkOptions: $showingWatermarkOptions, showingWatermarkTextInput: $showingWatermarkTextInput, watermarkTextInput: $watermarkTextInput, imageMarchingAntsValue: $imageMarchingAntsValue, imageSelectedAtLeastOnce: $imageSelectedAtLeastOnce, imageSelected: $imageSelected, showingImageOptions: $showingImageOptions, rotatingImage: $rotatingImage, showingSaveButton: $showingSaveButton, imageFilterValues: imageFilterValues, watermarkImageFilterValues: watermarkImageFilterValues, textFilterValues: textFilterValues)
                
                //view for the watermark container and its plus button
                WatermarkContainer(showingWatermarkSelector: $showingWatermarkSelector, showingWatermarkImageSelector: $showingWatermarkImageSelector, watermarkImageData: $watermarkImageData, showingWatermarkTextInput: $showingWatermarkTextInput, watermarkTextInput: $watermarkTextInput, showingWatermarkCharacterLimitAlert: $showingWatermarkCharacterLimitAlert, watermarkSelected: $watermarkSelected, watermarkMarchingAntsValue: $watermarkMarchingAntsValue, watermarkSelectedAtLeastOnce: $watermarkSelectedAtLeastOnce, showingWatermarkOptions: $showingWatermarkOptions, watermarkType: $watermarkType, showingSaveButton: $showingSaveButton, showingImageOptions: $showingImageOptions, imageSelected: $imageSelected)
                
                //options for editing image/watermark, depending on which one is selected
                Options(showingImageOptions: $showingImageOptions, showingWatermarkOptions: $showingWatermarkOptions, imageSelected: $imageSelected, watermarkSelected: $watermarkSelected, watermarkType: $watermarkType, imageFilterValues: imageFilterValues, watermarkImageFilterValues: watermarkImageFilterValues, textFilterValues: textFilterValues)
                
                //This button saves to camera roll
                BottomButton(showingSaveImageAlert: $showingSaveImageAlert, imageData: $imageData, watermarkImageData: $watermarkImageData, showingWatermarkTextInput: $showingWatermarkTextInput, watermarkTextInput: $watermarkTextInput, showingSaveButton: $showingSaveButton, imageFilterValues: imageFilterValues, watermarkImageFilterValues: watermarkImageFilterValues, textFilterValues: textFilterValues)
                    
            }) //VStack
        }) //VStack
    } //body
}
