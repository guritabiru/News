//
//  Extension.swift
//  News
//
//  Created by Bimo Sekti Wicaksono on 04/09/23.
//

import Foundation
import UIKit

extension Date {
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self.addingTimeInterval(-15000), relativeTo: Date())
    }
}
