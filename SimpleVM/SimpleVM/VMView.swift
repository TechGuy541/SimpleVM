//
//  VMView.swift
//  MacVM
//
//  Created by Léopold Schaffhauser on 6/28/21.
//
#if arch(arm64)
import SwiftUI

struct VMView: View {
    
    @ObservedObject var document: VMDocument
    var fileURL: URL?
    
    /// - Tag: ToggleAction
    var body: some View {
        Group {
            if let fileURL = fileURL {
                if document.content.installed {
                    VMUIView(virtualMachine: document.vmInstance?.virtualMachine)
                } else {
                    VMInstallView(
                        fileURL: fileURL,
                        document: document,
                        state: document.vmInstallationState
                    )
                }
            } else {
                VMInstallView(
                    fileURL: fileURL,
                    document: document,
                    state: document.vmInstallationState
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .toolbar {
            ToolbarItem {
                HStack {
                    
                    Button(action: {
                        guard let fileURL = fileURL else {
                            return
                        }
                        
                        if document.isRunning {
                            document.vmInstance?.stop()
                        } else {
                            document.createVMInstance(with: fileURL)
                            document.vmInstance?.start()
                        }
                    }) {
                        Image(systemName: document.isRunning ? "stop" : "play.fill")
                            .font(.system(size: 24, weight: .regular, design: .rounded))
                    }
                    
                    
                    
                }
                    
                
                .buttonStyle(BorderlessButtonStyle())
                .disabled(!document.content.installed)
            }
        }

    }
}
#endif
