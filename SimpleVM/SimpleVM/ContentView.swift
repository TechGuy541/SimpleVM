//
//  ContentView.swift
//  Virtual Macs.Intel
//
//  Created by Léopold on 17/11/2021.
//


import SwiftUI

struct ContentView: View {
    @State var isPopover = false
    var body: some View {
        VStack {
            Text("App crashed! click on the image to learn more")
            Button(action: { self.isPopover.toggle() }) {
                Image(nsImage: NSImage(named: NSImage.infoName) ?? NSImage())
            }.popover(isPresented: self.$isPopover, arrowEdge: .bottom) {
                PopoverView()
            }.buttonStyle(PlainButtonStyle())
        }.frame(width: 800, height: 600)
    }
}
struct PopoverView: View {
    var body: some View {
        VStack {
            Text("Sorry, this app does not work with Intel if you want this app to work: use a mac with the M1/M1 pro/M1 Max/M1 Ultra/M2 chip ").padding()
            Button("Quit",action: {NSApplication.shared.terminate(nil)} )
            
        }.padding()
    }
}


