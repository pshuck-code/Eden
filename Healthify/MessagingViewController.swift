//
//  MessagingViewController.swift
//  Healthify
//
//  Created by Parker Shuck on 6/2/20.
//  Copyright © 2020 Parker Shuck. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseDatabase
class MessagingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
 
    var tableView:UITableView!
    var posts = [Post]()
    var fetchingMore = false
    var endReached = false
    let leadingScreensForBatching: CGFloat = 3.0
    var cellHeights: [IndexPath: CGFloat] = [:]
    var lasUploadedPostId: String?
    var profileSelect = ProfileViewViewController()
    var indexNum = 0
    var postRef:DatabaseReference{
        return Database.database().reference().child("posts")
    }
    var oldPostQuery:DatabaseQuery{
        let lastPost = posts.last
        var queryRef:DatabaseQuery
        if lastPost != nil{
            let lastTimestamp = lastPost!.createdAt.timeIntervalSince1970 * 1000
            queryRef = postRef.queryOrdered(byChild: "timestamp").queryEnding(atValue: lastTimestamp)
        }//end of if
        else{
            queryRef = postRef.queryOrdered(byChild: "timestamp")
        }//end of else
        return queryRef
    }
    
    var newPostQuery:DatabaseQuery{
        var queryRef:DatabaseQuery
        let firstPost = posts.first
        if firstPost != nil{
            let firstTimestamp = firstPost!.createdAt.timeIntervalSince1970 * 1000
             queryRef = postRef.queryOrdered(byChild: "timestamp").queryStarting(atValue: firstTimestamp)
        }//end of if
        else{
            queryRef = postRef.queryOrdered(byChild: "timestamp")
        }//end of else
        return queryRef
    }
    
    var refreshControl:UIRefreshControl!
    var seeNewPostsButton:SeeNewPostsButton!
    var seeNewPostsButtonTopAnchor:NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: view.bounds, style: .plain)
        //tableView.backgroundColor = UIColor.systemGreen
        let cellNib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "postCell")
        tableView.register(LoadingCell.self, forCellReuseIdentifier: "loadingCell")
        view.addSubview(tableView)
        
        var layoutGuide: UILayoutGuide!
        
        layoutGuide = view.safeAreaLayoutGuide
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: layoutGuide.topAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.reloadData()
        
        refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        seeNewPostsButton = SeeNewPostsButton()
        view.addSubview(seeNewPostsButton)
        seeNewPostsButton.translatesAutoresizingMaskIntoConstraints = false
        seeNewPostsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        seeNewPostsButtonTopAnchor = seeNewPostsButton.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: -44)
        seeNewPostsButtonTopAnchor.isActive = true
        seeNewPostsButton.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
        seeNewPostsButton.widthAnchor.constraint(equalToConstant: seeNewPostsButton.button.bounds.width).isActive = true
        
        seeNewPostsButton.button.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        beginBatchFetch()
        
        
    }//end of viewDidLoad
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        listenForNewPost()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopListeningForNewPosts()
    }
    
    func toggleSeeNewPostsButton(hidden: Bool){
        if hidden {
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                self.seeNewPostsButtonTopAnchor.constant = -44
                self.view.layoutIfNeeded()
            }, completion: nil)
        } else{
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                self.seeNewPostsButtonTopAnchor.constant = 12
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }//end of func
    
    @objc func handleRefresh(){
        
        toggleSeeNewPostsButton(hidden: true)
        
        newPostQuery.queryLimited(toFirst: 20).observeSingleEvent(of: .value, with: { snapshot in
                   var tempPosts = [Post]()
                   
                   let firstPost = self.posts.first
                   for child in snapshot.children {
                       if let childSnapshot = child as? DataSnapshot,
                           let data = childSnapshot.value as? [String:Any],
                           let post = Post.parse(childSnapshot.key, data),
                           childSnapshot.key != firstPost?.id {
                           tempPosts.insert(post,at: 0)
                           }//end of if
                   }//end of for
                   
            self.posts.insert(contentsOf: tempPosts, at: 0)
            
            let newIndexPaths = (0..<tempPosts.count).map { i in
                return IndexPath(row: i, section: 0)
            }
            
            self.refreshControl.endRefreshing()
            self.tableView.insertRows(at: newIndexPaths, with: .top)
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)

            self.listenForNewPost()
             //  return completion(tempPosts)
               })
    }//end of func
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return posts.count
        case 1:
            return fetchingMore ? 1 : 0
        default:
            return 0
        }
    }//end of func
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
           let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell
                  cell.set(post: posts[indexPath.row])
                  return cell
       }//end of if
       else{
           let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath) as! LoadingCell
        cell.spinner.startAnimating()
                  return cell
       }//end of else
    }//end of func
    
    func fetchPosts(completion: @escaping(_ posts:[Post])->()){
       oldPostQuery.queryLimited(toLast: 20).observeSingleEvent(of: .value, with: { snapshot in
           var tempPosts = [Post]()
           
           let lastPost = self.posts.last
           for child in snapshot.children {
               if let childSnapshot = child as? DataSnapshot,
                   let data = childSnapshot.value as? [String:Any],
                   let post = Post.parse(childSnapshot.key, data),
                   childSnapshot.key != lastPost?.id {
                   
                   tempPosts.insert(post, at: 0)
               }
           }
           
           return completion(tempPosts)
       })
    }//end of func
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath] ?? 72.0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.size.height * leadingScreensForBatching {
            if !fetchingMore && !endReached {
                beginBatchFetch()
            }//end of nested if
        }//end of outer if
    }//end of func
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //profileSelect.set(post: posts[indexPath.row])
        //performSegue(withIdentifier: "profileSelect", sender: self)
        indexNum = indexPath.row
        profileSelect.userDefaults.set(posts[indexPath.row].author.username, forKey: "user")
        profileSelect.userDefaults.set(posts[indexPath.row].author.photoURL, forKey: "url")
        performSegue(withIdentifier: "profileSelect", sender:posts[indexPath.row])
    }
    
    func beginBatchFetch(){
        fetchingMore = true
        //fetch posts
        self.tableView.reloadSections(IndexSet(integer:1), with: .fade)
        fetchPosts{ newPosts in
            self.posts.append(contentsOf: newPosts)
            self.endReached = newPosts.count == 0
            self.fetchingMore = false
            UIView.performWithoutAnimation {
                self.tableView.reloadData()
                
                self.listenForNewPost()
            }
        }//end of fetchPosts call
    }//end of func
    
    var postListenerHandle:UInt?
    
    func listenForNewPost(){
        
        guard !fetchingMore else { return }
        
        //avoiding duplicate listeners
        stopListeningForNewPosts()
        
        postListenerHandle = newPostQuery.observe(.childAdded, with: { snapshot in
            if snapshot.key != self.posts.first?.id,
                let data = snapshot.value as? [String:Any],
                let post = Post.parse(snapshot.key, data){
                
                self.stopListeningForNewPosts()
                
                if snapshot.key == self.lasUploadedPostId{
                    self.handleRefresh()
                    self.lasUploadedPostId = nil
                }//end of if
                else{
                    self.toggleSeeNewPostsButton(hidden: false)
                }
            }//end of if
            
        })
    }//end of func
    
    func stopListeningForNewPosts(){
        if let handle = postListenerHandle {
            newPostQuery.removeObserver(withHandle: handle)
            postListenerHandle = nil
        }//end of if
    }//end of func
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let newPostNavBar = segue.destination as? UINavigationController,
        let newPostVC = newPostNavBar.viewControllers[0] as? CreatePostViewController {
            newPostVC.delegate = self
        }//end of if
        
        if segue.identifier == "profileSelect" {
            let des = segue.destination as! ProfileViewViewController
            des.post = sender as? Post
            //des.set(post: posts[indexNum])
        }
        
    }
    
}//end of class

extension MessagingViewController: NewPostVCDelegate {
    func didUploadPost(withID id: String) {
       // print(id)
        self.lasUploadedPostId = id
    }
}//end of extension
