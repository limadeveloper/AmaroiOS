//
//  DetailsViewController.swift
//  Amaro
//
//  Created by John Lima on 01/02/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import UIKit
import AlamofireImage

class DetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    fileprivate let photoCell = "photoCell"
    fileprivate let detailsCell = "detailsCell"
    fileprivate var productImage: UIImage?
    
    var product: Product?
    
    struct Cell {
        struct Details {
            static let rowHeight1: CGFloat = 118
            static let rowHeight2: CGFloat = 156
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

extension DetailsViewController {
    
    // MARK: - TableView DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: photoCell, for: indexPath) as! PhotoTableViewCell
            cell.product = product
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: detailsCell, for: indexPath) as! DetailsTableViewCell
            cell.productImage = productImage
            cell.product = product
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
