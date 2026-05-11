//
//  OnboardingPresenter.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 8/05/26.
//

final class OnboardingPresenter: OnboardingPresenterProtocol {

    weak var view: OnboardingViewProtocol?
    private let onDismiss: () -> Void

    init(onDismiss: @escaping () -> Void) {
        self.onDismiss = onDismiss
    }

    func didTapGotIt() {
        onDismiss()
    }
}
