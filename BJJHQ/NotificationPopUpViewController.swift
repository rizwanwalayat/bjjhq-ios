//
//  NotificationPopUpViewController.swift
//  BJJHQ
//
//  Created by HaiDer's Macbook Pro on 16/02/2022.
//  Copyright © 2022 Shopify Inc. All rights reserved.
//

import UIKit

class NotificationPopUpViewController: BaseViewController {

    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    var selectedIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.popUpView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupDidappear()
    }
    //MARK: - Functions
    
    func setupDidappear() {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [],  animations: {
            
            self.popUpView.transform = .identity
        })
        
    }
    
    func hidePopup() {
        popUpView.alpha = 1
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: [], animations: {
            
            self.popUpView.alpha = 0
            self.popUpView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            
        }) { (success) in
            
            self.dismiss(animated: false, completion: nil)
            
        }
    }
    
    //MARK: - IBAction
    
    
    @IBAction func crossAction(_ sender: Any) {
        hidePopup()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        coordinator?.homePage()
    }
    @IBAction func yesAction(_ sender: Any) {
        
    }
}

extension NotificationPopUpViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.register(NotificationHoursCollectionViewCell.self, indexPath: indexPath)
        cell.config(index:indexPath.row)
        if selectedIndex == indexPath.row {
            cell.mainView.backgroundColor = UIColor(named: "marinda")
            cell.titleLbl.textColor = .white
        }
        else {
            cell.mainView.backgroundColor = .white
            cell.titleLbl.textColor = UIColor(named: "marinda")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width/6), height: 42)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        collectionView.reloadData()
    }
}
