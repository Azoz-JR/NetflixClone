//
//  FileManager-DocumentDirectory.swift
//  Netflix
//
//  Created by Azoz Salah on 06/02/2023.
//

import Foundation

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}
