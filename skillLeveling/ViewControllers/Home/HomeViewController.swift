import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var searchBarField: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var loadingLabel: UILabel!
    
    public var results: [ ProductInfo ] = []
    
    override func viewDidLoad() {
        configDismisskeyBoard()
        setupSearchBar()
        setupTableView()
        
        navigationController?.navigationBar.barStyle = .black
    }
    
    private func setupSearchBar() {
        searchBarField.delegate = self
        searchBarField.layer.cornerRadius = 20
        searchBarField.clipsToBounds = true
        searchBarField.searchTextField.backgroundColor = UIColor.white
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = true;
        tableView.rowHeight = 120
        tableView.register( UINib( nibName: "TableViewCell", bundle: nil ), forCellReuseIdentifier: "TableViewCell" )
    }
    
    func showProductInfo(_ index: Int ) {
        let vc = ProductViewController( nibName: "ProductViewController", bundle: nil )
        vc.product = results[ index ]
        vc.modalPresentationStyle = .overFullScreen
        
        self.presentDetail( vc )
    }
    
    func getCategory(_ categoryName: String ) {
        self.logoImageView.isHidden = false;
        self.loadingLabel.isHidden = false;
        self.tableView.isHidden = true;
        self.results = []

        SearchService.shared.getCategory( categoryName, { data in
            print( data )
            self.getCategoryTops( data.category_id )
        }, { data in
            self.showErrorAlert( data )
        } )
    }
    
    func getCategoryTops(_ categoryId: String ) {
        SearchService.shared.getCategoryTops( categoryId, { data in
            self.getProductsInfo( data )
        }, { data in
            self.showErrorAlert( data )
        } )
    }
    
    func getProductsInfo(_ data: [ Product ] ) {
        let productsIds = ( data.map{ $0.id } ).joined( separator: "," )
        SearchService.shared.getProductInfo( productsIds, { products in
            for product in products {
                self.results.append( product.body )
                self.logoImageView.isHidden = true;
                self.loadingLabel.isHidden = true;
                self.tableView.isHidden = false
                
                ;
                self.showResults()
            }
        }, { error in
            self.showErrorAlert( error )
        } )
    }
    
    private func showErrorAlert(_ error: String ) {
        let alert = UIAlertController( title: "Error", message: error, preferredStyle: .alert )
        alert.addAction( UIAlertAction( title: "OK", style: .default, handler: nil ) )
        
        self.present( alert, animated: true )
    }

    private func showResults() {
        tableView.reloadData()
    }

    @objc func dismissKeyboard() {
        view.endEditing( true )
    }
    
    func configDismisskeyBoard() {
        let tap = UITapGestureRecognizer( target: self, action: #selector( UIInputViewController.dismissKeyboard ) )
        view.addGestureRecognizer( tap )
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if ( searchBar.text!.trimmingCharacters( in: .whitespaces ).count < 2 ) {
            return
        } else {
            print( "\( searchBarField.text! )" )
            getCategory( searchBar.text!.trimmingCharacters( in: .whitespaces ) )
        }
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell( withIdentifier: "TableViewCell" ) as! TableViewCell
        
        switch ( indexPath.section ) {
            case 0:
                let product = results[ indexPath.row ]
                cell.populate( product )
                
                return cell
            default:
                let product = results[ indexPath.row ]
                cell.populate( product )
                
                return cell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int ) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath ) {
        print( indexPath )
        showProductInfo( indexPath.row )
    }
}

