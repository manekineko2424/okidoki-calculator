//
//  ColumnWidths.swift
//  MyFirstApp
//

import CoreGraphics

struct ColumnWidths {
    let col1: CGFloat
    let col2: CGFloat
    let col3: CGFloat
    let col4: CGFloat

    static func forWidth(_ width: CGFloat) -> ColumnWidths {
        let base: (CGFloat, CGFloat, CGFloat)
        switch width {
        case ..<361:
            base = (46, 62, 100)
        case 361..<391:
            base = (50, 66, 106)
        case 391..<431:
            base = (52, 70, 110)
        case 431..<481:
            base = (56, 76, 118)
        default:
            base = (62, 84, 126)
        }
        let fixed = base.0 + base.1 + base.2
        let col4 = max(0, width - fixed)
        return ColumnWidths(col1: base.0, col2: base.1, col3: base.2, col4: col4)
    }
}
