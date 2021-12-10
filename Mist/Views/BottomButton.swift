//
//  BottomButton.swift
//  BottomButton
//
//  Created by Conor Keegan on 12/10/21.
//

import SwiftUI

struct BottomButton: View {
    @Binding var showingSaveImageAlert: Bool
    @Binding var imageData: Data
    @Binding var watermarkImageData: Data
    @Binding var showingWatermarkTextInput: Bool
    @Binding var watermarkTextInput: String
    @Binding var showingSaveButton: Bool
    
    @ObservedObject var imageFilterValues: ImageFilterValues
    @ObservedObject var watermarkImageFilterValues: WatermarkImageFilterValues
    @ObservedObject var textFilterValues: TextFilterValues
    
    let ciContext = CIContext(options: nil)
    
    var body: some View {
        if showingSaveButton {
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
                Text("Save")
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
        } else {
            Spacer()
        }
    } //body
}
