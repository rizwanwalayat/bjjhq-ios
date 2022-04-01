//
//  BaseViewController.swift
//  Voice Memos
//
//  Created by HaiDer's Macbook Pro on 17/12/2021.
//

import UIKit
import SystemConfiguration
import NVActivityIndicatorView
import AVFoundation
import LinkPresentation
import SDWebImage

struct ScreenSize
{
    static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

open class BaseViewController: UIViewController {
    
    
    //MARK: - Coordinator
    
    var coordinator: MainCoordinator?
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @objc func imageSelectedFromGalleryOrCamera(selectedImage:UIImage){
        
    }
    
    func setImage(imageView:UIImageView,url:URL,placeHolder : String = "default")  {
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imageView.sd_imageIndicator?.startAnimatingIndicator()
        
        imageView.sd_setImage(with: url) { (img, err, cahce, URI) in
            imageView.sd_imageIndicator?.stopAnimatingIndicator()
            if err == nil {
                imageView.image = img
            } else {
                imageView.image = UIImage(named: placeHolder)
            }
        }
    }
    func setupLabelUnderlineText(_ label: UILabel, _ text : String)
    {
        let font = UIFont(name: "Barlow-BoldItalic", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .bold)
        let yourAttributes: [NSAttributedString.Key: Any] = [
              .font: font,
              .foregroundColor: label.textColor ?? UIColor(named: "borderColor"),
              .underlineStyle: NSUnderlineStyle.single.rawValue
          ]
        
        let attributeString = NSMutableAttributedString(
            string: text,
            attributes: yourAttributes
        )
        
        label.attributedText = attributeString
    }
    
    func setupButtonUnderlineText(_ button: UIButton, _ text : String,color:String,_ alpha : Double = 0.6)
    {
        let yourAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(hexString: color, alpha: alpha),
              .underlineStyle: NSUnderlineStyle.single.rawValue
          ]
        
        let attributeString = NSMutableAttributedString(
            string: text,
            attributes: yourAttributes
        )
        button.setAttributedTitle(attributeString, for: .normal)
    }
    
    
    func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    class func showAlertController (_ controller: UIViewController,_ message: String) {
        let easyVC = UIAlertController(title: "", message: message, preferredStyle: .alert)
        easyVC.modalPresentationStyle = .overCurrentContext
        easyVC.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        controller.present(easyVC, animated: true, completion: nil)
    }
    
