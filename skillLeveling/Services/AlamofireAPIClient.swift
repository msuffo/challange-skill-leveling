import Foundation
import Alamofire

class AlamofireAPIClient {
    private let token = "APP_USR-316579137400172-111915-d5739ad682acffbdd9417fabc6ecc849-375413519"

    func get(url: String, completion: @escaping (Result<Data?, AFError>)
    -> Void) {
        print( url )
        let headers: HTTPHeaders = [
            .authorization( "Bearer \( token )" )
        ]
        AF.request( url, headers: headers ).response { response in
            completion( response.result )
        }
    }
}
