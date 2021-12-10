//
//  Options.swift
//  Options
//
//  Created by Conor Keegan on 12/10/21.
//

import SwiftUI

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