    func privacyPolicy() {
        guard let url = URL(string : "https://www.haid3rawan.com/") else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    func termAndConditions() {
        guard let url = URL(string : "https://www.haid3rawan.com/") else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    func supportUrl() {
        guard let url = URL(string : "https://www.haid3rawan.com/") else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    
    func presentUIActivityControl(url:String) {
        
//        let text = Global.shared.shareString + "\n" + Global.shared.shareUrl
        let textToShare = [ url ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.postToFacebook ]
        activityViewController.completionWithItemsHandler = { activity, success, items, error in
            if success == true && activity != nil && error == nil {
                print(activity!,success)
                let activityName = activity!.rawValue.split(separator: ".")
                if activityName.contains("CopyToPasteboard")
                {
                    self.showToast(message: "Copied")
                }
                else {
                    self.showToast(message: "Shared")
                }
                
            }
            
        }
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    func showToast(message : String, _ position: Double = ScreenSize.SCREEN_HEIGHT, _ lines:Double = 40) {
        let toastLabel = UILabel(frame: CGRect(x:ScreenSize.SCREEN_WIDTH/6 , y:position-100, width: ScreenSize.SCREEN_WIDTH/1.5, height: lines))
        toastLabel.backgroundColor =  UIColor(named: "blue")
        toastLabel.textColor = .white
        
        var font = UIFont()
        font = UIFont.systemFont(ofSize: 14)
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        toastLabel.numberOfLines  =  3
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 3, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok".localized, style: .default, handler: nil))
        self.present(alert, animated: true, completion: {})
    }

    func decodeId(id : String) -> String
    {
        let decodedData = Data(base64Encoded: id)!
        guard let decodedString = String(data: decodedData, encoding: .utf8), let id = decodedString.split(separator: "/").last  else {
            return ""
        }
        return String(id)
    }

}


extension UITableView {
    
    func register<T: UITableViewCell>(_: T.Type, indexPath: IndexPath) -> T {
        self.register(UINib(nibName: String(describing: T.self), bundle: .main), forCellReuseIdentifier: String(describing: T.self))
        let cell = self.dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as! T
        return cell
    }
}
extension NSLayoutConstraint {
    /**
     Change multiplier constraint
     
     - parameter multiplier: CGFloat
     - returns: NSLayoutConstraint
     */
    func setMultiplier(multiplier:CGFloat) -> NSLayoutConstraint {
        
        NSLayoutConstraint.deactivate([self])
        
        let newConstraint = NSLayoutConstraint(
            item: firstItem as Any,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)
        
        newConstraint.priority = priority
        newConstraint.shouldBeArchived = self.shouldBeArchived
        newConstraint.identifier = self.identifier
        
        NSLayoutConstraint.activate([newConstraint])
        return newConstraint
    }
}

extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSRange(location: 0, length: self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    var containsWhitespace : Bool {
            return(self.rangeOfCharacter(from: .whitespacesAndNewlines) != nil)
        }
}

extension Date {
     
    public func addMinute(_ minute: Int) -> Date? {
        var comps = DateComponents()
        comps.minute = minute
        let calendar = Calendar.current
        let result = calendar.date(byAdding: comps, to: self)
        return result ?? nil
    }

 }
//MARK: - For image Conversion
class ImageConverter {

    func base64ToImage(_ base64String: String) -> UIImage? {
        guard let imageData = Data(base64Encoded: base64String) else { return nil }
        return UIImage(data: imageData)
    }

    func imageToBase64(_ image: UIImage) -> String? {
        return image.jpegData(compressionQuality: 1)?.base64EncodedString()
    }

}
public class Reachability {

    class func isConnectedToNetwork() -> Bool {

        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)

        return ret

    }
}

extension UICollectionView {

    /**
     Rotate a view by specified degrees

     - parameter angle: angle in degrees
     */
    func rotate(angle: CGFloat) {
        let radians = angle / 180.0 * CGFloat.pi
        let rotation = self.transform.rotated(by: radians);
        self.transform = rotation
    }

}
extension UICollectionView {
    func register<T: UICollectionViewCell>(_: T.Type, indexPath: IndexPath) -> T {
        self.register(UINib(nibName: String(describing: T.self), bundle: Bundle.main), forCellWithReuseIdentifier: String(describing: T.self))
        let cell = self.dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as! T
        return cell
    }
}

extension UICollectionView {
    var visibleCurrentCellIndexPath: IndexPath? {
        for cell in self.visibleCells {
            let indexPath = self.indexPath(for: cell)
            return indexPath
        }
        
        return nil
    }
}

extension Date {
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = NSLocale(localeIdentifier: "UTC") as Locale
        return formatter
    }()
    var formatted: String {
        return Date.formatter.string(from: self)
    }
    static let formatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        formatter.locale = NSLocale(localeIdentifier: "UTC") as Locale
        return formatter
    }()
    var formatted2: String {
        return Date.formatter2.string(from: self)
    }
    
    func dateToString(_ stringFormatter : String) -> String
    {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = formatter.string(from: self)
        let date = formatter.date(from: dateString)
        formatter.dateFormat = stringFormatter
        let returnString = formatter.string(from: date ?? self)

        return returnString
    }
    
    func timeCalculation( isShowTime : Bool) -> String?
    {
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        
        let now = Date()
        
        let calendar = Calendar.current
        let components = calendar.dateComponents(
            [.year, .month, .weekOfMonth, .day, .hour, .minute, .second],
            from: self,
            to: now)
        
        
        /// for years
        
        if let year = components.year {
            
            if year > 0 && year < 2
            {
                return "\(year)" + " year)"
            }
            else if year > 1
            {
                return "\(year)" + " years"
            }
        }
            
        
        /// for months
        
        if let month = components.month {
            
            if month > 0 && month < 2
            {
                return "\(month)" + " month"
            }
            else if month > 1
            {
                return "\(month)" + " months"
            }
        }
        
        
        /// for weeks
        
        if let week = components.weekOfMonth {
            
            if week > 0 && week < 2
            {
                return "\(week)" + " week"
            }
            else if week > 1
            {
                return "\(week)" + " weeks"
            }
        }
        
        
        /// for day
        
        if let day = components.day {
            
            if day > 0 && day < 2
            {
                return "\(day)" + " day"
            }
            else if day > 1
            {
                return "\(day)" + " days"
            }
        }
            
        
        if isShowTime
        {
            
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "h:mm a"
            formatter.amSymbol = "AM"
            formatter.pmSymbol = "PM"

            let dateString = formatter.string(from: Date())
            return dateString
        }
        
        /// for hours
        
        if let hour = components.hour {
            
            if hour > 0 && hour < 2
            {
                return "\(hour)" + " hour"
            }
            else if hour > 1
            {
                return "\(hour)" + " hours"
            }
        }
        
        
        /// for mins
        
        if let mints = components.minute {
            if mints == 0 {
                return "just now"
            }
            else {
                if mints > 0 && mints < 2
                {
                    return "\(mints)" + " mint"
                }
                else if mints > 1
                {
                    return "\(mints)" + " mints"
                }
            }

        }

            
        return ""
    }
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    func stringToDate(_ dateFormatter : String) -> Date?
    {
        let formatter = DateFormatter()
        
        formatter.dateFormat = dateFormatter//"MMM dd, yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        let date = formatter.date(from: self)
        
        return date
    }
}

extension Array where Element: Equatable {
    @discardableResult
    public mutating func replace(_ element: Element, with new: Element) -> Bool {
        if let f = self.firstIndex(where: { $0 == element}) {
            self[f] = new
            return true
        }
        return false
    }
}

extension String {
func localized(lang:String) ->String {

    let path = Bundle.main.path(forResource: lang, ofType: "lproj")
    let bundle = Bundle(path: path!)

    return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
}}

extension UIColor {
    
    convenience init(hexString:String, alpha:CGFloat = 1.0) {
        var cString:String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        var rgbValue:UInt32 = 10066329 //color #999999 if string has wrong format
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) == 6) {
            Scanner(string: cString).scanHexInt32(&rgbValue)
        }
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}
