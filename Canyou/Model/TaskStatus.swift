//
//  TaskStatus.swift
//  Canyou
//
//  Created by Zakaria Mosa on 2021-02-18.
//

import Foundation

enum TaskStatus: Equatable, CaseIterable {
    case taskinitializedbuthasnotoffers
    case taskhasoffersbutnoofferaccepted
    case taskinprogress
}
