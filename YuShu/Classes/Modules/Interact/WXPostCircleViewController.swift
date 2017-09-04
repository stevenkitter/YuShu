//
//  WXPostCircleViewController.swift
//  InternManager
//
//  Created by apple on 2017/8/31.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit
import SVProgressHUD
import Lightbox
import ImagePicker
import NotificationCenter
let collectionCellRowNum: CGFloat = 4
let cellWidth = (KScreenWidth - 40) / collectionCellRowNum
class WXPostCircleViewController: RootViewController {

    @IBOutlet weak var textView: RSKPlaceholderTextView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    var images: [WXPostImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    func setupUI() {
        flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        collectionView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        collectionView.register(UINib(nibName: "WXCancelCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "WXCancelCollectionViewCell")
        collectionViewLayout()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发布", style: .plain, target: self, action: #selector(send))
    }
    
    func send() {
        if textView.text.realStr().characters.count == 0 {
            SVProgressHUD.showError(withStatus: "说点什么吧")
            return
        }
        guard self.showLogin() else{
            return
        }
        let userid = UserManager.shareUserManager.curUserInfo?.id ?? ""
        WXActivityIndicatorView.start()
        NetworkManager.providerCircleApi.request(.newCircle(content: textView.text, user_id: userid, images: self.images)).mapJSON().subscribe(onNext: { [unowned self] (res) in
            WXActivityIndicatorView.stop()
            guard let respon = res as? Dictionary<String, Any> else{
                return
            }
            guard let data = respon["data"] as? Dictionary<String, Any> else {
                return
            }
            SVProgressHUD.showSuccess(withStatus: data["msg"] as? String ?? "")
            self.navigationController?.popViewController(animated: true)
            NotificationCenter.default.post(name: NotifyCircleAdded, object: nil)
        }, onError: { (err) in
            WXActivityIndicatorView.stop()
        }).addDisposableTo(disposeBag)
    }
    
    func collectionViewLayout() {
        let row = self.images.count / Int(collectionCellRowNum)
        collectionViewHeight.constant = cellWidth * CGFloat((row + 1))
        collectionView.reloadData()
    }
    // MARK: - Navigation
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
extension WXPostCircleViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1 + images.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WXCancelCollectionViewCell", for: indexPath) as! WXCancelCollectionViewCell
        cell.imageView.image = indexPath.item == 0 ? UIImage(named: "btn_background_photograph_image") : images[indexPath.item - 1].image
        cell.deleteBtn.isHidden = indexPath.item == 0
        cell.closure = { [unowned self] in
            self.images.remove(at: indexPath.item - 1)
            self.collectionViewLayout()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
           
            
            let imagePickerController = ImagePickerController()
           
            let less = 15 - self.images.count;
            imagePickerController.imageLimit = less
            imagePickerController.delegate = self
            present(imagePickerController, animated: true, completion: nil)
        }else{
            guard self.images.count > 0 else { return }
            var showImages: [UIImage] = []
            for item in self.images {
                showImages.append(item.image!)
            }
            let lightboxImages = showImages.map {
                return LightboxImage(image: $0)
            }
            
            let lightbox = LightboxController(images: lightboxImages, startIndex: indexPath.item - 1)
            self.present(lightbox, animated: true, completion: nil)
        }
    }
    
    
}
extension WXPostCircleViewController:  ImagePickerDelegate {
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        guard images.count > 0 else { return }
        
        let lightboxImages = images.map {
            return LightboxImage(image: $0)
        }
        
        let lightbox = LightboxController(images: lightboxImages, startIndex: 0)
        imagePicker.present(lightbox, animated: true, completion: nil)
    }
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imagePicker.dismiss(animated: true, completion: nil)
        let dateDouble = Date().timeIntervalSince1970
        for index in 0..<images.count {
            let dou = dateDouble + Double(index)
            let name = "\(Int(dou)).png"
            let model = WXPostImage(image: images[index], imageName: name)
            self.images.append(model)
        }
        self.collectionViewLayout()
        
    }
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
