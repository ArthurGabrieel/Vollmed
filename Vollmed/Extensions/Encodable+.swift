//
//  Encodable+.swift
//  Vollmed
//
//  Created by Arthur Gabriel Gomes on 28/12/23.
//

import Foundation

extension Encodable {
    func toJson() -> [String: String]? {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: JSONEncoder().encode(self))
            if let dictionary = jsonObject as? [String: String] {
                return dictionary
            } else {
                return nil
            }
        } catch {
            print("Error converting to JSON: \(error)")
            return nil
        }
    }
}
