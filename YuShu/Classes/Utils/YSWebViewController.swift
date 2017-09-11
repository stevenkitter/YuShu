//
//  YSWebViewController.swift
//  YuShu
//
//  Created by hsgene_xu on 2017/9/8.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit
import WebKit

class YSWebViewController: RootViewController {
    let webView = WKWebView(frame: CGRect.zero)
    let progressView = UIProgressView(frame: CGRect.zero)
    var url = ""
    var backItem: UIBarButtonItem! = nil
    var closeItem: UIBarButtonItem! = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupInit()
        setupRx()
    }
    func setupUI() {
        webView.navigationDelegate = self
        view.addSubview(webView)
        view.addSubview(progressView)
        progressView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.view).offset(64)
            make.height.equalTo(3)
        }
        webView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        let btn = UIButton(type: .custom).then{
            $0.setImage(UIImage(named: "naviBack"), for: .normal)
            $0.setTitle("返回", for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            $0.setTitleColor(UIColor.white, for: .normal)
            $0.frame = CGRect(x: 0, y: 0, width: 50, height: 40)
            $0.sizeToFit()
            $0.addTarget(self, action: #selector(backMethod), for: .touchUpInside)
        }
        
        backItem = UIBarButtonItem(customView: btn)
        
        closeItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(closeMethod))
    }
    
    func backMethod() {
        guard webView.canGoBack else {
            closeMethod()
            return
        }
        webView.goBack()
    }
    
    func closeMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupInit() {
        let request = URLRequest(url: URL(string: url)!)
        webView.load(request)
        
        
    }
    
    func setupRx() {
        webView.rx.observe(Double.self, "estimatedProgress").subscribe(onNext: { [unowned self] (progress) in
            self.progressView.progress = Float(progress ?? 0)
            self.progressView.isHidden = progress == 1
        }).addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

   

}

extension YSWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.title = webView.title
        navigationItem.leftBarButtonItems = webView.canGoBack ? [backItem,closeItem] : [backItem]
    }
}
