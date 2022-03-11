//
//  NotificationViewController.swift
//  BJJHQ
//
//  Created by HaiDer's Macbook Pro on 17/02/2022.
//  Copyright © 2022 Shopify Inc. All rights reserved.
//

import UIKit

class ContactUsViewController: BaseViewController {
        
    @IBOutlet weak var contactTextView: UITextView!
    @IBOutlet weak var wordCount: UILabel!
    
        //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func backAction(_ sender: Any) {
        coordinator?.popVc()
    }
    
    @IBAction func sendAction(_ sender: Any) {
        if self.contactTextView.text != "" {
            self.view.activityStartAnimating()
            APIClient.shared.ContactUs(body: self.contactTextView.text ?? "") { responce, result, error, statusCode, messsage in
                self.view.activityStopAnimating()
                if error != nil {
                    let vc = OrderSuccesFullViewController(nibName: "OrderSuccesFullViewController", bundle: nil)
                    vc.isFromFeedBack = true
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: false, completion: nil)
                }
            }
        }
        else {
            showToast(message: "Please enter something to report")
        }

    }
   
}

extension ContactUsViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        wordCount.text = "\(updatedText.count)"
        return updatedText.count < 200
    }
}
