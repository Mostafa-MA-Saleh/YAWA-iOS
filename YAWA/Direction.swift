//
//  Direction.swift
//  YAWA
//
//  Created by Mostafa Saleh on 9/4/19.
//  Copyright © 2019 Mostafa Saleh. All rights reserved.
//

import Foundation

enum Direction: String, CaseIterable {
    case N
    case NNE
    case NE
    case ENE
    case E
    case ESE
    case SE
    case SSE
    case S
    case SSW
    case SW
    case WSW
    case W
    case WNW
    case NW
    case NNW

    static func from(angle: Float) -> Direction {
        let val = Int((angle / 22.5) + 0.5)
        return Direction.allCases[val % 16]
    }
}
