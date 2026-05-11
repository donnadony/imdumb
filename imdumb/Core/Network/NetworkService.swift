//
//  NetworkService.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 7/05/26.
//


import Foundation
import Alamofire

protocol NetworkServiceProtocol {
    func request<T: Decodable>(
        _ router: APIRouter,
        completion: @escaping (Result<T, NetworkError>) -> Void
    )
}

final class NetworkService: NetworkServiceProtocol {

    private let session: Session

    init(session: Session = .default) {
        self.session = session
    }

    func request<T: Decodable>(
        _ router: APIRouter,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        let afRequest = session.request(router)
        #if DEV
        logRequest(afRequest, router: router)
        #endif
        afRequest
            .validate(statusCode: 200..<300)
            .responseDecodable(of: T.self) { [weak self] response in
                #if DEV
                self?.logResponse(response)
                #endif
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    let networkError = NetworkError.from(
                        afError: error,
                        statusCode: response.response?.statusCode
                    )
                    completion(.failure(networkError))
                }
            }
    }

    #if DEV
    private func logRequest(_ request: DataRequest, router: APIRouter) {
        request.cURLDescription { curl in
            print("📡 [REQUEST] \(router)")
            print("   \(curl)")
        }
    }

    private func logResponse<T>(_ response: DataResponse<T, AFError>) {
        let status = response.response?.statusCode ?? 0
        let url = response.request?.url?.absoluteString ?? "unknown"
        switch response.result {
        case .success:
            print("✅ [RESPONSE] \(status) \(url)")
        case .failure(let error):
            print("❌ [RESPONSE] \(status) \(url)")
            print("   Error: \(error)")
            if let data = response.data, let body = String(data: data, encoding: .utf8) {
                print("   Body: \(body.prefix(300))")
            }
        }
    }
    #endif
}