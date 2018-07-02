//
//  HomeViewController.swift
//  KarthikTwitter
//
//  Created by Karthikeyan A. on 29/06/18.
//  Copyright © 2018 Karthikeyan A. All rights reserved.
//

import UIKit

@objc protocol TweetsCellDelegate: class {
    @objc optional func tweetsCell(_ cell: TweetsCell, didTapReply with: Tweet)
    @objc optional func tweetsCell(_ cell: TweetsCell, didTapRetwet with: Tweet, shouldRetweet: Bool)
    @objc optional func tweetsCell(_ cell: TweetsCell, didTapFavorite with: Tweet, isFavorite: Bool)
    @objc optional func tweetsCell(_ cell: TweetsCell, didTapProfileImage with: Tweet, tappedUser: User)
}

internal class TweetsCell: UITableViewCell {
    
    // MARK: Outlets
    @IBOutlet private var mediaImageView: UIImageView!
    @IBOutlet private var profileImageView: UIImageView!
    @IBOutlet private var usernameSmallLabel: UILabel!
    @IBOutlet private var usernameLabel: UILabel!
    @IBOutlet private var tweetTextLabel: UILabel!
    @IBOutlet private var timeStampLabel: UILabel!
    @IBOutlet private var retweetStackView: UIStackView!
    @IBOutlet private var retweeterNameLabel: UILabel!
    @IBOutlet private var favoratedButon: UIButton!
    @IBOutlet private var replyButon: UIButton!
    @IBOutlet private var retweetButon: UIButton!
    @IBOutlet private var optionsStackViewVerticalConstraint: NSLayoutConstraint!
    @IBOutlet private var topConstraint: NSLayoutConstraint!
    // MARK: Property Observers
    
    internal var tweet: Tweet! {
        didSet {
            setupCell()
        }
    }
    
    private var displayUser: User!
    
    internal var isFavorited: Bool = false {
        didSet {
            updateLikeButton()
        }
    }
    internal var isRetweeted: Bool = false {
        didSet {
            updateRetweetedButton()
        }
    }
    
    // MARK: Delegate Property
    
