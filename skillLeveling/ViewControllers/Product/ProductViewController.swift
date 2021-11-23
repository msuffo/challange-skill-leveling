import UIKit

class ProductViewController: UIViewController {
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var productPictureImageView: UIImageView!
    
    var product: ProductInfo? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        loadProduct()
    }
    
    func loadProduct() {
        let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
        let price = numberFormatter.string( from: NSNumber( value: product!.price ) )

        self.productTitleLabel.text = product!.title
        self.productPriceLabel.text = "\( product!.currency_id == "UYU" ? "$" : "U$S" ) \( price! )"
        
        let imageUrl = "https://" + product!.pictures[0].url.components( separatedBy: "http://" )[ 1 ]
        let url = URL( string: imageUrl )

        if let data = try? Data( contentsOf: url! ) {
            self.productPictureImageView.contentMode = .scaleAspectFit
            self.productPictureImageView.image = UIImage(data: data)
        }
        
        getProductDescription()
    }
    
    func getProductDescription() {
        SearchService.shared.getProductDescription( product!.id ?? "0", { description in
            self.productDescriptionLabel.text = description
        }, { error in
            self.productDescriptionLabel.text = "El vendedor no incluyó una descripción para el producto"
        } )
    }
    
    private func showErrorAlert(_ error: String ) {
        let alert = UIAlertController( title: "Error", message: error, preferredStyle: .alert )
        alert.addAction( UIAlertAction( title: "OK", style: .default, handler: nil ) )
        
        self.present( alert, animated: true )
    }
    
    @IBAction func backToSearch(_ sender: Any) {
        self.dismissDetail()
    }
}
