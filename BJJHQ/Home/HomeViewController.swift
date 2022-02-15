//
//  HomeViewController.swift
//  BJJHQ
//
//  Created by HaiDer's Macbook Pro on 14/02/2022.
//

import UIKit
import CHIPageControl

class HomeViewController: BaseViewController {

    
    // MARK: - Outlets -
    
    @IBOutlet weak var mainHolderView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var pagesIndicators: CHIBasePageControl!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
    
    // MARK: - Controller's lifeCycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }


    // MARK: - Custom Methods -
    
    fileprivate func setup()
    {
        // Collection View related
        collectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeCollectionViewCell")
        
        
        // pagesIndicators  related
        pagesIndicators.numberOfPages = 3
        pagesIndicators.radius = 2
        pagesIndicators.tintColor = UIColor.black.withAlphaComponent(0.3)
        pagesIndicators.currentPageTintColor = UIColor.black
        pagesIndicators.progress = 1
        
        // bottomView curve
        
    }
    
    
    // MARK: - Actions -
    
    @IBAction func menuAction(_ sender: Any) {
    }
    
    @IBAction func upButtonAction(_ sender: Any) {
    }
}

// MARK: - CollectionView Delegate  -

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = self.collectionView.bounds.height
        let size = CGSize(width: ScreenSize.SCREEN_WIDTH, height: height)
        return size
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let index = self.collectionView.contentOffset.x / self.collectionView.frame.size.width
        //pagesIndicators.progress = index
    }
}


// MARK: - CollectionView Data Source  -

extension HomeViewController: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        
        cell.productImageView.image = UIImage(named: "welcome")
        return cell
    }
    
    
}