    internal var delegate: TweetsCellDelegate?
    // MARK: Lifecycles
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = 5
        mediaImageView.layer.cornerRadius = 5
    }
    
    private func setupCell() {
        tweetTextLabel.text = tweet.text
        timeStampLabel.text = tweet.createdAt!.timeAgo
        mediaImageView.image = nil
        topConstraint.constant = 8
        optionsStackViewVerticalConstraint.constant = 8
        setupButtons()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onProfileImageTap))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGestureRecognizer)
        
        if let mediaURL = tweet.mediaURL {
            mediaImageView.setImageWith(mediaURL)
            optionsStackViewVerticalConstraint.constant = 168
        }
        guard !tweet.isRetweetedTweet else {
            setupCellForRetweetedTweet()
            return
        }
        
        setupCellForNonRetweetedTweet()
        
        if let inReplyTo = tweet.inReplyToScreenName {
            retweeterNameLabel.text = "Replying to @\(inReplyTo)"
            retweetStackView.isHidden = false
            topConstraint.constant = 24
        }
    }
    
    private func setupButtons() {
        favoratedButon.setImage(#imageLiteral(resourceName: "HeartFilled"), for: .selected)
        favoratedButon.setImage(#imageLiteral(resourceName: "HeartUnfilled"), for: .normal)
        retweetButon.setImage(#imageLiteral(resourceName: "RetweetFilled"), for: .selected)
        retweetButon.setImage(#imageLiteral(resourceName: "RetweetUnfilled"), for: .normal)
        let retweeetTitleText = tweet.retweetCount > 0 ? " \(tweet.retweetCount)" : nil
        let favoriteTitleText = tweet.favoritesCount > 0 ? " \(tweet.favoritesCount)" : nil
        retweetButon.setTitle(retweeetTitleText, for: .normal)
        favoratedButon.setTitle(favoriteTitleText, for: .normal)
     
     
    }
    
   
    
    private func setupCellForRetweetedTweet() {
        profileImageView.setImageWith(tweet.retweetSourceUser!.profileURL!)
        usernameSmallLabel.text = "@\(tweet.retweetSourceUser!.screenName!)"
        usernameLabel.text = tweet.retweetSourceUser?.name
        displayUser = tweet.retweetSourceUser
        retweeterNameLabel.text = "\(tweet.user!.name!) retweeted"
        retweetStackView.isHidden = false
        topConstraint.constant = 24
    }
    
    private func setupCellForNonRetweetedTweet() {
        retweetStackView.isHidden = true
        profileImageView.setImageWith(tweet.user!.profileURL!)
        usernameSmallLabel.text = "@\(tweet.user!.screenName!)"
        usernameLabel.text = tweet.user?.name
        displayUser = tweet.user
    }
    
    // MARK: Target-action
    @IBAction private func onReplyTap(_ sender: UIButton) {
        delegate?.tweetsCell?(self, didTapReply: tweet)
    }
    
    @IBAction private func onRetweetTap(_ sender: UIButton) {
        delegate?.tweetsCell?(self, didTapRetwet: tweet, shouldRetweet: !isRetweeted)
    }
    
    @IBAction private func onFavoritesTap(_ sender: UIButton) {
        delegate?.tweetsCell?(self, didTapFavorite: tweet, isFavorite: !isFavorited)
    }
    
    @objc private func onProfileImageTap(_ sender: AnyObject?) {
        delegate?.tweetsCell?(self, didTapProfileImage: tweet, tappedUser: displayUser)
    }
    
    @IBAction func handleSideMenu(_ sender: UIBarButtonItem) {
        
    }
    
    
    // MARK: Helpers
    private func updateLikeButton() {
        favoratedButon.isSelected = isFavorited
    }
    
    private func updateRetweetedButton() {
        retweetButon.isSelected = isRetweeted
    }
}

class HomeViewController: UIViewController, SideMenuBarDelegate {
    // MARK: Outlets
    @IBOutlet fileprivate var tweetsTableview: UITableView!

    // MARK: Stored Properties
    fileprivate var refreshControl: UIRefreshControl!
    fileprivate var favTweets = [Int : Bool]()
    fileprivate var reTweets = [Int : Bool]()
    fileprivate var isGetMoreData = false
    fileprivate var profileView: ProfileView?
    internal var endpoint: GETTweetSource!
    internal var displayUser: User?
    let cellIdentifier = "tweetsCell"
    
    //Side More Item
    var sideMenubarLeft:SideMenu!
    
    //Data Store
    var arrBtnImageListLeft = [SideMenuImageList]()
   
    
    //Outlet
    @IBOutlet var controlSideMenuLeftBtn: UIControl!
    @IBOutlet var controlBG: UIControl!
    
    @IBOutlet weak var tweetSearch: UISearchBar!
    
    // MARK: Property Observers
    internal var showTweets = [Tweet]() {
        didSet {
            for (index, currtweet) in showTweets.enumerated() {
                favTweets[index] = currtweet.isFavorited
                reTweets[index] = currtweet.isRetweeted
            }
        }
    }
    
    internal var searchTweets = [Tweet]() {
        didSet {
            for (index, currtweet) in searchTweets.enumerated() {
                favTweets[index] = currtweet.isFavorited
                reTweets[index] = currtweet.isRetweeted
            }
        }
    }
    
    var searchActive : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews()
        
    }
   
    @IBAction func tappedOnLeftSideMenuBtn(_ sender: Any) {
        //Side menubar show
        if sideMenubarLeft.tag == 0 {
            sideMenubarLeft.show(isShowingLeftToRight: true)
            self.showBackgroundControl()
        }
            //Side menubar hide
        else {
            sideMenubarLeft.hide()
            self.hideBackgroundControl()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Setup Views
    fileprivate func setupSubViews() {
        setupRemainingNavItems()
        setupRefreshControl()
        tweetsTableview.rowHeight = UITableViewAutomaticDimension
        tweetsTableview.estimatedRowHeight = 100
        setupInfiniteScrolling()
        fetchData(shouldGetNextPage: false)
        //Left Side Menu bar Create
        setupLeftButtons()
    }
    
    fileprivate func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshCurrPage), for: .valueChanged)
        tweetsTableview.insertSubview(refreshControl, at: 0)
    }
    // MARK: - handle Refereshing
    fileprivate func endRefreshing() {
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }
    
    private func setupLeftButtons(){
        
        //arrBtnImageListLeft.append(SideMenuImageList(imgButton: #imageLiteral(resourceName: "User")))
        arrBtnImageListLeft.append(SideMenuImageList(imgButton: #imageLiteral(resourceName: "Sign Out")))
        var heightOfMenuBarLeft = (DeviceScale.SCALE_X * 20.0) //Top-Bottom Spacing
        heightOfMenuBarLeft += ((DeviceScale.SCALE_X * 16.66) * CGFloat((arrBtnImageListLeft.count - 1))) //Button between spacing
        heightOfMenuBarLeft += (CGFloat(arrBtnImageListLeft.count) * 50.0) //Button height spacing
        let originYOfMenuBarLeft = (self.view.frame.size.height / 2.0) - (heightOfMenuBarLeft / 2)
        
        sideMenubarLeft = SideMenu.init(frame: CGRect(x: (ScreenSize.WIDTH - (DeviceScale.SCALE_X * 84.0)),y: originYOfMenuBarLeft,width: (DeviceScale.SCALE_X * 84.0),height: heightOfMenuBarLeft)).createUI(view: self.view, arrBtnImageList: arrBtnImageListLeft) as! SideMenu
        sideMenubarLeft.delegate = self
       
        //Side Menu Button
        controlSideMenuLeftBtn.layer.cornerRadius = controlSideMenuLeftBtn.frame.size.height / 2.0
    }

}

// MARK: - Infinite Scrolling
extension HomeViewController: UIScrollViewDelegate {
    
    fileprivate func setupInfiniteScrolling() {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tweetsTableview.bounds.width, height: 50))
        footerView.backgroundColor = .white
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicatorView.startAnimating()
        activityIndicatorView.frame = footerView.bounds
        footerView.addSubview(activityIndicatorView)
        tweetsTableview.tableFooterView = footerView
    }
    
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !isGetMoreData else { return }
        if scrollView.contentOffset.y > tweetsTableview.contentSize.height - tweetsTableview.bounds.height && tweetsTableview.isDragging {
            fetchData(shouldGetNextPage: true)
        }
    }
}

