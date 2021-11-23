
import UIKit

struct Category: Codable {
    let domain_id: String?
    let domain_name: String?
    let category_id: String
    let category_name: String
    let attributes: [ CategoryAttribute ]
}

struct CategoryAttribute: Codable {
    let id: String
    let value_id: Int
    let value_name: String
}
