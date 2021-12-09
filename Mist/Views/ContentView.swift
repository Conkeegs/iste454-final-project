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
            ZStack{
                NavigationLink("+", destination: {
                    ImageEditor()
                })
                    .frame(width: 40.0, height: 40.0)
                    .background(Color.gray).padding(5)
                    .overlay(RoundedRectangle(cornerRadius: 3).stroke(Color.white))
                    .offset(x: 150, y: 280)
                YourTemplates()
            }
            .frame(maxWidth: .infinity)
            .background(Color.cyan)
        }) //NavigationView
    } //body
}//View