// MARK: - getTimeLine Data
extension HomeViewController {
    fileprivate func fetchData(shouldGetNextPage: Bool) {
         isGetMoreData = shouldGetNextPage
        var screenName: String? = nil
        if let displayUser = displayUser {
            screenName = displayUser.screenName
        }
       
         Wrapper.shared.getTweets(from: endpoint, for: screenName, shouldGetNextPage: shouldGetNextPage) {
            tweets, error in
            if let tweets = tweets {
                if shouldGetNextPage {
                    for tweet in tweets {
                        self.showTweets.append(tweet)
                    }
                } else {
                    self.showTweets = tweets
                }
                self.tweetsTableview.reloadData()
            } else {
                //"TweetsViewController: no tweets!")
                print(error!.localizedDescription)
            }
            self.isGetMoreData = false
            self.endRefreshing()
         }
    }
    @objc fileprivate func refreshCurrPage() {
        fetchData(shouldGetNextPage: false)
        profileView?.user = displayUser
    }
    
    fileprivate func setupTableViewHeaderView() {
        guard displayUser != nil else { return }
        profileView = ProfileView(frame: CGRect(x: 0, y: 0, width: tweetsTableview.frame.width, height: 230))
        profileView?.user = displayUser
        tweetsTableview.tableHeaderView = profileView
    }
    
    func addTweetToTableView(tweet: Tweet) {
        self.showTweets.insert(tweet, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        self.tweetsTableview.insertRows(at: [indexPath], with: .automatic)
    }
    
    func handleUpdatedRetwet(indexPath: IndexPath, isRetweeted: Bool, cell: TweetsCell) {
        self.reTweets[indexPath.row] = isRetweeted
        self.showTweets[indexPath.row].isRetweeted = isRetweeted
        cell.isRetweeted = isRetweeted
        let retweetedCount = self.showTweets[indexPath.row].retweetCount
        let resetRetweetCount = isRetweeted ? retweetedCount + 1 : retweetedCount - 1
        self.showTweets[indexPath.row].setRetweetsCount(resetRetweetCount)
        cell.tweet = self.showTweets[indexPath.row]
    }
    
    func handleUpdatedFavorite(indexPath: IndexPath, isFavorite: Bool, cell: TweetsCell) {
        self.favTweets[indexPath.row] = isFavorite
        self.showTweets[indexPath.row].isFavorited = isFavorite
        cell.isFavorited = isFavorite
        let favoritesCount = self.showTweets[indexPath.row].favoritesCount
        let resetFavoritesCount = isFavorite ? favoritesCount + 1 : favoritesCount - 1
        self.showTweets[indexPath.row].setFavCount(resetFavoritesCount)
        cell.tweet = self.showTweets[indexPath.row]
    }
}

// MARK: - TableView

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! TweetsCell
        let tweet: Tweet
        if(searchActive){
               tweet = searchTweets[indexPath.row]
        } else {
                tweet = showTweets[indexPath.row]
        }
        cell.tweet = tweet
        cell.delegate = self
        cell.isFavorited = favTweets[indexPath.row] ?? false
        cell.isRetweeted = reTweets[indexPath.row] ?? false
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchActive ? searchTweets.count : showTweets.count
    }
}

