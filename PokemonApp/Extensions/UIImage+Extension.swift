import UIKit

extension UIImage {
    func toPngString() -> String? {
        self.pngData()?.base64EncodedString(options: .endLineWithLineFeed)
    }
}
