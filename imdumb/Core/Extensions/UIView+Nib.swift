//
//  UIView+Nib.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 7/05/26.
//


import UIKit

extension UIView {

    static var nib: UINib {
        UINib(nibName: String(describing: self), bundle: nil)
    }

    static var reuseIdentifier: String {
        String(describing: self)
    }
}