//
//  YSPersonViewController.swift
//  YuShu
//
//  Created by apple on 2017/9/8.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit

class YSPersonViewController: RootViewController {
    var contents: [Person] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "物业人事"
        setupUI()
        setupRefresh()
        loadServerData()
        // Do any additional setup after loading the view.
    }

    func setupUI() {
        // 1.设置布局
        let layout = YSMoreLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.dataSource = self
        // 2.创建UICollectionView
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.groupTableViewBackground
        collectionView.register(str: "YSPersonCollectionViewCell")
        collectionView.register(UINib(nibName: "YSMoreImageCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "YSMoreImageCollectionReusableView")
        view.addSubview(collectionView)
    }
    
    override func setupRefresh() {
        collectionView.mj_header = RefreshHeader(refreshingBlock: { [unowned self] in
            self.loadServerData()
        })
    }
    
    override func loadServerData() {
        
        NetworkManager.providerHomeApi.request(.getPersons()).mapArray(Person.self)
            .subscribe(onNext: { [unowned self] (list) in
                if list.count > 0 {
                    self.contents.removeAll()
                    self.contents.append(contentsOf: list)
                    self.collectionView.reloadData()
                }
                
                self.collectionView.mj_header.endRefreshing()
                }, onError: { [unowned self] (err) in
                    self.collectionView.mj_header.endRefreshing()
            }).addDisposableTo(disposeBag)
        
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}


extension YSPersonViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let person = contents[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YSPersonCollectionViewCell", for: indexPath) as! YSPersonCollectionViewCell
        cell.icon_imageView.kfImage(person.personnel_headpic ?? "")
        cell.nameLabel.text = person.personnel_name
        cell.dutyLabel.text = person.personnel_duty
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "YSMoreImageCollectionReusableView", for: indexPath)
        return headView
    }
}

extension YSPersonViewController : YSMoreLayoutDataSource {
    func waterfallLayout(_ layout: YSMoreLayout, indexPath: IndexPath) -> CGFloat {
        return CGFloat(cellWidth(10, 3) + 80)
    }
    
    func numberOfColsInWaterfallLayout(_ layout: YSMoreLayout) -> Int {
        return 3
    }
}

