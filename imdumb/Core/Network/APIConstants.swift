//
//  APIConstants.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 7/05/26.
//

import Foundation

struct APIConstants {

    static let baseURL = "https://api.themoviedb.org/3"
    static let bearerToken: String = {
        let secrets = PlistSecretsProvider()
        guard let token = secrets.value(forKey: "TMDBBearerToken"), !token.isEmpty else {
            fatalError("TMDBBearerToken not found in Secrets.plist")
        }
        return token
    }()

    #if DEV
    static let imageBaseURL = "https://image.tmdb.org/t/p/w500"
    #else
    static let imageBaseURL = "https://image.tmdb.org/t/p/w780"
    #endif

    static func imageURL(from path: String?) -> URL? {
        guard let path else { return nil }
        return URL(string: imageBaseURL + path)
    }
}
