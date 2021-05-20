//
//  Activities.swift
//  KeepTrack
//
//  Created by Simon Bogutzky on 03.11.20.
//

import Foundation

class ActivityRepository: ObservableObject {    
    @Published var activities: [Activity] {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(activities) {
                UserDefaults.standard.set(encoded, forKey: "Activities")
            }
        }
    }
    
    init() {
        if let items = UserDefaults.standard.data(forKey: "Activities") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Activity].self, from: items) {
                self.activities = decoded
                return
            }
        }

        self.activities = []
    }
}
