//
//  ReturnPolicyTableViewCell.swift
//  BJJHQ
//
//  Created by HaiDer's Macbook Pro on 16/03/2022.
//  Copyright © 2022 Shopify Inc. All rights reserved.
//

import UIKit

class ReturnPolicyTableViewCell: UITableViewCell {
    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    var questionArray = ["When do I get my stuff?","Am I going to get stuck with a defective product?","What if I don’t *like* the product I received?","Shipping","Misc."]
    var answerArray = [
"""
We process orders every morning, so each Daily Deal processes the morning after the 24-hour slot ends.
We typically ship in 1 business day.
US orders are normally 2-7 business days transit, barring weather exceptions or carrier delays.
International orders may take longer (average 7-21 calendar days), as Customs/Border delays are beyond our control. While rare, any Customs charges placed by your country are not the responsibility of BJJHQ.
If your order is determined to be lost, we’ll help you sort it out.
You can check your order status via the app, but we’ll send an Order Confirmation email and then a Shipping / Tracking email.

""",
"""
Absolutely not! Our impressive prices are NOT the byproduct of damaged, defective, or imitation gear. Your purchase will be in tip-top shape and brand new. Mistakes can happen, so if you receive a product that has a scuff mark or we sent the wrong size, let us know and we’ll help you out 100%.
""",
    """
Nonsense! Is that even possible? I mean.. well, we don’t do returns or exchanges like that. We sell authentic gear for cheap. No returns/exchange staff for deals that have already ended (and we pass that reduced overhead on to y'all with strong discounts).
If you decide you don't like a particular product, due to the reduced HQ price, you're likely to recoup the price paid by re-selling on eBay, FB Marketplace, or in-person at the gym.
""",
    """
US Shipping is always $5 flat-rate, no matter what.
If we’re shipping outside the US, the rate will depend on the package type and destination. Here is a list of the countries we can ship to:
Australia
Brazil
Canada
Denmark
Finland
France
Germany
Ireland
Israel
Japan
Netherlands
New Zealand
Norway
Poland
Portugal
Singapore
South Korea
Spain
Sweden
United Kingdom

Package type is categorized as Small, Medium, or Large (respectively, examples are Tees, Hoodie, BJJ Gi).
Here is how we charge for each category:
Package Type - Small | Medium | Large
CANADA - $10 | $10 | $20
UK / BRAZIL / GERMANY / IRELAND - $15 | $20 | $40
ALL OTHERS (from the above list) - $15 | $20 | $45
""",
    """
We do our best to reduce the likelihood that BJJHQ shoppers will have added customs fees, import taxes, and other costs sometimes associated with international shipments. Orders will be shipped in a plain package. Although there are no guarantees, this helps ensure that our customers do not get surprised by additional costs levied by their country's postal service.

BJJHQ is not responsible for, nor can we offer, any specific advice regarding any customs related fees that you may incur. For specific information, please consult with your local government import office.

We charge Sales Tax only when required by law.

"""]
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func config(index:Int) {
        self.questionLbl.text = questionArray[index]
        self.descriptionLbl.text = answerArray[index]
        
    }
    
}
