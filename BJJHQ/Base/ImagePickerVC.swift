//
//  ImagePickerVC.swift
//  SaloonToday-Client
//
//  Created by Shoaib's Macbook Pro on 17/12/2018.
//  Copyright © 2018 Shoaib's Macbook Pro. All rights reserved.
//

import UIKit
import Photos

class ImagePickerVC : NSObject , UIImagePickerControllerDelegate , UINavigationControllerDelegate{

    //Declarations
    var sourceVC = BaseViewController()
    
    //Getting shared instance
    static let shared = ImagePickerVC()

    /*****************************************/
    //MARK: - Helper Methods
    /*****************************************/

    func showImagePickerFromVC(fromVC:BaseViewController)
    {
        sourceVC = fromVC
        let alertController = UIAlertController.init(title: "", message: "Select image From?", preferredStyle: .actionSheet)
        
        let galleryButton = UIAlertAction.init(title: "Gallery", style: .default) { (completed) in
           self.userClickedOnGallery()
        }
        let cameraButton = UIAlertAction.init(title: "Camera", style: .default) { (completed) in
            self.userClickedOnCamera()
        }
        let cancelButton = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(galleryButton)
        alertController.addAction(cameraButton)
        alertController.addAction(cancelButton)
        sourceVC.popoverPresentationController?.sourceView = sourceVC.view
        sourceVC.present(alertController, animated: true, completion: nil)
        
    }

    /*****************************************/

    func userClickedOnGallery()
    {
        let status = PHPhotoLibrary.authorizationStatus()
        
        //SH :: if authorization not found,request for new authorization.
        if status != .authorized
        {
            //SH :: Request new permission.
            PHPhotoLibrary.requestAuthorization { (finalStatus) in
                DispatchQueue.main.sync {
                    if finalStatus == .authorized
                    {
                        // SH :: app is authorized,lets proceed next.
                        self.proceedWithGallery()
                    }
                    else
                    {
                        Utility.showAlertController(self.sourceVC, "Please enable gallery access permission to continue")
                    }
                }
            }
        }
        else
        {
            // SH :: app is authorized,lets proceed next.
           self.proceedWithGallery()
        }
    }
    
    /*****************************************/
    
    func userClickedOnCamera()
    {
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized
        {
            // SH :: app is authorized,lets proceed next.
            self.proceedWithCamera()
        }
        else
        {
            //SH :: Request new permission.
            
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted
                {
                    DispatchQueue.main.sync {
                    // SH :: app is authorized,lets proceed next.
                    self.proceedWithCamera()
                    }
                }
                else
                {
                    DispatchQueue.main.sync {
                        Utility.showAlertController(self.sourceVC, "Please enable gallery access permission to continue")
                    }
                }
            })
        }
    }
    
    /*****************************************/
    
    func proceedWithGallery()
    {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        {
            let imagePicker = UIImagePickerController.init()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            sourceVC.present(imagePicker, animated: true, completion: nil)
        }
        else {
            Utility.showAlertController(self.sourceVC, "Please enable gallery access permission to continue")
        }
    }
    
    /*****************************************/
    
    func proceedWithCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            let imagePicker = UIImagePickerController.init()
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            sourceVC.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alertController = UIAlertController.init(title: "Camera not found", message: "Would you like to use gallery instead of camera", preferredStyle: .alert)
            let userGalleryButton = UIAlertAction.init(title: "Use Gallery", style: .default) { (completed) in
                self.proceedWithGallery()
            }
            let cancelButton = UIAlertAction.init(title: "Cancel", style: .default, handler: nil)
            alertController.addAction(userGalleryButton)
            alertController.addAction(cancelButton)
            self.sourceVC.present(alertController, animated: true, completion: nil)
            
        }
    }
    
    /*****************************************/
    //MARK: UIImagePickerController Delegate.
    /*****************************************/
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        var image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        image = image?.fixedOrientation()
    sourceVC.perform(#selector(BaseViewController.imageSelectedFromGalleryOrCamera(selectedImage:)), with: image, afterDelay: 0.3)
        picker.dismiss(animated: true , completion: nil)
    }
    
    /*****************************************/
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true , completion: nil)
    }
    
    /*****************************************/

    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0);
        image.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: newSize.width, height: newSize.height)))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}

/*****************************************/
//MARK: extension for UIImage for fixing its orientation.
/*****************************************/

extension UIImage {

    /*****************************************/
    
    func fixedOrientation() -> UIImage? {
        
        guard imageOrientation != UIImage.Orientation.up else {
            //This is default orientation, don't need to do anything
            return self.copy() as? UIImage
        }
        
        guard let cgImage = self.cgImage else {
            //CGImage is not available
            return nil
        }
        
        guard let colorSpace = cgImage.colorSpace, let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
            return nil //Not able to create CGContext
        }
        
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat.pi)
            break
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2.0)
            break
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat.pi / -2.0)
            break
        case .up, .upMirrored:
            break
        }
        
        //Flip image one more time if needed to, this is to prevent flipped image
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform.translatedBy(x: size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            break
        case .leftMirrored, .rightMirrored:
            transform.translatedBy(x: size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right:
            break
        }
        
        ctx.concatenate(transform)
        
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            break
        }
        
        guard let newCGImage = ctx.makeImage() else { return nil }
        return UIImage.init(cgImage: newCGImage, scale: 1, orientation: .up)
    }
    
    /**************************************************/

}

