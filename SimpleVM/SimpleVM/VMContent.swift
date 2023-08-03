//
//  VMContent.swift
//  MacVMb
//
//  Created by Léopold Schaffhauser on 6/28/21.
//

import Foundation
import Virtualization


struct VMContent: Codable {
    
    var identifier: String
    var installed: Bool = false
    
    var hardwareModelData: Data?
    var machineIdentifierData: Data?
    
    var cpuCount: Int = 2
    var memorySize: UInt64 = 4 * 1024 * 1024 * 1024
    var diskSize: UInt64 = 100
}

