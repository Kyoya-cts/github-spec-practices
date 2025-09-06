import Foundation

enum AppError: Error, LocalizedError, Equatable {
    case validation(String)

    var errorDescription: String? {
        switch self {
        case .validation(let msg): return msg
        }
    }
}

