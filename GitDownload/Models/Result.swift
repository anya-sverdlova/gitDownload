//
//  Result.swift
//  GitDownload
//
//  Created by Anna Sverdlova on 27.10.2020.
//

import Foundation

struct Result {
    var name: String
    var description: String
    var stars: String

    init(_ data: [String: Any]) {
        self.name = data["name"] as? String ?? "no name"
        self.description = data["description"] as? String ?? "no description"
        self.stars = String(data["stargazers_count"] as? Int ?? 0)
    }
}
