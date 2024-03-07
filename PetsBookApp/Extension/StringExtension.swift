//
//  StringExtension.swift
//  PetsBookApp

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, comment: self)
    }
}
