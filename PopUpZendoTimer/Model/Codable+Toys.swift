//
//  Codable+Toys.swift
//  PopUpZendoTimer
//
//  Created by Joseph Hall on 5/28/20.
//  Copyright © 2020 Joseph Hall. All rights reserved.
//

import Foundation

extension Decodable {
    static func load(from json: [String: Any]) -> Self? {
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: [])
        
            return try JSONDecoder().decode(self, from: data)
        } catch {
            print("Error when loading \(self): \(error)")
        }
        return nil
    }
}

extension Encodable {
    var toJSON: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else { return nil }
        return json as? [String: Any]
    }
}
