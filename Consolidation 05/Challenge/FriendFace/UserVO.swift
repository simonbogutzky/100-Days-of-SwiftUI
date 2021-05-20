//
//  UserVO.swift
//  FriendFace
//
//  Created by Simon Bogutzky on 18.11.20.
//

import Foundation

struct UserVO: Identifiable, Codable {
    var id: UUID
    var name: String
    var address: String
    var email: String
    var company: String
    var friends: [FriendVO]
}
