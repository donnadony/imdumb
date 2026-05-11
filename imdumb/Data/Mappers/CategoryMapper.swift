//
//  CategoryMapper.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 7/05/26.
//

struct CategoryMapper {

    static func toDomain(_ dto: GenreDTO) -> Category {
        Category(id: dto.id, name: dto.name, movies: [])
    }
}
