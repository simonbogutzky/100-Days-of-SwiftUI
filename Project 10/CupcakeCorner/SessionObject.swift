//
//  SessionObject.swift
//  CupcakeCorner
//
//  Created by Simon Bogutzky on 08.11.20.
//

import Foundation

class SessionObject: ObservableObject, Codable {
    enum CodingKeys: CodingKey {
        case order
    }
    
    @Published var order = Order()
    
    init() { }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        order = try container.decode(Order.self, forKey: .order)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(order, forKey: .order)
    }
}
