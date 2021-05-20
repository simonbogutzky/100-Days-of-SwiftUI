//
//  MeetingPicture.swift
//  MeetingPictures
//
//  Created by Simon Bogutzky on 05.12.20.
//

import CoreLocation
import Foundation

struct MeetingPicture: Codable, Identifiable, Comparable {
    var id = UUID()
    var name: String?
    var imageData: Data?
    var latitude: Double?
    var longitude: Double?
    var wrappedName: String {
        name ?? ""
    }
    var location: CLLocationCoordinate2D {
        if let latitude = self.latitude, let longitude = self.longitude {
            return CLLocationCoordinate2DMake(latitude, longitude)
        }
        return CLLocationCoordinate2DMake(0.0, 0.0)
    }

    static func < (lhs: MeetingPicture, rhs: MeetingPicture) -> Bool {
        lhs.wrappedName < rhs.wrappedName
    }
}
