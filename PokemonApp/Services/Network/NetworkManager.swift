import Foundation

typealias GenericDataCompletion<T> = ((_ result: Result<T, NetworkError>) -> Void)

final class NetworkManager {
    enum HTTPMethod: String {
        case GET
        case POST
    }
    
    func request<T: Codable>(
        _ controller: ApiController,
        completionQueue: DispatchQueue? = .global(),
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        guard let url = controller.url else { return }

        parseRequest(
            request: createRequest(with: url, type: controller.method),
            completionQueue: completionQueue,
            completion: completion
        )
    }

    private func parseRequest<T: Codable>(
        request: URLRequest,
        completionQueue: DispatchQueue?,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        URLSession.shared.dataTask(
            with: request,
            completionHandler: { [weak self] data, response, error in
                guard let self else { return }

                if let error {
                    let parsedError = self.parseError(error)
                    self.throwResultOnQueue(completionQueue: completionQueue, result: .failure(parsedError), completion: completion)
                    return
                }
                
                guard let data else  {
                    self.throwResultOnQueue(completionQueue: completionQueue, result: .failure(NetworkError.noDataReceived), completion: completion)
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    self.throwResultOnQueue(completionQueue: completionQueue, result: .success(result), completion: completion)
                } catch{
                    self.throwResultOnQueue(completionQueue: completionQueue, result: .failure(.invalidData(error as! DecodingError)), completion: completion)
                    return
                }
        })
        .resume()
    }

    private func throwResultOnQueue<T: Codable>(
        completionQueue: DispatchQueue?,
        result: Result<T, NetworkError>,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        if let completionQueue {
            completionQueue.async {
                completion(result)
            }
        } else {
            completion(result)
        }
    }

    private func parseError(_ error: Error) -> NetworkError {
        switch (error as NSError).code {
        case NSURLErrorNotConnectedToInternet,NSURLErrorCannotConnectToHost:
            return .noConnection
        case NSURLErrorTimedOut:
            return .timeout
        case NSURLErrorBadURL:
            return .invalidRequest(error)
        default:
            return .unknown(error)
        }
    }

    private func createRequest(
        with url: URL,
        type: HTTPMethod,
        timeOutInterval: TimeInterval = 30
    ) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = type.rawValue
        request.timeoutInterval = timeOutInterval
        return request
    }
}
