//
//  SwiftBooruError.swift
//  SwiftBooru
//
//  Created by Ethan Woods on 16/03/2023.
//

import AudioToolbox
import Foundation
import SwiftUI

enum SwiftBooruError: Error {
    case missingCacheFile
}

extension SwiftBooruError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .missingCacheFile:
            return NSLocalizedString("warning.missingCacheFile", comment: "")
        }
    }
}
