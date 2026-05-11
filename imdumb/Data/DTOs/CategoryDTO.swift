//
//  CategoryDTO.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 7/05/26.
//

import Foundation

struct GenreDTO: Decodable {
    
    let id: Int
    let name: String
    
}

struct GenreListDTO: Decodable {
    
    let genres: [GenreDTO]
}
