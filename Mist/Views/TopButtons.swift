//
//  TopButtons.swift
//  TopButtons
//
//  Created by Conor Keegan on 12/10/21.
//

import SwiftUI

struct TopButtons: View {
    @Binding var rotatingImage: Bool
    @Binding var imageSelected: Bool
    @Binding var watermarkSelected: Bool
    @Binding var showingImageOptions: Bool
    @Binding var showingWatermarkOptions: Bool
    @Binding var showingSaveButton: Bool

    var body: some View {
        HStack(alignment: .center, spacing: 0, content: {
            //button for rotating the main image
            Button(action: {
                rotatingImage = true
            }, label: {
                Image(systemName: "rotate.right")
                    .font(.system(size: 22))
                    .frame(width: 60, height: 60, alignment: .leading)
                    .padding(.leading, 30)
            }) //Button
            
            //spacer for space in between 'Done' and 'Rotate' buttons
            Spacer()
            
            //button for signaling the user is done editing the image
            if imageSelected || watermarkSelected {
                Button(action: {
                    withAnimation(.easeInOut) {
                        showingSaveButton = true
                    }
                    
                    imageSelected = false
                    watermarkSelected = false
                    withAnimation(.easeInOut) {
                        showingImageOptions = false
                        showingWatermarkOptions = false
                    }
                }, label: {
                    Text("Done")
                        .font(.custom("Fjalla One", size: 22))
                        .frame(width: 60, height: 60, alignment: .trailing)
                        .padding(.trailing, 30)
                }) //Button
            } else {
                Spacer()
            }
        }) //HStack
            .frame(width: 340, height: 60)
    } //body
}
