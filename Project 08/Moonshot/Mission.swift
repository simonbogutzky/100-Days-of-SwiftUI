//
//  Mission.swift
//  Moonshot
//
//  Created by Simon Bogutzky on 27.10.20.
//

import Foundation

struct Mission: Codable, Identifiable {
    struct CrewRole: Codable {
        let name: String
        let role: String
    }
    
    let id: Int
    let launchDate: Date?
    let crew: [CrewRole]
    let description: String
    
    var displayName: String {
        "Apollo \(id)"
    }
    
    var image: String {
        "apollo\(id)"
    }
    
    var crewNames: String {
        var crewNames = [String]()
        for member in crew {
            crewNames.append(member.name.capitalized)
        }
        
        return crewNames.joined(separator: ", ")
    }
    
    var formattedLaunchDate: String {
        if let launchDate = launchDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            return formatter.string(from: launchDate)
        }
        return "N/A"
    }
}
