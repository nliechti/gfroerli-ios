//
//  Sponsor.swift
//  Gfror.li
//
//  Created by Marc Kramer on 05.10.20.
//

import Foundation

struct Sponsor: Codable, Identifiable {
    
    init(id: Int?, name: String?, description: String?, active: Bool?,  created_at: String?, updated_at: String?, url: String?) {
        self.id = id
        self.name = name
        self.description = description
        self.active = active
        self.created_at = created_at
        self.updated_at = updated_at
        self.url = url
    }
    
    let id : Int?
    let name : String?
    let description : String?
    let active : Bool?
    let created_at : String?
    let updated_at : String?
    let url : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case description = "description"
        case active = "active"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case url = "url"
    }

    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        active = try values.decodeIfPresent(Bool.self, forKey: .active)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        url = try values.decodeIfPresent(String.self, forKey: .url)
    }
}
