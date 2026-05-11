//
//  DebugProtocols.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 8/05/26.
//

protocol DebugViewProtocol: AnyObject {
    func reloadData()
}

protocol DebugPresenterProtocol {
    var items: [DebugConfigItem] { get }
    func viewDidLoad()
    func didToggleItem(at index: Int)
    func didTapDismiss()
}

enum DebugConfigValue {
    case toggle(Bool)
    case text(String)
}

struct DebugConfigItem {
    let key: String
    let displayName: String
    let value: DebugConfigValue
}
