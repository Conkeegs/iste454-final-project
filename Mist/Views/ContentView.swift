//
//  ContentView.swift
//  Mist
//
//  Created by Conor Keegan and Max Gerber on 11/19/21.
//

import SwiftUI

struct ContentView: View {
    
    
    var body: some View {
        NavigationView(content: {
            NavigationLink("Image Editor", destination: {
                ImageEditor()
            }) //NavigationLink
        }) //NavigationView
    } //body
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
