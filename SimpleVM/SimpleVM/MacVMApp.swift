//
//  MacVMApp.swift
//  MacVM
//
//  Created by Léopold Schaffhauser on 6/28/21.
//



import SwiftUI
@main
struct MacVMApp: App {
    
    
    
    
    
#if arch(arm64)
    
    
    
    @State private var showingAlert = true
    
    var body: some Scene {
        
        
        DocumentGroup {
            VMDocument()
        } editor: { configuration in
            VMView(
                document: configuration.document,
                fileURL: configuration.fileURL
            )
            .frame(width: 1000, height: 625)
            
            
        }
    }
#else
    
    var body: some Scene {
        WindowGroup{
            ContentView()
            
        }
    }
#endif
    
    
}
