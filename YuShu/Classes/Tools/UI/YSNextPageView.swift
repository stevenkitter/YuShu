//
//  YSNextPageView.swift
//  YuShu
//
//  Created by hsgene_xu on 2017/9/19.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit
import SVProgressHUD
protocol YSNextPageViewDelegate {
    func forward()
    func nextPage()
    func go(page: Int)
}

class YSNextPageView: UIView {
    let forwardBtn = UIButton.customButton(title: "上一页")
    let midBtn = UIButton.customButton(title: "")
    let nextBtn = UIButton.customButton(title: "下一页")
    let textField = UITextField(frame: CGRect.zero)
    let goBtn = UIButton.customButton(title: "前往")
    
    var delegate: YSNextPageViewDelegate?
    
    var allPage = 0 {
        didSet{
            setupInit()
        }
    }
    var page = 0 {
        didSet{
            setupInit()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupClick()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        self.backgroundColor = UIColor.white
        
        self.addSubview(forwardBtn)
        self.addSubview(midBtn)
        self.addSubview(nextBtn)
        self.addSubview(textField)
        self.addSubview(goBtn)
        
        goBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-10)
            make.centerY.equalTo(self)
            make.left.equalTo(textField.snp.right)
        }
        
        textField.snp.makeConstraints { (make) in
            make.width.equalTo(40)
            make.left.equalTo(nextBtn.snp.right)
            make.centerY.equalTo(self)
            
        }
        nextBtn.snp.makeConstraints { (make) in
            make.left.equalTo(midBtn.snp.right)
            make.centerY.equalTo(self)
        }
        midBtn.snp.makeConstraints { (make) in
            make.left.equalTo(forwardBtn.snp.right)
            make.centerY.equalTo(self)
        }
        forwardBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
        }
        
        
    }
    
    func setupInit() {
        midBtn.setTitle("\(page)/\(allPage)", for: .normal)
        nextBtn.isEnabled = page < allPage
        forwardBtn.isEnabled = page > 1
    }
    
    func setupClick() {
        forwardBtn.addTarget(self, action: #selector(thisForward), for: .touchUpInside)
        nextBtn.addTarget(self, action: #selector(thisNext), for: .touchUpInside)
        goBtn.addTarget(self, action: #selector(thisGo(page:)), for: .touchUpInside)
    }
    
    func thisForward() {
        delegate?.forward()
    }
    func thisNext() {
        delegate?.nextPage()
    }
    func thisGo(page: Int) {
        guard let thisPage = Int(textField.text ?? ""),thisPage <= allPage else {
            SVProgressHUD.showError(withStatus: "输入有效的页数")
            return
        }
        delegate?.go(page: thisPage)
    }
}
