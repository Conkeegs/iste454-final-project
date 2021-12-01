//
//  WatermarkImageSelector.swift
//  WatermarkImageSelector
//
//  Created by Conor Keegan and Max Gerber on 11/21/21.
//

import SwiftUI

/**
 This struct transforms the UIView 'UIImagePickerController' into a SwiftUI view for use in the ContentView
 */
struct WatermarkImageSelector: UIViewControllerRepresentable {
    //two variables: one to tell the user's camera roll to show/not show, and one to represent the image's data that the user selected
    @Binding var showingWatermarkImageSelector: Bool
    @Binding var watermarkImageData: Data
    @Binding var showingWatermarkSelector: Bool
    
    //makes the view's controller
    func makeUIViewController(context: Context) -> some UIImagePickerController {
        let controller = UIImagePickerController()
        controller.sourceType = .photoLibrary
        controller.delegate = context.coordinator
        
        return controller
    }
    
    //handles updates on controller
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    //makes the view's coordinator
    func makeCoordinator() -> Coordinator {
        return WatermarkImageSelector.Coordinator(parent: self)
    }
    
    //the view's coordinator class
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: WatermarkImageSelector
        
        init(parent: WatermarkImageSelector) {
            self.parent = parent
        }
        
        //deals with the user closing their camera roll
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.showingWatermarkImageSelector.toggle()
        }
        
        //deals with when the user finished picking an image from their camera roll
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            //return the image in PNG format. if that fails, try to return it in JPG format. if that fails, print an error
            if let imageData = (info[.originalImage] as? UIImage)?.pngData() {
                parent.watermarkImageData = imageData
                parent.showingWatermarkImageSelector.toggle()
                parent.showingWatermarkSelector.toggle()
            } else {
                if let imageData = (info[.originalImage] as? UIImage)?.jpegData(compressionQuality: 0.8) {
                    parent.watermarkImageData = imageData
                    parent.showingWatermarkImageSelector.toggle()
                    parent.showingWatermarkSelector.toggle()
                } else {
                    print("ERROR: Could not select watermark image")
                }
            }
        }
    }
}
