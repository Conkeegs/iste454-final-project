//
//  TextFilterValues.swift
//  TextFilterValues
//
//  Created by Conor Keegan on 12/10/21.
//

import SwiftUI

class TextFilterValues: ObservableObject {
    @Published var obliquenessSelected = false
    @Published var obliquenessAmount: Float = 0
    
    @Published var textFilterNames: [String: Any] = [:]
}
