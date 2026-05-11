//
//  MovieMapper.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 7/05/26.
//

struct MovieMapper {

    static func toDomain(_ dto: MovieDTO) -> Movie {
        Movie(
            id: dto.id,
            title: dto.title,
            overview: dto.overview,
            posterPath: dto.posterPath,
            backdropPath: dto.backdropPath,
            voteAverage: dto.voteAverage,
            releaseDate: dto.releaseDate ?? "",
            genres: [],
            runtime: nil,
            cast: [],
            images: []
        )
    }

    static func toDomain(_ dto: MovieDetailDTO) -> Movie {
        Movie(
            id: dto.id,
            title: dto.title,
            overview: dto.overview,
            posterPath: dto.posterPath,
            backdropPath: dto.backdropPath,
            voteAverage: dto.voteAverage,
            releaseDate: dto.releaseDate ?? "",
            genres: dto.genres?.map { Movie.Genre(id: $0.id, name: $0.name) } ?? [],
            runtime: dto.runtime,
            cast: dto.credits?.cast?.prefix(10).map { castDTO in
                Actor(
                    id: castDTO.id,
                    name: castDTO.name,
                    character: castDTO.character ?? "",
                    profilePath: castDTO.profilePath
                )
            } ?? [],
            images: dto.images?.backdrops?.prefix(5).map {
                Movie.MovieImage(filePath: $0.filePath)
            } ?? []
        )
    }
}
