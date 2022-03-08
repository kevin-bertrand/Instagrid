//
//  Layout.swift
//  Instagrid
//
//  Created by Kevin Bertrand on 23/02/2022.
//

import Foundation

// The Int Raw value represent the position of the layout button on the screen. 0 corresponds to the first button on the left (or top if the device is in landscape), the 1 corresponds to the middle layout button and the 2 corresponds to the last layout button (to the right for portrait mode and bottom for landscape mode).
enum Layout: Int {
    case oneImageTop = 0
    case oneImageBottom = 1
    case allFour = 2
}
