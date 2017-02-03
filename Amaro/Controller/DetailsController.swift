//
//  DetailsController.swift
//  Amaro
//
//  Created by John Lima on 01/02/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import UIKit
import AlamofireImage

protocol DetailsControllerDelegate {
    func detailsControllerGetCheckoutData() -> [Checkout]?
}

class DetailsController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    fileprivate let photoCell = "photoCell"
    fileprivate let detailsCell = "detailsCell"
    fileprivate var productImage: UIImage?
    
    var product: Product?
    var delegate: DetailsControllerDelegate?
    
    struct Cell {
        struct Details {
            static let rowHeight1: CGFloat = 118
            static let rowHeight2: CGFloat = 179
        }
        struct Photo {
            static var rowHeight: CGFloat = keyWindow.frame.size.height - Details.rowHeight1
        }
    }
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        updateUI()
    }
    
    // MARK: - Actions
    @IBAction fileprivate func dismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction fileprivate func checkout() {
        
        let storyboard = UIStoryboard(name: UI.StoryboardName.main, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: UI.ControllerIdentifier.checkout) as? CheckoutController
        
        let checkouts = delegate?.detailsControllerGetCheckoutData()
        controller?.checkouts = checkouts
        
        if let controller = controller {
            present(controller, animated: true, completion: nil)
        }
    }
    
    fileprivate func updateUI() {
        
        let background = UIView(frame: .zero)
        tableView.tableFooterView = background
        tableView.backgroundColor = Color.dark
        tableView.reloadData()
    }
    
    fileprivate func getData() {
    
        guard let string = product?.image, let url = URL(string: string) else { return }
        
        do {
            let data = try Data(contentsOf: url)
            self.productImage = UIImage.af_threadSafeImage(with: data)
        }catch {
            print(error.localizedDescription)
        }
    }
}

extension DetailsController {
    
    // MARK: - TableView DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0: // Photos
            let cell = tableView.dequeueReusableCell(withIdentifier: photoCell, for: indexPath) as! PhotoTableViewCell
            cell.product = product
            return cell
        case 1: // Details
            let cell = tableView.dequeueReusableCell(withIdentifier: detailsCell, for: indexPath) as! DetailsTableViewCell
            cell.productImage = productImage
            cell.product = product
            cell.originPrice = product?.price
            cell.originPromoPrice = product?.pricePromo
            cell.detailsController = self
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: return Cell.Photo.rowHeight
        case 1: return Cell.Details.rowHeight2
        default:
            return 0
        }
    }
}
