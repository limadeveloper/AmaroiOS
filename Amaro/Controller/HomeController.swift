//
//  HomeController.swift
//  Amaro
//
//  Created by John Lima on 01/02/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController {
    
    // MARK: - Properties
    fileprivate let cellName = "cell"
    fileprivate var products = [Product]()
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        updateUI()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Actions
    fileprivate func updateUI() {
        
        view.backgroundColor = Color.dark
        
        collectionView?.backgroundColor = .clear
        collectionView?.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView?.reloadData()
    }
    
    fileprivate func getData() {
        guard let products = Product.getProducts() else { return }
        self.products = products
    }
}

extension HomeController {
    
    // MARK: - ColletionView DataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath) as! HomeCollectionViewCell
        
        cell.product = products[indexPath.item]
        cell.menuButton.isHidden = indexPath.row != 0
        
        return cell
    }
    
    // MARK: - ColletionView Delegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: Segue.details, sender: indexPath)
    }
}

extension HomeController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, !identifier.isEmpty {
            switch identifier {
            case Segue.details:
                guard let indexPath = sender as? IndexPath else { return }
                let controller = segue.destination as? DetailsController
                controller?.product = products[indexPath.item]
                break
            default:
                break
            }
        }else {
            let action = UIAlertAction(title: ButtonTitle.ok, style: .destructive, handler: nil)
            UIAlertController.createAlert(
                title: Titles.error,
                message: Messages.controllerNoFound,
                style: .alert,
                actions: [action],
                target: self
            )
        }
    }
}

