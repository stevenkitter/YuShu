//
//  HomeViewController.swift
//  InternManager
//
//  Created by apple on 2017/8/25.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit
import Then
import SnapKit
import MJRefresh
import Moya
import RxSwift
import LLCycleScrollView
import ChameleonFramework
let cellIdentifier = "HomeTableViewCell"
let KAdViewH: CGFloat = 200
let KCollectionViewCellH: CGFloat = 60
let KCollectionViewH: CGFloat = KCollectionViewCellH*2 + 10 + 20
let KUpLabelH: CGFloat = 35
let KDownMargin: CGFloat = 0
class HomeViewController: RootViewController {
   
    var articles:[Article] = []
    var ads: [AD] = []
    let collecTitles = ["快速办卡","内部渠道","网贷工具",
                        "一键提款","网贷大全","消费分期",
                        "卡片进度","卡片激活"]
    
    let adCycleScrollView = LLCycleScrollView.llCycleScrollViewWithFrame(CGRect(x: 0, y: 0, width: KScreenWidth, height: KAdViewH)) { (index) in
            //点击事件
        }.then {
//            // 是否自动滚动
            $0.autoScroll = true
//
//            // 是否无限循环，此属性修改了就不存在轮播的意义了 😄
//            $0.infiniteLoop = true
//            
//            // 滚动间隔时间(默认为2秒)
            $0.autoScrollTimeInterval = 4.0
//
//            // 设置图片显示方式=UIImageView的ContentMode
//            $0.imageViewContentMode = .scaleToFill
//            
//            // 设置滚动方向（ vertical || horizontal ）
//            $0.scrollDirection = .horizontal
//            
            // 设置当前PageControl的样式 (.none, .system, .fill, .pill, .snake)
            $0.customPageControlStyle = .pill
            
            // 非.system的状态下，设置PageControl的tintColor
//            $0.customPageControlInActiveTintColor = UIColor.red
//            
//            // 设置.system系统的UIPageControl当前显示的颜色
//            $0.pageControlCurrentPageColor = UIColor.white
//            
//            // 非.system的状态下，设置PageControl的间距(默认为8.0)
//            $0.customPageControlIndicatorPadding = 8.0
//            
//            // 设置PageControl的位置 (.left, .right 默认为.center)
//            $0.pageControlPosition = .center
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        setupUI()
        setupRefresh()
        self.tableView.mj_header.beginRefreshing()
    }

    override func loadServerData() {
        super.loadServerData()
        //:MARK 加载内容
        NetworkManager.providerHomeApi
            .request(.getArticle(page: page))
            .mapArray(Article.self)
            .subscribe(onNext: { [unowned self] (models) in
                if self.page == 1 {
                    self.articles.removeAll()
                }
                self.articles.append(contentsOf: models)
                
                self.page += 1
                self.tableView.reloadData()
                self.tableView.mj_header.endRefreshing()
                if models.count < 10 {
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                }else{
                    self.tableView.mj_footer.endRefreshing()
                }
            }, onError: { (err) in
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.endRefreshing()

            })
            .addDisposableTo(disposeBag)
        
        if !self.tableView.mj_header.isRefreshing() {
            return
        }
        //:MARK 加载广告
        NetworkManager.providerHomeApi
            .request(.getAd(classid: 1))
            .mapArray(AD.self)
            .subscribe(onNext: { [unowned self] (models) in
                self.ads.removeAll()
                self.ads.append(contentsOf: models)
                var imageUrls: [String] = []
                var titles: [String] = []
                for item in self.ads {
                    imageUrls.append(item.file_path ?? "")
                    titles.append(item.ad_title ?? "")
                }
                self.adCycleScrollView.imagePaths = imageUrls
                self.adCycleScrollView.titles = titles
            }, onError: { (err) in
                    
            })
            .addDisposableTo(disposeBag)
//        imageURLPaths: [], titles: []
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension HomeViewController {
    func setupUI() {
        setupTableView()
    }
    
    func setupTableView() {
        self.tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        tableView.snp.makeConstraints { [unowned self] (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        setupTableViewHeader()
    }
    
    
    func setupTableViewHeader(){
        let containerH = KAdViewH + KUpLabelH + KCollectionViewH + KDownMargin
        let container = UIView(frame: CGRect(x: 0, y: 0, width: KScreenWidth, height: containerH))
        
        container.addSubview(self.adCycleScrollView)
        
        let labelContainer = UIView(frame: CGRect(x: 0, y: KAdViewH, width: KScreenWidth, height: KUpLabelH))
        labelContainer.backgroundColor = UIColor.groupTableViewBackground
        container.addSubview(labelContainer)
        
        let label = UILabel().then {
            $0.font = UIFont.systemFont(ofSize: 14)
            $0.frame = CGRect(x: 10, y: 0, width: KScreenWidth, height: KUpLabelH)
            $0.text = "特色功能"
        }
        labelContainer.addSubview(label)
        
        let colv = setupCollectionView()
        container.addSubview(colv)
        
        self.tableView.tableHeaderView = container
    }
    
    func setupCollectionView() ->UICollectionView{
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: KCollectionViewCellH * 2 + 40, height: KCollectionViewCellH)
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: KUpLabelH + KAdViewH, width: KScreenWidth, height: KCollectionViewH), collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = KTintColor
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeCollectionViewCell")
        return collectionView
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return KUpLabelH
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let labelContainer = UIView(frame: CGRect(x: 0, y: KAdViewH, width: KScreenWidth, height: KUpLabelH))
        labelContainer.backgroundColor = UIColor.groupTableViewBackground
        
        let label = UILabel().then {
            $0.font = UIFont.systemFont(ofSize: 14)
            $0.frame = CGRect(x: 10, y: 0, width: KScreenWidth, height: KUpLabelH)
            $0.text = "最新帖子"
        }
        labelContainer.addSubview(label)
        return labelContainer
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = articles[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! HomeTableViewCell
        cell.model = item
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = articles[indexPath.row]
        let vc = ArticleDetailViewController()
        let webStr = WebUrl + (article.article_id ?? "") + "&user_id=" + (UserManager.shareUserManager.curUserInfo?.id ?? "")
        vc.articleID = article.article_id ?? ""
        vc.webURLStr = webStr
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension HomeViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collecTitles.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collecTitles[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        cell.iconImageView.image = UIImage(named: item)
        cell.contentLabel.text = item
        cell.contentView.backgroundColor = UIColor.flatWatermelon;
        cell.contentView.corner()
        return cell
    }
}

extension HomeViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        hideNavigationBar()
    }
    override func viewWillAppear(_ animated: Bool) {
        hideNavigationBar()
    }
}
