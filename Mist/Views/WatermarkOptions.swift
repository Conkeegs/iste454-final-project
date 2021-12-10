//
//  WatermarkOptions.swift
//  WatermarkOptions
//
//  Created by Conor Keegan on 12/10/21.
//

import SwiftUI

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
