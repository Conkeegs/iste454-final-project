//
//  ImageOptions.swift
//  ImageOptions
//
//  Created by Conor Keegan on 12/10/21.
//

import SwiftUI

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
