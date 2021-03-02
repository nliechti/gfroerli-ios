//
//  Sponsor.swift
//  Gfror.li
//
//  Created by Marc Kramer on 05.10.20.
//

import Foundation

struct Sponsor: Codable, Identifiable {
    
    init(id: Int, name: String, description: String,  created_at: String) {
        self.id = id
        self.name = name
        self.description = description
    }
    
    let id : Int
    let name : String
    let description : String


    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case description = "description"
    }

    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        description = try values.decode(String.self, forKey: .description)
    }
}
