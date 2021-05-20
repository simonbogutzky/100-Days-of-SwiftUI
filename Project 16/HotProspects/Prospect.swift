//
//  Prospect.swift
//  HotProspects
//
//  Created by Simon Bogutzky on 12.12.20.
//

import SwiftUI

class Prospect: Identifiable, Codable {
    var id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    var date = Date()
    fileprivate(set) var isContacted = false
}

class Prospects: ObservableObject {
    
    static let saveKey = "SavedData"
    
    @Published private(set) var people: [Prospect] = []
    
    init() {
//        if let data = UserDefaults.standard.data(forKey: Self.saveKey) {
//            if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
//                self.people = decoded
//                return
//            }
//        }
        
        loadData()
    }
    
//    private func save() {
//        if let encoded = try? JSONEncoder().encode(people) {
//            UserDefaults.standard.set(encoded, forKey: Self.saveKey)
//        }
//    }
    
    func add(_ prospect: Prospect) {
        people.append(prospect)
        saveData()
    }
    
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        saveData()
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func loadData() {
        let filename = getDocumentsDirectory().appendingPathComponent(Self.saveKey)

        do {
            let data = try Data(contentsOf: filename)
            people = try JSONDecoder().decode([Prospect].self, from: data)
        } catch {
            print("Unable to load saved data.")
        }
    }

    func saveData() {
        do {
            let filename = getDocumentsDirectory().appendingPathComponent(Self.saveKey)
            let data = try JSONEncoder().encode(self.people)
            try data.write(to: filename, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Unable to save data.")
        }
    }
}
