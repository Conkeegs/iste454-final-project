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
    static func getImageWithWatermarkImage(_ mainImage: UIImage, _ waterMarkImage: UIImage, watermarkPosition: CGPoint, imageFilterNames: Dictionary<String, CGFloat>, watermarkImageFilterNames: Dictionary<String, CGFloat>, ciContext: CIContext) -> UIImage {
        var modifiedMainImage: UIImage?
        var modifiedWatermarkImage: UIImage?
        let renderer = UIGraphicsImageRenderer(size: mainImage.size)
        
        for (filterName, filterIntensity) in imageFilterNames {
            let filter = CIFilter(name: filterName)
            let ciImageFromMainImage = CIImage(image: modifiedMainImage != nil ? modifiedMainImage! : mainImage)
            
            if filter != nil {
                filter!.setValue(ciImageFromMainImage, forKey: kCIInputImageKey)
                
                switch filterName {
                case "CIGaussianBlur":
                    filter!.setValue(filterIntensity, forKey: kCIInputRadiusKey)
                case "CIVignette", "CISepiaTone", "CIBloom":
                    filter!.setValue(filterIntensity, forKey: kCIInputIntensityKey)
                case "CIHueAdjust":
                    filter!.setValue(filterIntensity, forKey: kCIInputAngleKey)
                default:
                    print("ERROR: Could not apply filter \(filterName)")
                }
            
                if let filteredImage = filter!.outputImage {
                    if let cgImageFromOutputImage = ciContext.createCGImage(filteredImage, from: filteredImage.extent) {
                        modifiedMainImage = UIImage(cgImage: cgImageFromOutputImage)
                    }
                }
            }
        }
        
        for (filterName, filterIntensity) in watermarkImageFilterNames {
            let filter = CIFilter(name: filterName)
            let ciImageFromWatermarkImage = CIImage(image: modifiedWatermarkImage != nil ? modifiedWatermarkImage! : waterMarkImage)
            
            if filter != nil {
                filter!.setValue(ciImageFromWatermarkImage, forKey: kCIInputImageKey)
                
                switch filterName {
                case "CIGaussianBlur":
                    filter!.setValue(filterIntensity, forKey: kCIInputRadiusKey)
                case "CIVignette", "CISepiaTone", "CIBloom":
                    filter!.setValue(filterIntensity, forKey: kCIInputIntensityKey)
                case "CIHueAdjust":
                    filter!.setValue(filterIntensity, forKey: kCIInputAngleKey)
                default:
                    print("ERROR: Could not apply filter \(filterName)")
                }
            
                if let filteredImage = filter!.outputImage {
                    if let cgImageFromOutputImage = ciContext.createCGImage(filteredImage, from: filteredImage.extent) {
                        modifiedWatermarkImage = UIImage(cgImage: cgImageFromOutputImage)
                    }
                }
            }
        }
        
        return renderer.image { context in
            modifiedMainImage != nil ? modifiedMainImage!.draw(in: CGRect(origin: CGPoint.zero, size: mainImage.size)) : mainImage.draw(in: CGRect(origin: CGPoint.zero, size: mainImage.size))
            modifiedWatermarkImage != nil ? modifiedWatermarkImage!.draw(in: CGRect(origin: watermarkPosition, size: CGSize(width: mainImage.size.width * 0.15, height: mainImage.size.width * 0.10))) : waterMarkImage.draw(in: CGRect(origin: watermarkPosition, size: CGSize(width: mainImage.size.width * 0.15, height: mainImage.size.width * 0.10)))
        }
    }
    
    /**
        This function takes in the main image and the watermark text and layers the watermark text on top, then returns the edited image
     */
    static func getImageWithWatermarkText(_ mainImage: UIImage, _ watermarkText: String, watermarkPosition: CGPoint, imageFilterNames: Dictionary<String, CGFloat>, textFilterNames: Dictionary<String, Any>, ciContext: CIContext) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: mainImage.size)
        let watermarkTextColor = UIColor.orange
        let watermarkFont = UIFont(name: "Fjalla One", size: mainImage.size.width * 0.08)
        var watermarkTextAttributes = [NSAttributedString.Key.font: watermarkFont, NSAttributedString.Key.foregroundColor: watermarkTextColor] as [NSAttributedString.Key: Any]
        
        for (filterName, filterIntensity) in textFilterNames {
            switch filterName {
            case "Obliqueness":
                watermarkTextAttributes[NSAttributedString.Key.obliqueness] = NSNumber(value: filterIntensity as! Float)
            case "Stroke":
                watermarkTextAttributes[NSAttributedString.Key.strokeWidth] = NSNumber(value: filterIntensity as! Float)
            case "Kern":
                watermarkTextAttributes[NSAttributedString.Key.kern] = NSNumber(value: filterIntensity as! Float)
            default:
                print("ERROR: Could not apply filter \(filterName)")
            }
        }
        
        var modifiedMainImage: UIImage?
        
        for (filterName, filterIntensity) in imageFilterNames {
            let filter = CIFilter(name: filterName)
            let ciImageFromMainImage = CIImage(image: modifiedMainImage != nil ? modifiedMainImage! : mainImage)
            
            if filter != nil {
                filter!.setValue(ciImageFromMainImage, forKey: kCIInputImageKey)
                
                switch filterName {
                case "CIGaussianBlur":
                    filter!.setValue(filterIntensity, forKey: kCIInputRadiusKey)
                case "CIVignette", "CISepiaTone", "CIBloom":
                    filter!.setValue(filterIntensity, forKey: kCIInputIntensityKey)
                case "CIHueAdjust":
                    filter!.setValue(filterIntensity, forKey: kCIInputAngleKey)
                default:
                    print("ERROR: Could not apply filter \(filterName)")
                }
            
                if let filteredImage = filter!.outputImage {
                    if let cgImageFromOutputImage = ciContext.createCGImage(filteredImage, from: filteredImage.extent) {
                        modifiedMainImage = UIImage(cgImage: cgImageFromOutputImage)
                    }
                }
            }
        }
