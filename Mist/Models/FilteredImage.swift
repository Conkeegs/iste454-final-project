//
//  FilteredImage.swift
//  FilteredImage
//
//  Created by Conor Keegan on 12/9/21.
//

import SwiftUI

class FilteredImage {
    /**
        This function takes in the main image and the watermark image and layers the watermark image on top, then returns the edited image
     */
    static func getImageWithWatermarkImage(_ mainImage: UIImage, _ waterMarkImage: UIImage, watermarkPosition: CGPoint, imageFilterName: String, imageFilterIntensity: CGFloat, ciContext: CIContext) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: mainImage.size)
        
        let filter = CIFilter(name: imageFilterName)
        let ciImageFromMainImage = CIImage(image: mainImage)
        var modifiedMainImage: UIImage?
        
        if filter != nil {
            filter!.setValue(ciImageFromMainImage, forKey: kCIInputImageKey)

            switch imageFilterName {
            case "CIGaussianBlur":
                filter!.setValue(imageFilterIntensity, forKey: kCIInputRadiusKey)
            default:
                print("ERROR: Could not apply filer \(imageFilterName)")
            }

            if let filteredImage = filter!.outputImage {
                if let cgImageFromOutputImage = ciContext.createCGImage(filteredImage, from: filteredImage.extent) {
                    modifiedMainImage = UIImage(cgImage: cgImageFromOutputImage)
                }
            }
        }
        
        return renderer.image { context in
            modifiedMainImage != nil ? modifiedMainImage!.draw(in: CGRect(origin: CGPoint.zero, size: mainImage.size)) : mainImage.draw(in: CGRect(origin: CGPoint.zero, size: mainImage.size))
            waterMarkImage.draw(in: CGRect(origin: watermarkPosition, size: CGSize(width: mainImage.size.width * 0.15, height: mainImage.size.width * 0.10)))
        }
    }
    
    /**
        This function takes in the main image and the watermark text and layers the watermark text on top, then returns the edited image
     */
    static func getImageWithWatermarkText(_ mainImage: UIImage, _ watermarkText: String, watermarkPosition: CGPoint, imageFilterName: String, imageFilterIntensity: CGFloat, ciContext: CIContext) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: mainImage.size)
        let watermarkTextColor = UIColor.orange
        let watermarkFont = UIFont(name: "Fjalla One", size: mainImage.size.width * 0.05)
        let watermarkTextAttributes = [NSAttributedString.Key.font: watermarkFont, NSAttributedString.Key.foregroundColor: watermarkTextColor] as [NSAttributedString.Key: Any]
        
        let filter = CIFilter(name: imageFilterName)
        let ciImageFromMainImage = CIImage(image: mainImage)
        var modifiedMainImage: UIImage?
        
        if filter != nil {
            filter!.setValue(ciImageFromMainImage, forKey: kCIInputImageKey)
            
            switch imageFilterName {
            case "CIGaussianBlur":
                filter!.setValue(imageFilterIntensity, forKey: kCIInputRadiusKey)
            default:
                print("ERROR: Could not apply filer \(imageFilterName)")
            }
        
            if let filteredImage = filter!.outputImage {
                if let cgImageFromOutputImage = ciContext.createCGImage(filteredImage, from: filteredImage.extent) {
                    modifiedMainImage = UIImage(cgImage: cgImageFromOutputImage)
                }
            }
        }
        
        return renderer.image { context in
            modifiedMainImage != nil ? modifiedMainImage!.draw(in: CGRect(origin: CGPoint.zero, size: mainImage.size)) : mainImage.draw(in: CGRect(origin: CGPoint.zero, size: mainImage.size))
            watermarkText.draw(in: CGRect(origin: watermarkPosition, size: CGSize(width: mainImage.size.width, height: mainImage.size.height)), withAttributes: watermarkTextAttributes)
        }
    }
    
    /**
        This function takes in the main image with no watermark and just returns it with possible filters applied
     */
    static func getImage(_ mainImage: UIImage, imageFilterName: String, imageFilterIntensity: CGFloat, ciContext: CIContext) -> UIImage {
        let filter = CIFilter(name: imageFilterName)
        let ciImageFromMainImage = CIImage(image: mainImage)
        var modifiedMainImage: UIImage?
        
        if filter != nil {
            filter!.setValue(ciImageFromMainImage, forKey: kCIInputImageKey)
            
            switch imageFilterName {
            case "CIGaussianBlur":
                filter!.setValue(imageFilterIntensity, forKey: kCIInputRadiusKey)
            default:
                print("ERROR: Could not apply filer \(imageFilterName)")
            }
        
            if let filteredImage = filter!.outputImage {
                if let cgImageFromOutputImage = ciContext.createCGImage(filteredImage, from: filteredImage.extent) {
                    modifiedMainImage = UIImage(cgImage: cgImageFromOutputImage)
                }
            }
        }
        
        //if the above fails, return the image with no filters
        return modifiedMainImage != nil ? modifiedMainImage! : mainImage
    }
}