// MARK: - TweetsCellDelegate
extension HomeViewController: TweetsCellDelegate {
    func tweetsCell(_ cell: TweetsCell, didTapReply with: Tweet) {
        let replyVC: ReplyTweetViewController  = UIStoryboard(storyboard: .main).instantiateViewController()
        replyVC.replyingToTweet = with
        replyVC.replyAction = {
            tweet in
            if let tweet = tweet {
                self.addTweetToTableView(tweet: tweet)
            }
        }
         self.appUtilityPresent(replyVC)
    }
    
    func tweetsCell(_ cell: TweetsCell, didTapProfileImage with: Tweet, tappedUser: User) {
        if let displayUser = displayUser {
            if tappedUser.screenName! == displayUser.screenName! {
                // same users so exit function
                return
            }
        }
//        let profileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tweetsVC") as! TweetsViewController
//        profileVC.displayUser = tappedUser
//        profileVC.endpoint = .userTimeLine
//        profileVC.title = tappedUser.name ?? ""
//        profileVC.navigationItem.leftBarButtonItem = nil
//        self.navigationController?.show(profileVC, sender: self)
    }
    
    func tweetsCell(_ cell: TweetsCell, didTapRetwet with: Tweet, shouldRetweet: Bool) {
        let indexPath = tweetsTableview.indexPath(for: cell)!
        
        guard shouldRetweet else {
             Wrapper.shared.retweet(id: with.id!, shouldUntweet: true) {
                success, error in
                 if success {
                    self.handleUpdatedRetwet(indexPath: indexPath, isRetweeted: false, cell: cell)
                } else {
                    print(error!.localizedDescription)
                }
            }
            return
        }
        
//        let retweetVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "retweetVC") as! RetweetViewController
//        retweetVC.tweet = with
//        retweetVC.retweetAction = {
//            isRetweeted in
//            self.handleUpdatedRetwet(indexPath: indexPath, isRetweeted: isRetweeted, cell: cell)
      //  }
        
      //  present(retweetVC, animated: false, completion: nil)
    }
    
    func tweetsCell(_ cell: TweetsCell, didTapFavorite with: Tweet, isFavorite: Bool) {
        let indexPath = tweetsTableview.indexPath(for: cell)!
         Wrapper.shared.changeLike(isLiked: isFavorite, id: with.id!) {
            success, error in
             if success {
                self.handleUpdatedFavorite(indexPath: indexPath, isFavorite: isFavorite, cell: cell)
            } else {
                print(error!.localizedDescription)
            }
        }
    }
}

extension HomeViewController  {
    //MARK: - MoreMenuBar Delegate
    func tappedOnEvent(sender: UIControl, sideMenubar: SideMenu) {
        if sideMenubar == sideMenubarLeft {
            print("Left Side Menu Button Tag : ",sender.tag)
             sideMenubarLeft.hide()
            if sender.tag == 1{
                 Wrapper.shared.logout()
                self.navigationController?.popToRootViewController(animated: true)
            }
           
        }
        
    }
    func moreMenuItemHide(sideMenubar: SideMenu) {
        
        self.hideBackgroundControl()
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
            
            if sideMenubar == self.sideMenubarLeft {
                self.controlSideMenuLeftBtn.alpha = 1.0
            }
            
        }) { (finished) in
            
        }
    }
    func moreMenuItemShow(sideMenubar: SideMenu) {
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
            
            if sideMenubar == self.sideMenubarLeft {
                self.controlSideMenuLeftBtn.alpha = 0.0
            }
           
        }) { (finished) in
            
        }
    }
    //MARK: - Tapped Event
    @IBAction func tappedOnBackground(_ sender: Any) {
        if controlBG.alpha >= 0.15 {
            //Side menubar show
            if sideMenubarLeft.tag == 1 {
                sideMenubarLeft.hide()
                self.hideBackgroundControl()
            }
        }
    }
    
 
    //MARK: - Hide Show Background View
    func hideBackgroundControl() {
        self.controlBG.isHidden = true
    }
    func showBackgroundControl() {
        self.controlBG.alpha = 0.1
        self.controlBG.isHidden = false
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            self.controlBG.alpha = 0.2
        }, completion: { (finished) in
            
        })
    }
}

extension HomeViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTweets = showTweets.filter { ($0.text?.containsIgnoringCase(find: searchText))! }
        searchActive = !searchTweets.isEmpty
        tweetsTableview.reloadData()
        
    }
}
