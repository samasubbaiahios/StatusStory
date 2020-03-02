//
//  ProfileStatusVC.swift
//  ProfileStatus
//
//  Created by Venkata Subbaiah Sama on 25/08/19.
//  Copyright © 2019 Venkata. All rights reserved.
//

import UIKit

class ProfileStatusVC: UIViewController {

    var profileVM: ProfileVM?
    var loadAvatarSerial: Int = 0
    @IBOutlet weak var nextAvatarButton: UIButton!{
        didSet {
            nextAvatarButton.addTarget(self, action: #selector(loadAvatarAction), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var progressView: CircularProgress!
    var tapCount = Int()
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        setupUIStyles()
        loadAvatarAction()
    }
    //This Helps to load Images in the Avatar
    @objc func loadAvatarAction() {
        DispatchQueue.main.async {
            self.profileImage.image = UIImage(named: "PlaceHolder")
        }
        loadAvatarSerial += 1
        if loadAvatarSerial > 5 {
            loadAvatarSerial = loadAvatarSerial - 5
        }
        profileVM?.fetchFile(for: loadAvatarSerial)
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Constants.kDownloadProgressNotification), object: nil)
    }
    //This notification lisnter helps us to perform progress animation
    @objc func methodOfReceivedNotification(notification: NSNotification){
        // Take Action on Notification
        if let info = notification.userInfo, let infoDescription = info["info"] as? Float {
            let progress = infoDescription
            progressView.progressColor = UIColor(appColor: UIColor.AppColors.green600)
            downloadProgressUpdated(for: progress)
        }
    }
}
extension ProfileStatusVC {
    //Progress bar animation
    func downloadProgressUpdated(for progress: Float) {
        DispatchQueue.main.async {
            self.progressView.setProgressWithAnimation(duration: 0.75, value: progress)
        }
    }
    //Adding UI styles
    func setupUIStyles() {
        profileImage.roundedImage()
        nextAvatarButton.setTitle("Load next avatar", for: .normal)
        nextAvatarButton.setTitleColor(UIColor.black, for: .normal)
        nextAvatarButton.layer.borderColor = UIColor(appColor: UIColor.AppColors.black).cgColor
        nextAvatarButton.layer.borderWidth = 2
        nextAvatarButton.layer.cornerRadius = 4
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name(Constants.kDownloadProgressNotification), object: nil)
    }
}
//Observes the Model changes in the ProfileVM and updates the View
@objc extension ProfileStatusVC: Configurable {
    typealias T = ProfileVM
    func bind(to model: ProfileVM) {
        self.profileVM = model
        self.profileVM?.observe(for: [self.profileVM!.files], with: { [weak self] (_) in
            DispatchQueue.main.async {
                self?.progressView.progressColor = UIColor.clear
                if let fileDoc = self?.profileVM?.files.value {
                    if fileDoc.downloadInitiated?.value == DocumentStatus.InProgress || fileDoc.downloadInitiated?.value == DocumentStatus.Started {
                        let progressValue = fileDoc.downloadStatus?.value
                        self?.progressView.progressColor = UIColor(appColor: UIColor.AppColors.green600)
                        self?.downloadProgressUpdated(for: progressValue ?? 0)
                    } else if fileDoc.downloadInitiated?.value == DocumentStatus.Finished || fileDoc.downloadInitiated?.value == DocumentStatus.Downloaded{
                        if let path = self?.profileVM?.files.value?.localPath {
                            self?.profileImage.load(url: path)
                            self?.downloadProgressUpdated(for: 0)
                        }
                    }
                }
            }
        })
    }
}
