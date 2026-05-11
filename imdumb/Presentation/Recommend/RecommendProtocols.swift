//
//  RecommendProtocols.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 7/05/26.
//

protocol RecommendViewProtocol: AnyObject {
    func showMovieInfo(title: String, overview: String)
    func showSuccess()
    func showError(message: String)
    func showLoading()
    func hideLoading()
    func setConfirmButtonEnabled(_ enabled: Bool)
}

protocol RecommendPresenterProtocol {
    func viewDidLoad()
    func didChangeComment(_ text: String)
    func didTapConfirm(comment: String)
    func dismiss()
}
