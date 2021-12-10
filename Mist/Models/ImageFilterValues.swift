//
//  ImageFilterValues.swift
//  ImageFilterValues
//
//  Created by Conor Keegan on 12/9/21.
//

import SwiftUI

class ImageFilterValues: ObservableObject {
    @Published var blurFilterSelected = false
    @Published var blurAmount: CGFloat = 0
    
    @Published var vignetteFilterSelected = false
    @Published var vignetteAmount: CGFloat = 0
    
    @Published var sepiaToneFilterSelected = false
    @Published var sepiaToneAmount: CGFloat = 0
    
    @Published var bloomFilterSelected = false
    @Published var bloomAmount: CGFloat = 0
    
    @Published var hueFilterSelected = false
    @Published var hueAmount: CGFloat = 0
    
    @Published var imageFilterNames: [String: CGFloat] = [:]
}
