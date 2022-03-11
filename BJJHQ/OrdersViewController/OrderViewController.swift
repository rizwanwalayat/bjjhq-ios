//
//  OrderViewController.swift
//  BJJHQ
//
//  Created by MAC on 18/02/2022.
//  Copyright © 2022 Shopify Inc. All rights reserved.
//

import UIKit
import Buy
import Pay

class OrderViewController: BaseViewController {

    // MARK: - Outlets -
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var yourOrderLabel: UILabel!
    @IBOutlet weak var productDetial: UILabel!
    @IBOutlet weak var clearCart: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productDetailLabel: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var subTotalValueLabel: UILabel!
    @IBOutlet weak var shippingLabel: UILabel!
    @IBOutlet weak var shippingValueLabel: UILabel!
    @IBOutlet weak var vatLabel: UILabel!
    @IBOutlet weak var vatValueLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    // MARK: - Controller's Lifecycle -
    
    var orderDetail : Storefront.OrderEdge?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       setup()
    }

    fileprivate func setup()
    {
        if let url = orderDetail?.node.lineItems.edges[0].node.variant?.image?.originalSrc {
            self.setImage(imageView: self.productImageView, url: url)
        }
        
        self.productPrice.text = "\(orderDetail?.node.totalPriceV2.currencyCode.rawValue ?? "$") \(orderDetail?.node.totalPriceV2.amount ?? 00)"
        self.yourOrderLabel.text = "Order #\(orderDetail?.node.orderNumber ?? 00)"
        self.productDetailLabel.text = "\(orderDetail?.node.lineItems.edges[0].node.title ?? "")"
        self.subTotalValueLabel.text = "$ \(orderDetail?.node.subtotalPriceV2?.amount ?? 00)"
        self.shippingValueLabel.text = "$ \(orderDetail?.node.totalShippingPriceV2.amount ?? 00)"
        self.shippingValueLabel.text = "$ \(orderDetail?.node.totalTaxV2?.amount ?? 00)"
        self.totalPriceLabel.text = "$ \(orderDetail?.node.totalPriceV2.amount ?? 00)"
        
        self.setupLabelUnderlineText(clearCart, "Clear Cart")
    }
    
    // MARK: - Actions -

    @IBAction func backAction(_ sender: Any)
    {
        coordinator?.popVc()
    }
    
    @IBAction func checkOutAction(_ sender: Any)
    {
    }
    
    @IBAction func clearCartAction(_ sender: Any) {
        
        let vc = DeletePopUpViewController(nibName: "DeletePopUpViewController", bundle: nil)
        vc.coordinator = self.coordinator
        vc.isFromRemoveCart = true
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
        
    }
    
}
