//
//  ImageSaver.swift
//  ImageSaver
//
//  Created by Conor Keegan on 12/9/21.
//

import UIKit

class ImageSaver: NSObject {
    static func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc static func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("Error saving image")
            print(error)
        } else {
            print("Saved image")
        }
    }
}
