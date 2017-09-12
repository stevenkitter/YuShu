//
//  YSVoteDetailViewController.swift
//  YuShu
//
//  Created by hsgene_xu on 2017/9/12.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit
import SVProgressHUD
class YSVoteDetailViewController: RootViewController {
    var voteId = ""
    var voteDetail: VoteDetail? = nil {
        didSet{
            setupInit()
        }
    }
    
    let header = YSVoteDetailHeader.default()!
    let headContainer = UIView()
    
    let footContainer = UIView()
    let footBtn = UIButton.buttonWithTitle(normal: "投票", disable: "不可用")
    
    fileprivate var selectedVote_option_id = "" {
        didSet{
            if selectedVote_option_id.characters.count > 0 {
                self.footBtn.isEnabled = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "投票详情"
        setupUI()
        setupRefresh()
        loadServerData()
    }
    
    func setupUI(){
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(self.tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(0, 0, 50, 0))
        }
        tableView.register(str: "YSVoteOptionTableViewCell")
        tableView.backgroundColor = UIColor.groupTableViewBackground
        
        
        headContainer.addSubview(header)
        header.snp.makeConstraints { (make) in
            make.edges.equalTo(headContainer).inset(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        headContainer.frame = CGRect(x: 0, y: 0, width: KScreenWidth, height: 70)
        tableView.tableHeaderView = headContainer
        
        footContainer.addSubview(footBtn)
        footBtn.snp.makeConstraints { (make) in
            make.edges.equalTo(footContainer).inset(UIEdgeInsetsMake(5, 10, 5, 10))
        }
        view.addSubview(footContainer)
        
        footContainer.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
            make.height.equalTo(50)
        }
        
        footBtn.addTarget(self, action: #selector(vote), for: .touchUpInside)
    }
    override func setupRefresh() {
        tableView.mj_header = RefreshHeader(refreshingBlock: { [unowned self] in
            self.loadServerData()
        })
    }
    override func loadServerData() {
        super.loadServerData()
        guard let userId = UserManager.shareUserManager.curUserInfo?.user_id else{return}
        NetworkManager.providerHomeApi.request(.getVoteInfo(vote_id: voteId, user_id: userId)).mapObject(VoteDetail.self).subscribe(onNext: { (info) in
            self.voteDetail = info
            self.tableView.mj_header.endRefreshing()
        }, onError: { (err) in
            self.tableView.mj_header.endRefreshing()
        }).addDisposableTo(disposeBag)
    
    }
    func setupInit() {
        header.vote = voteDetail
        
        footBtn.isEnabled = ((voteDetail?.vote_option_id ?? "").characters.count == 0 && (voteDetail?.vote_status ?? "") == "1" && selectedVote_option_id.characters.count > 0)
        
        let h = (voteDetail?.vote_desc ?? "").strRectMaxH(KScreenWidth - 40, font: UIFont.systemFont(ofSize: 14))
        headContainer.frame = CGRect(x: 0, y: 0, width: KScreenWidth, height: 70 + h)
        
        tableView.tableHeaderView = headContainer
        self.tableView.reloadData()
    }
    // MARK: 投票动作
    func vote() {
        guard let userId = UserManager.shareUserManager.curUserInfo?.user_id else{return}
        guard selectedVote_option_id.characters.count > 0 else {return}
        WXActivityIndicatorView.start()
        NetworkManager.providerHomeApi.request(.doVote(user_id: userId, vote_id: voteId, vote_option_id: selectedVote_option_id)).mapJSON()
        .subscribe(onNext: { (res) in
            WXActivityIndicatorView.stop()
            guard let respon = res as? Dictionary<String, Any> else{
                return
            }
            guard let data = respon["data"] as? Dictionary<String, Any> else {
                return
            }
            let msg = data["msg"] as? String
            let code = data["code"] as? Int
            if code == 1 {
                SVProgressHUD.showSuccess(withStatus: msg ?? "投票成功")
                self.loadServerData()
                
            }else{
                SVProgressHUD.showError(withStatus: msg ?? "投票失败")
            }
        }, onError: { (err) in
            WXActivityIndicatorView.stop()
        }).addDisposableTo(disposeBag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    
   

}
extension YSVoteDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return voteDetail?.vote_option.count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let container = UIView.tableViewHeaderViewTwoLabels(height: 40, title: "单选", content: "总投票数 \((voteDetail?.totalcount ?? "0"))")
        return container
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let container = UIView.tableViewHeaderView(height: 40, title: "截止日期 \((voteDetail?.vote_endtime ?? "").timeMintStr())")
        return container
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let option = voteDetail?.vote_option[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "YSVoteOptionTableViewCell", for: indexPath) as! YSVoteOptionTableViewCell
        cell.selectButton.isSelected = (option?.vote_option_id ?? "") == (voteDetail?.vote_option_id ?? "")
        cell.contentLabel.text = option?.vote_option_desc
        cell.ys_detailLabel.text = "投票数 \(option?.count ?? "0")"
        cell.canEdit = ((voteDetail?.vote_option_id ?? "").characters.count == 0 && (voteDetail?.vote_status ?? "") == "1")
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! YSVoteOptionTableViewCell
        guard cell.canEdit else {return}
        let option = voteDetail?.vote_option[indexPath.row]
        selectedVote_option_id = option?.vote_option_id ?? ""
    }
}