//
        return renderer.image { context in
            modifiedMainImage != nil ? modifiedMainImage!.draw(in: CGRect(origin: CGPoint.zero, size: mainImage.size)) : mainImage.draw(in: CGRect(origin: CGPoint.zero, size: mainImage.size))
            watermarkText.draw(in: CGRect(origin: watermarkPosition, size: CGSize(width: mainImage.size.width, height: mainImage.size.height)), withAttributes: watermarkTextAttributes)
        }
    }
    
    /**
        This function takes in the main image with no watermark and just returns it with possible filters applied
     */
//    static func getImage(_ mainImage: UIImage, imageFilterName: String, imageFilterIntensity: CGFloat, ciContext: CIContext, imageFilterValues: ImageFilterValues) -> UIImage {
    static func getImage(_ mainImage: UIImage, imageFilterNames: Dictionary<String, CGFloat>, ciContext: CIContext, imageFilterValues: ImageFilterValues) -> UIImage {
        var modifiedMainImage: UIImage?
        
        for (filterName, filterIntensity) in imageFilterNames {
            let filter = CIFilter(name: filterName)
            let ciImageFromMainImage = CIImage(image: modifiedMainImage != nil ? modifiedMainImage! : mainImage)
            
            if filter != nil {
                filter!.setValue(ciImageFromMainImage, forKey: kCIInputImageKey)
                
                switch filterName {
                case "CIGaussianBlur":
                    filter!.setValue(filterIntensity, forKey: kCIInputRadiusKey)
                case "CIVignette", "CISepiaTone", "CIBloom":
                    filter!.setValue(filterIntensity, forKey: kCIInputIntensityKey)
                case "CIHueAdjust":
                    filter!.setValue(filterIntensity, forKey: kCIInputAngleKey)
                default:
                    print("ERROR: Could not apply filter \(filterName)")
                }
            
                if let filteredImage = filter!.outputImage {
                    if let cgImageFromOutputImage = ciContext.createCGImage(filteredImage, from: filteredImage.extent) {
                        modifiedMainImage = UIImage(cgImage: cgImageFromOutputImage)
                    }
                }
            }
        }
        
        //if the above fails, return the image with no filters
        return modifiedMainImage != nil ? modifiedMainImage! : mainImage
    }
}
