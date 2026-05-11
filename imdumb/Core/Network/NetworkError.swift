//
//  NetworkError.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 7/05/26.
//


import Foundation
import Alamofire

enum NetworkError: Error, Equatable {
    case serverError(statusCode: Int)
    case decodingError
    case noConnection
    case timeout
    case unknown(String)

    var userMessage: String {
        switch self {
        case .serverError(let code):
            return "Error del servidor (\(code)). Intenta de nuevo."
        case .decodingError:
            return "Error al procesar los datos."
        case .noConnection:
            return "Sin conexion a internet."
        case .timeout:
            return "La solicitud tardo demasiado."
        case .unknown(let message):
            return message
        }
    }

    static func from(afError: AFError, statusCode: Int?) -> NetworkError {
        if let code = statusCode, code >= 500 {
            return .serverError(statusCode: code)
        }
        if afError.isSessionTaskError {
            return .noConnection
        }
        if afError.isResponseSerializationError {
            return .decodingError
        }
        return .unknown(afError.localizedDescription)
    }
}