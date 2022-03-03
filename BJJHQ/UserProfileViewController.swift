//
//  UserProfileViewController.swift
//  BJJHQ
//
//  Created by MAC on 21/02/2022.
//  Copyright © 2022 Shopify Inc. All rights reserved.
//

import UIKit

class UserProfileViewController: BaseViewController {

    // MARK: - Outlets
    @IBOutlet weak var profilePicHolderView: UIView!
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var nameHolderView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameHolderView: UIView!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailHolderView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var descriptionHolderView: UIView!
    @IBOutlet weak var desciptionTextView: UITextView!
    @IBOutlet weak var remainingWordsCounter: UILabel!
    
    
    //MARK: - Variables
    
    var viewModel: SignInViewModel?
    
    
    // MARK: - Controller's lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let numberOfChars = desciptionTextView.text.count // for Swift use count(newText)
        remainingWordsCounter.text = "\(numberOfChars)/200"
    }


    // MARK: - Actions

    @IBAction func changeProfileAction(_ sender: Any) {
        ImagePickerVC.shared.showImagePickerFromVC(fromVC: self)
    }
    
    @IBAction func saveChangeAction(_ sender: Any) {
    }
    
    @IBAction func backAction(_ sender: Any) {
        
        coordinator?.popVc()
    }
    
    @objc override func imageSelectedFromGalleryOrCamera(selectedImage:UIImage) {
        let image  = ["avatar":selectedImage]
        SignInViewModel().updateUserImage(image: image, { responce in
            print(responce)
        })
    }
}

extension UserProfileViewController : UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count // for Swift use count(newText)
        
        remainingWordsCounter.text = "\(numberOfChars)/200"
        return numberOfChars < 200
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer"
            textView.textColor = UIColor.lightGray
        }
    }
}
