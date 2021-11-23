import UIKit

class SearchService {
    
    static let shared = SearchService()
    private let apiClient = AlamofireAPIClient()
    
    private let baseUrl = "https://api.mercadolibre.com/"
    private let baseUrlSites = "https://api.mercadolibre.com/sites/MLU/"
    
    public func getCategory(_ categoryName: String,_ completion: @escaping ( Category ) -> Void,_ onError: @escaping ( String ) -> Void ) {
        let url = baseUrlSites + "domain_discovery/search?q=\( categoryName )&limit=1"
        
        apiClient.get(url: url) { response in
            switch response {
                case .success(let data):
                    do {
                        if let data = data {
                            let categoryRes = try JSONDecoder().decode( [ Category ].self, from: data )
                            if ( categoryRes != nil ) {
                                if ( categoryRes != nil &&  categoryRes.isEmpty == false ) {                                    completion( (categoryRes[0]) )
                                } else {
                                    onError( "No se encontró la categoría" )
                                }
                            } else {
                                onError( "Ocurrió un error obteniendo la categoría. Verificar token" )
                            }
                        }
                    } catch let error {
                        print( error )
                        onError( error.localizedDescription )
                    }
                case .failure(_):
                    onError( "Ocurrió un error obteniendo la categoría" )
            }
        }
    }
    
    public func getCategoryTops(_ categoryId: String,_ completion: @escaping ( [ Product ] ) -> Void,_ onError: @escaping ( String ) -> Void ) {
        let url = baseUrl + "highlights/MLU/category/\( categoryId )"
        
        apiClient.get(url: url) { response in
            switch response {
                case .success(let data):
                    do {
                        if let data = data {
                            let topProductsRes = try JSONDecoder().decode( TopProductsRes.self, from: data )
                            
                            if ( topProductsRes.status == nil ) {
                                if ( topProductsRes.content == nil || ((topProductsRes.content?.isEmpty) != nil) ) {
                                    completion( topProductsRes.content! )
                                } else {
                                    onError( "No se encontraron los artículos más vendidos para la categoría" )
                                }
                            } else {
                                if topProductsRes.status == 404 {
                                    onError( "No se encontraron los artículos más vendidos para la categoría" )
                                } else {
                                    onError( "Ocurrió un error obteniendo los artículos. Verificar token" )
                                }
                            }
                            
                        }
                    } catch let error {
                        onError( "No se encontraron los más vendidos para la categoría" )
                    }
                case .failure(_):
                    onError( "Ocurrió un error obteniendo los artículos." )
            }
        }
    }
    
    public func getProductInfo(_ productsIds: String,_ completion: @escaping ( [ProductInfoRes] ) -> Void,_ onError: @escaping ( String ) -> Void ) {
        let url = baseUrl + "items?ids=\( productsIds )"
        
        apiClient.get(url: url) { response in
            switch response {
                case .success(let data):
                    do {
                        if let data = data {
                            let productsInfo = try JSONDecoder().decode( [ ProductInfoRes ].self, from: data )
                            
                            if ( productsInfo.isEmpty ) {
                                onError( "Ocurrió un error obteniendo la información del producto" )
                            }

                            completion( productsInfo )
                        }
                    } catch let error {
                        onError( error.localizedDescription )
                    }
                case .failure(_):
                    onError( "Ocurrió un error obteniendo la información del producto" )
            }
        }
    }
    
    public func getProductDescription(_ productId: String,_ completion: @escaping ( String ) -> Void,_ onError: @escaping ( String ) -> Void ) {
        let url = baseUrl + "items/\( productId )/description"
        
        apiClient.get(url: url) { response in
            switch response {
                case .success(let data):
                    do {
                        if let data = data {
                            let productDescription = try JSONDecoder().decode( ProductDescription.self, from: data )
                            
                            completion( productDescription.plain_text )
                        }
                    } catch let error {
                        onError( "Ocurrió un error obteniendo la descripción del producto" )
                    }
                case .failure(_):
                    onError( "Ocurrió un error obteniendo la descripción del producto" )
            }
        }
    }
}
