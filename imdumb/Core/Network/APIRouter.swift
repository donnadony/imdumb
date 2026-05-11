//
//  APIRouter.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 7/05/26.
//

import Foundation
import Alamofire

enum APIRouter: URLRequestConvertible {
    
    // MARK: - Properties
    
    case getGenres
    case getMoviesByGenre(genreId: Int, page: Int)
    case getMovieDetail(movieId: Int)
    case searchMovies(query: String, page: Int)

    var baseURL: URL {
        guard let url = URL(string: APIConstants.baseURL) else {
            fatalError("Invalid base URL: \(APIConstants.baseURL)")
        }
        return url
    }

    var path: String {
        switch self {
        case .getGenres:
            return "/genre/movie/list"
        case .getMoviesByGenre:
            return "/discover/movie"
        case .getMovieDetail(let movieId):
            return "/movie/\(movieId)"
        case .searchMovies:
            return "/search/movie"
        }
    }

    var method: HTTPMethod { .get }

    var parameters: Parameters? {
        var params: Parameters = [
            "language": "es"
        ]
        switch self {
        case .getMoviesByGenre(let genreId, let page):
            params["with_genres"] = genreId
            params["page"] = page
        case .getMovieDetail:
            params["append_to_response"] = "credits,images"
        case .searchMovies(let query, let page):
            params["query"] = query
            params["page"] = page
        default:
            break
        }
        return params
    }

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method
        request.setValue("Bearer \(APIConstants.bearerToken)", forHTTPHeaderField: "Authorization")
        request = try URLEncoding.default.encode(request, with: parameters)
        return request
    }
    
}
