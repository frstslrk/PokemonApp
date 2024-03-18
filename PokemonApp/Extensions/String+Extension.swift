import UIKit

extension String {
    func toImage() -> UIImage {
        guard let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters) else {
            return UIImage()
        }
        return UIImage(data: data) ?? UIImage()
    }
}
