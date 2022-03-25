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
        setup()
        self.desciptionTextView.text = ""
        self.emailTextField.isUserInteractionEnabled = false
        self.emailTextField.alpha = 0.5
        let numberOfChars = desciptionTextView.text.count // for Swift use count(newText)
        remainingWordsCounter.text = "\(numberOfChars)/200"
    }


    // MARK: - Actions

    @IBAction func changeProfileAction(_ sender: Any) {
        ImagePickerVC.shared.showImagePickerFromVC(fromVC: self)
    }
    
    @IBAction func saveChangeAction(_ sender: Any) {
        if self.nameTextField.text != "" && lastNameTextField.text != "" && emailTextField.text != "" {
            self.view.activityStartAnimating()
            SignInViewModel().updateCustomer(email: emailTextField.text!, userName: userNameTextField.text!, bio:desciptionTextView.text! , firstName:nameTextField.text! , lastName: lastNameTextField.text!, completion: { accessToken, error in
                self.view.activityStopAnimating()
                if accessToken != nil {
                    self.showToast(message: "Changes Saved Successfully")
                    self.setup()
                }
            })
        }
        else {
            self.showToast(message: "Input fields are empty")
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        
        coordinator?.popVc()
    }
    
    
    //MARK: - Functions
    func setup() {
        

        if let user = DataManager.shared.getUser() {
            self.emailTextField.text = user.user?.email
            self.nameTextField.text = user.user?.first_name
            self.lastNameTextField.text = user.user?.last_name
            self.desciptionTextView.text = user.user?.bio
            self.userNameTextField.text = user.user?.user_name
        }
        
        guard let image = UIImage(data: DataManager.shared.getProfilePic() ?? Data()) else {
            if let url = URL(string:  DataManager.shared.getUser()?.avatar ?? "") {
            self.setImage(imageView: self.profilePicImageView, url: url)
        }
            return
            
        }
        self.profilePicImageView.image =  image
    }
    @objc override func imageSelectedFromGalleryOrCamera(selectedImage:UIImage) {
        let image  = ["avatar":[selectedImage]]
        DataManager.shared.saveProfilePic(value: selectedImage.pngData())
        SignInViewModel().updateUserImage(image: image, { responce in
            guard let image = UIImage(data: DataManager.shared.getProfilePic() ?? Data()) else {return}
            self.profilePicImageView.image =  image
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
            textView.text = ""
            textView.textColor = UIColor.lightGray
        }
    }
}
