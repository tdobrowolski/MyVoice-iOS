//
//  SettingsViewController.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 27/01/2021.
//

import UIKit

class SettingsViewController: BaseViewController<SettingsViewModel> {
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Settings"
        self.view.backgroundColor = UIColor(named: "Blue (Light)")
        self.addNavigationBarButtons()
    }
    
    // MARK: Navigation Bar items methods
    
    private func addNavigationBarButtons() {
        let font = UIFont(name: "Poppins-Medium", size: 17) ?? UIFont.systemFont(ofSize: 17)
        let color = UIColor(named: "Orange (Main)") ?? .orange
        
        let rightItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDidTouch))
        rightItem.setTitleTextAttributes([NSAttributedString.Key.font: font,
                                          NSAttributedString.Key.foregroundColor: color], for: .normal)
        rightItem.setTitleTextAttributes([NSAttributedString.Key.font: font,
                                          NSAttributedString.Key.foregroundColor: color], for: .selected)
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc
    private func doneDidTouch() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Setup layout
    
    private func setupTableView() {
        
    }
}
