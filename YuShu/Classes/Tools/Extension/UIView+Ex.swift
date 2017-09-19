//
//  UIView+Ex.swift
//  InternManager
//
//  Created by apple on 2017/8/25.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit
import Kingfisher
import ChameleonFramework
import SKPhotoBrowser
extension UIView {
    
    func corner() {
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
    }
    
    func cornerRadius(width: CGFloat) {
        self.layer.cornerRadius = width / 2
        self.layer.masksToBounds = true
    }
    
    func cornerRadiusBorder(width: CGFloat,border: CGFloat) {
        self.layer.cornerRadius = width / 2
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = border
    }
    
    func cornerRadiusBorder(width: CGFloat,border: CGFloat, selected: Bool) {
        self.layer.cornerRadius = width / 2
        self.layer.masksToBounds = true
        self.layer.borderColor = selected ? UIColor.flatGreen.cgColor : UIColor.lightGray.cgColor
        self.layer.borderWidth = border
    }
    
    func superVc()->UIViewController? {
        var n = self.next
        
        repeat{
            if (n is UIViewController) {
                
                return n as? UIViewController
            }
            n = n?.next
            
        }while n != nil
        
        return nil
    }
    
}

extension UIView {
    func moveX(x: CGFloat) {
        var frame = self.frame
        frame.origin.x += x
        self.frame = frame
    }
    
    func moveY(y: CGFloat) {
        var frame = self.frame
        frame.origin.y += y
        self.frame = frame
    }
    
    func `setwidth`(w: CGFloat) {
        var frame = self.frame
        frame.size.width = w
        self.frame = frame
    }
    func `setHeight`(h: CGFloat) {
        var frame = self.frame
        frame.size.height = h
        self.frame = frame
    }
}

extension UITableView{
    func register(str: String){
        self.register(UINib(nibName: str, bundle: nil), forCellReuseIdentifier: str)
    }
}
extension UICollectionView{
    func register(str: String){
        self.register(UINib(nibName: str, bundle: nil), forCellWithReuseIdentifier: str)
    }
}

//图片设置
extension UIImageView{
    func kfImage(_ str: String) {
        self.kf.setImage(with: URL(string: str), placeholder: KPlaceholderImage)
    }
    func kfImageVote(_ str: String){
        self.kf.setImage(with: URL(string: str), placeholder: KVotePlaceholderImage)
    }
    func kfImageNormal(_ str: String) {
        self.kf.setImage(with: URL(string: str), placeholder: KPlaceholderImage)
    }
}

extension UIView {
    func iconClick(superVc: RootViewController,tag: Int){
        self.tag = tag
        if self.gestureRecognizers?.count == nil {
            self.isUserInteractionEnabled = true
            let tapG = UITapGestureRecognizer(target: superVc, action: #selector(RootViewController.goPersonal(tapG:)))
            self.addGestureRecognizer(tapG)
        }
        
    }
}

// MARK: tableView 头部
extension UIView {
    static func tableViewHeaderView(height h: CGFloat,title t: String)-> UIView{
        let container = UIView(frame: CGRect(x: 0, y: 0, width: KScreenWidth, height: h))
        let label = UILabel(frame: CGRect(x: 10, y: 10, width: KScreenWidth - 20, height: h - 20))
        container.backgroundColor = UIColor.groupTableViewBackground
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = t
        container.addSubview(label)
        return container
    }
    
    static func tableViewHeaderViewTwoLabels(height h: CGFloat,title t: String, content co: String)-> UIView{
        let container = UIView(frame: CGRect(x: 0, y: 0, width: KScreenWidth, height: h))
        container.backgroundColor = UIColor.groupTableViewBackground
        
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = t
        
        let label2 = UILabel()
        label2.textColor = UIColor.darkGray
        label2.font = UIFont.systemFont(ofSize: 14)
        label2.text = co
        label2.textAlignment = .right
        
        container.addSubview(label)
        container.addSubview(label2)
        
        label.snp.makeConstraints { (make) in
            make.left.equalTo(container).offset(10)
            make.centerY.equalTo(container.snp.centerY)
            make.width.equalTo(150)
        }
        label2.snp.makeConstraints { (make) in
            make.right.equalTo(container).offset(-10)
            make.centerY.equalTo(container.snp.centerY)
            make.width.equalTo(100)
        }
        return container
    }
    
    
}

extension UIButton {
    //横的大按钮
    static func buttonWithTitle(normal ti: String, disable str: String)-> UIButton {
        let btn = UIButton(type: .custom)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        btn.setTitle(ti, for: .normal)
        btn.setTitle(str, for: .disabled)
        
        btn.setBackgroundImage(UIColor.flatGreen.createImage(), for: .normal)
        btn.setBackgroundImage(UIColor.groupTableViewBackground.createImage(), for: .disabled)
        
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitleColor(UIColor.darkGray, for: .disabled)
        
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        return btn
    }
    
    //圆按钮
    static func buttonWithImage(image: UIImage)-> UIButton {
        let btn = UIButton(type: .custom)
        btn.setImage(image, for: .normal)
        return btn
    }
    
    static func customButton(title: String)-> UIButton {
        let btn = UIButton(type: .custom)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(UIColor.flatGreen, for: .normal)
        btn.setTitleColor(UIColor.gray, for: .disabled)
        return btn
    }
}

// MARK: 截图
extension UIView {
    func createImageView()-> UIImageView {
        UIGraphicsBeginImageContextWithOptions(self.mj_size, false, UIScreen.main.scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let imageView = UIImageView(image: image)
        imageView.frame = self.frame
        return imageView
    }
}

extension UIView {
    func showImages(index: Int, imageUrls: [String]) {
        // 1. create URL Array
        var images = [SKPhoto]()
        for url in imageUrls{
            let photo = SKPhoto.photoWithImageURL(url)
            photo.shouldCachePhotoURLImage = true // you can use image cache by true(NSCache)
            images.append(photo)
        }
        
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(index)
        
        guard let superVc = self.superVc() else {
            return
        }
        superVc.present(browser, animated: true, completion: {})
    }
}

