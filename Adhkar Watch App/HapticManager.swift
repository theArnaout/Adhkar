//
//  HapticManager.swift
//  Adhkar
//
//  Created by Mohamad Arnaout on 2025-05-01.
//

import WatchKit

struct HapticManager {
    static func play(_ type: WKHapticType) {
        WKInterfaceDevice.current().play(type)
    }
}
