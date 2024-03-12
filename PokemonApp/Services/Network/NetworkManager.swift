import Foundation

class NetworkManager {
    
    private enum Constants {
        static let baseAPIURL = "https://pokeapi.co/api/v2/pokemon"
    }
    
    enum APIError: Error {
        case failedToGetData
    }
    
    enum HTTPMethod: String{
        case GET
        case POST
    }
    
    public func getPokemons(page: Int, completion: @escaping(Result<PokemonList,Error>)->Void){
        createRequest(
            with: URL(string: Constants.baseAPIURL + "?offset=\(page * 20)&limit=20"),
            type: HTTPMethod.GET
        ){ request in
            let task = URLSession.shared.dataTask(with: request){data,_,error in
                guard let data = data,error == nil else{
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(PokemonList.self, from: data)
                    completion(.success(result))
                }catch{
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    private func createRequest(with url: URL?, type: HTTPMethod, completion: @escaping (URLRequest) -> Void) {
        guard let apiURL = url else {return}
        var request = URLRequest(url:apiURL)
        request.httpMethod = type.rawValue
        request.timeoutInterval = 30
        completion(request)
    }
}
