//
//  SettingsLauncher.swift
//  LBTA-YouTube
//
//  Created by kelvinfok on 18/4/17.
//  Copyright © 2017 kelvinfok. All rights reserved.
//

import UIKit

class Setting: NSObject {
    
    let name: SettingName
    let imageName: String
    
    init(name: SettingName, imageName: String) {
        self.name = name
        self.imageName = imageName
    }
}

enum SettingName: String {
    case Cancel = "Cancel"
    case Settings = "Settings"
    case TermsPrivacy = "Terms & privacy"
    case SendFeedback = "Send Feedback"
    case Help = "Help"
    case SwitchAccount = "Switch Account"
}


class SettingsLauncher: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let cellHeight = 50
    var homeController: HomeController?
    
    let settings: [Setting] = {
        
        let setting = Setting(name: .Settings, imageName: "settings")
        let privacySetting = Setting(name: .TermsPrivacy, imageName: "privacy")
        let feedbackSetting = Setting(name: .SendFeedback, imageName: "feedback")
        let helpSetting = Setting(name: .Help, imageName: "help")
        let switchSetting = Setting(name: .SwitchAccount, imageName: "switch_account")
        let cancelSetting = Setting(name: .Cancel, imageName: "cancel")
        return [setting, privacySetting, feedbackSetting, helpSetting, switchSetting, cancelSetting]
    }()
    
    override init() {
        super.init()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SettingCell.self, forCellWithReuseIdentifier: "CellId")
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let setting = self.settings[indexPath.item]
        handleDismiss(setting: setting)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionViewWidth = Int(collectionView.frame.width)
        let collectionViewHeight = cellHeight
        let size = CGSize(width: collectionViewWidth, height: collectionViewHeight)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellId", for: indexPath) as! SettingCell
        
        let setting = settings[indexPath.item]
        cell.setting = setting
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    let blackView = UIView()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        return cv
    }()
    
    func showSettings() {
        
        if let window = UIApplication.shared.keyWindow {
            
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            
            window.addSubview(blackView)
            window.addSubview(collectionView)
            let windowsWidth = Int(window.frame.width)
            
            let collectionViewHeight = settings.count * cellHeight
            let y = Int(window.frame.height) - Int(collectionViewHeight)
            let windowsHeight = Int(window.frame.height)
            
            collectionView.frame = CGRect(x: 0, y: windowsHeight, width: windowsWidth, height: collectionViewHeight)
            
            blackView.frame = window.frame
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.collectionView.frame = CGRect(x: 0, y: y, width: Int(self.collectionView.frame.width), height: Int(self.collectionView.frame.height))
            }, completion: nil)
        }
    }
    
    func handleDismiss(setting: Setting) {
        UIView.animate(withDuration: 0.5, animations: {
            UIView.animate(withDuration: 0.5) {
                self.blackView.alpha = 0
                if let window = UIApplication.shared.keyWindow {
                    let windowHeight = window.frame.height
                    let collectionViewWidth = self.collectionView.frame.width
                    let collectionViewHeight = self.collectionView.frame.height
                    self.collectionView.frame = CGRect(x: 0, y: Int(windowHeight), width: Int(collectionViewWidth), height: Int(collectionViewHeight))
                }
            }
        }) { (action) in
            if setting.name != .Cancel {
                self.homeController?.showControllerForSetting(setting: setting)
            }
        }
    }
}
