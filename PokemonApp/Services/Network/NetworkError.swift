import Foundation

enum NetworkError: Error, LocalizedError {
    
    case invalidResponse(URLResponse?)
    case noDataReceived
    case invalidData(DecodingError)
    case noConnection
    case invalidRequest(Error)
    case timeout
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse(_):
            return "Invalid response from server)"
        case .noDataReceived:
            return "No data received from the server"
        case .invalidData(_):
            return "Invalid data received"
        case .noConnection:
            return "No internet connection"
        case .timeout:
            return "Request timed out"
        case .unknown(_):
            return "Unknown error occurred"
        case .invalidRequest(_):
            return "Something wrong with our request, we will fix it "
        }
        
    }
}
