//
//  activity.swift
//  KeepTrack
//
//  Created by Simon Bogutzky on 03.11.20.
//

import Foundation

struct Activity: Identifiable, Codable {
    var id = UUID()
    let title: String
    let description: String
    var completionCount = 0
}

