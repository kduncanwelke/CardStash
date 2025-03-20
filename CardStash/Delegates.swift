//
//  Delegates.swift
//  CardStash
//
//  Created by Katherine Duncan-Welke on 3/19/25.
//

import Foundation

protocol UpdateCellDelegate: AnyObject {
    func updateCell(index: IndexPath, wasDeleted: Bool)
}
