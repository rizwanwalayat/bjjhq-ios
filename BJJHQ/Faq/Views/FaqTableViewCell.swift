//
//  FaqTableViewCell.swift
//  Waste2x
//
//  Created by HaiDer's Macbook Pro on 02/06/2021.
//  Copyright © 2021 Haider Awan. All rights reserved.
//

import UIKit

class FaqTableViewCell: UITableViewCell {

    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var expandArrow: UIImageView!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    var questionArray = ["What is BJJHQ?","When should I check BJJHQ?","What product is coming next?","What am I going to find on BJJHQ?","How did BJJHQ get here?","Can I talk to BJJHQ on the phone?","I missed the deal, can I still get it?","Why is there a limit of 1 quantity per order?","HQ Community Wall","Payments","Fraud Protection Policy"]
    var answerArray = ["The original Daily Deal site. We sell one product at a time. Limited quantity. Exceptional price.",
"""
We publish a new deal at 11 pm EST every day. Each featured product runs for 24 hours.
We often have limited quantities, so if it sells out before the 24-hour slot expires. . . you can check back in at 11 pm EST until the next one pops up.

You can sign up for email notifications, and you can turn on Notifications in this app - that way you’ll find out the new item at 11 pm EST sharp. In our app, you can set delayed reminders (e.g. deal notification 4 hours or 8 hours after it goes live, in case you’re working or sleeping at 11 pm EST)

""",
"""
Well, that’s a surprise, technically. But we do normally post a ”teaser” exclusively on our @BJJHQ Instagram channel. Follow us for a heads up on the upcoming featured product!

""",
"""
Some of our features are exclusive that the brand developed specifically to be sold strictly on BJJHQ. Sometimes our features are popular products, sold elsewhere at higher prices. Other times, we’ll feature a product that’s been sold out everywhere else and we’ve got the last remaining stock. And other times, our feature is a new up-and-coming product from a brand we’ve vetted and trust.
But EVERY time, the feature is at an exceptional price.
We’ve built great relationships with the premier brands in the BJJ world, ensuring we get quality, authentic gear that we can deliver to you at an unbeatable price.

""",
"""
We started with MMAHQ in 2009, and over time we’ve evolved into BJJHQ and Roll more. Serving up fresh cuts of Jiu Jitsu Gis, nogi gear, gear bags, apparel, soaps, accessories, and all manner of useful gear for grappling arts, submission wrestling, recovery after the gym, and life off the mats.

""",
"""
We’d love to chat, but we’re not by the phones so the best way to reach us is via email at cs@BJJHQ.com

""",
"""
When the deal ends or a size option sells out, that’s it. Our product rotation is growing regularly, so check back and you’re likely to see a comparable product within the week. And for more popular features, it’s bound to come back for a new feature - though we tend to wait a few months before repeating a particular item.

""",
"""
Each order is limited to a quantity of one. You can place multiple orders, but they may ship separately and will include their own shipping charge. We like the idea of as many people as possible to benefit from the deals, so if we allowed unlimited quantities per order, some scoundrels may buy up all the product for one reason or another.

""",
"""
Keep the comments clean, please! We reserve the right to delete comments and ban users if the posts are severely off-topic, vulgar, or unnecessarily confrontational. The wall is intended for questions and feedback about the product or brand.

""",
"""
We accept VISA, MasterCard, American Express, Discover, or PayPal.

""",
"""
Of course! For your protection orders are subject to BJJHQ's verification procedure. You may be asked to verify that you are the card owner, or that the order information is legitimate. This may include a request for a copy of your credit card (front and back), which can be transmitted by fax when necessary. Should your order require verification, you will be notified by email.

BJJHQ reserves the right to refuse an order when the address or credit card is not verifiable. If so, a refund will be issued via the same method you used to make your payment.

All prices are by default shown in USD.


"""
    ]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.expandArrow.image = UIImage(named: "Down-Arrow")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func expandCollapse() {
        self.bodyView.isHidden = !self.bodyView.isHidden
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
            self.layoutIfNeeded()}, completion: { finished in
            if self.expandArrow.image == UIImage(named: "Down-Arrow")
            {
                self.expandArrow.image = UIImage(named: "up-Arrow")
            }
            else
            {
                self.expandArrow.image = UIImage(named: "Down-Arrow")
            }
        })
    }
    func config(index:Int){
        
        self.questionLabel.text = questionArray[index]
        self.answerLabel.text = answerArray[index]
    }
}
