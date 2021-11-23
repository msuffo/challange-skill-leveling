import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var productThumbnail: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var productData: ProductInfo? = nil
    
    func populate(_ product: ProductInfo ) {
        productData = product
        productTitle.text = product.title
        titleLabel.text = "$ \( product.price)"
        
        let thumbnailUrl = URL( string: "https://" + product.pictures[0].url.components( separatedBy: "http://" )[ 1 ] )!
        productThumbnail.load( url: thumbnailUrl )
    }
}
