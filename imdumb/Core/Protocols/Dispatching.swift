//
//  Dispatching.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 8/05/26.
//

import Foundation

protocol Dispatching {
    func dispatch(_ work: @escaping () -> Void)
}

extension DispatchQueue: Dispatching {
    func dispatch(_ work: @escaping () -> Void) {
        async(execute: work)
    }
}
