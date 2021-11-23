struct TopProductsRes: Codable {
    let content: [ Product ]?
    let status: Int?
}

struct Product: Codable {
    let id: String
}

struct ProductInfoRes: Codable {
    let body: ProductInfo
}

struct ProductInfo: Codable {
    let id: String
    let title: String
    let price: Float
    let thumbnail: String
    let pictures: [ ProductInfoPicture ]
    let currency_id: String
}

struct ProductInfoPicture: Codable {
    let id: String
    let url: String
}

struct ProductDescription: Codable {
    let plain_text: String
}
