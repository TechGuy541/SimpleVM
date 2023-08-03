//
//  ViewModel.swift
//  Virtual Machines
//
//  Created by Léopold on 13/06/2022.
//

import Foundation



class viewModel: ObservableObject {
    @Published var showLicenseInformationModal = false
    @Published var licenseInformationTitleString = ""
    @Published var licenseInformationString = ""
    func loadLicenseInformationFromBundle() {
        if let filepath = Bundle.main.path(forResource: "LICENSE", ofType: "") {
            do {
                let contents = try String(contentsOfFile: filepath)
                licenseInformationString = contents
            } catch {
                licenseInformationString = "Failed to load license information"
            }
        } else {
            licenseInformationString = "License information not found"
        }

        licenseInformationTitleString = "Virtual Machines"
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
           let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        {
            licenseInformationTitleString += " \(version) (Build \(build))"
        }
    }
    
}
