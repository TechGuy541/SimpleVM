//
//  VMInstallView.swift
//  MacVM
//
//  Created by Léopold Schaffhauser on 6/28/21.
//
#if arch(arm64)
import SwiftUI
import UniformTypeIdentifiers



struct VMInstallView: View {
    
    var fileURL: URL?
    var document: VMDocument
    @Environment(\.undoManager) var undoManager
    @ObservedObject var state: VMInstallationState
        
    @State var cpuCount: Int = 2
    @State var memorySize: UInt64 = 2
    @State var diskSize: String = "32"
    
    @State var presentFileSelector = false
    @State var skipInstallation = false
    @State var ipswURL: URL?
    
    private static let memoryUnit: UInt64 = 1024 * 1024 * 1024
    private let availableMemoryOptions: [UInt64] = {
        let availableMemory = ProcessInfo.processInfo.physicalMemory
        
        var availableOptions: [UInt64] = []
        var memorySize: UInt64 = 2
        
        while memorySize * memoryUnit <= availableMemory {
            availableOptions.append(memorySize)
            memorySize += 2
        }
        
        return availableOptions
    }()
    
    var body: some View {
        if let fileURL = fileURL {
            if let ipswURL = ipswURL {
                VStack {
                    if state.isInstalling, let progress = state.progress {
                        ProgressView(progress)
                    } else {
                        Button("Install") {
                            document.createVMInstance(with: fileURL)
                            document.vmInstance?.diskImageSize = document.content.diskSize
                            document.vmInstance?.startInstaller(
                                with: ipswURL,
                                skipActualInstallation: skipInstallation,
                                completion: { _ in
                                    save()
                                }
                            )
                        }
                        .disabled(state.isInstalling)
                    }
                }
                .padding()
            } else {
                VStack {
                    
                    Button("Select IPSW and Continue") {
                        presentFileSelector = true
                    }
                    Link("or download IPSW", destination: URL(string: "https://catsoftware.dev/ipsw/")!)
                    .fileImporter(
                        isPresented: $presentFileSelector,
                        allowedContentTypes: [
                            UTType(filenameExtension: "ipsw") ?? .data
                        ],
                        onCompletion: { result in
                            switch result {
                            case .success(let url):
                                ipswURL = url
                                if skipInstallation {
                                    document.createVMInstance(with: fileURL)
                                    document.vmInstance?.diskImageSize = document.content.diskSize
                                    document.vmInstance?.startInstaller(
                                        with: url,
                                        skipActualInstallation: skipInstallation,
                                        completion: { _ in
                                            save()
                                        }
                                    )
                                }
                            case .failure(let error):
                                print(error)

                            }
                        }
                    )
                }
                .padding()
            }
        } else {
            Form {
                Section {
                    Picker("CPU Count", selection: $cpuCount) {
                        ForEach(2...ProcessInfo.processInfo.processorCount, id: \.self) { count in
                            Text("\(count)")
                        }
                    }
                    Picker("Memory Size", selection: $memorySize) {
                        ForEach(availableMemoryOptions, id: \.self) { count in
                            Text("\(count) GB")
                        }
                    }
                    TextField("Disk Size (GB)", text: $diskSize)
                }
                
                Section {
                    Text("Save to continue...")
                }
            }
            .padding()
            .onChange(of: cpuCount) { newValue in
                document.content.cpuCount = newValue
                save()
            }
            .onChange(of: memorySize) { newValue in
                document.content.memorySize = UInt64(newValue) * 1024 * 1024 * 1024
                save()
            }
            .onChange(of: diskSize) { newValue in
                document.content.diskSize = UInt64(newValue) ?? 32
                save()
            }
        }

    }
  
    
    func save() {
        undoManager?.registerUndo(withTarget: document, handler: { _ in })
    }
}
#endif
