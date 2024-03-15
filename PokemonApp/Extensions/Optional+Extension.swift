import UIKit

extension Optional where Wrapped == String {
    var unwrapped: String {
        switch self {
        case .none:
            return ""
        case .some(let wrapped):
            return wrapped
        }
    }
}

extension Optional where Wrapped == UIImage {
    var unwrapped: UIImage {
        switch self {
        case .none:
            return UIImage()
        case .some(let wrapped):
            return wrapped
        }
    }
}
