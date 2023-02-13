//
//  Extensions.swift
//  Netflix
//
//  Created by Azoz Salah on 02/02/2023.
//

import Foundation

extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
