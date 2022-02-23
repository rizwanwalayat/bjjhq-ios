//
//  NotificationsViewController.swift
//  ContainerView
//
//  Created by HaiD3R AwaN on 13/04/2021.
//

import UIKit

class FaqViewController: BaseViewController {
    
    
//MARK: - IBOutlets
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Variables
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    @IBAction func backAction(_ sender: UIButton)
    {
        coordinator?.popVc()
    }

}


//MARK: - Extentions
extension FaqViewController : UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 5
            
        } else {
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.register(FaqTableViewCell.self, indexPath: indexPath)
            cell.config(question: "What is BJJHQ", answer: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer.", index: indexPath.row, section: indexPath.section)
            cell.selectionStyle = .none
            return cell
        }
        else
        {
            let cell = tableView.register(FaqTableViewCell.self, indexPath: indexPath)
            cell.config(question: "What is BJJHQ", answer: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer.", index: indexPath.row, section: indexPath.section)
            cell.selectionStyle = .none
            return cell
        }
       
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) as? FaqTableViewCell
        {
            cell.expandCollapse()
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if section == 0 {
//           return "About Easy Gifts"
//        }
//        else {
//            return "How to Order?"
//        }
//    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        let label = UILabel()
        label.frame = CGRect.init(x: 15, y: 25, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.font = UIFont(name: "Barlow-BoldItalic", size: 16)
        label.textColor = .black
        if section == 0
        {
            label.text = "About Easy Gifts"
        }
        else
        {
            label.text = "How to Order?"
        }
        headerView.addSubview(label)
        return headerView
    }
    

}


