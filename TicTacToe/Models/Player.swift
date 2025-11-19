//
//  Player.swift
//  TicTacToe
//
//  Created by Dmitry on 11/3/25.
//

import UIKit

struct Player {
    let type: PlayerType
    var name: String
    var winCounter = 0
}

extension Player {
    enum PlayerType {
        case x
        case o
    }
}



