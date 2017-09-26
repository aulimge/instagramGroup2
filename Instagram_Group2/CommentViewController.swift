//
//  CommentViewController.swift
//  Blocstagram
//
//  Created by ddenis on 1/20/17.
//  Copyright © 2017 ddApps. All rights reserved.
//

import UIKit
import Firebase



class CommentViewController: UIViewController {

    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var constraintToBottom: NSLayoutConstraint!
    
    var postID: String!
    var comments = [Comment]()
    var users = [Contact]()
    var ref: DatabaseReference!
    var posts : [Post] = []
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Comments"
        
        // for performance set an estimated row height
        tableView.estimatedRowHeight = 70
        // but also request to dynamically adjust to content using AutoLayout
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.dataSource = self

        handleTextField()
        prepareForNewComment()
        loadComments()
        
        // Set Keyboard Observers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardDidShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }

    
    // MARK: - Keyboard Notification Response Methods
    
    func keyboardWillShow(_ notification: NSNotification) {
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        UIView.animate(withDuration: 0.3) {
            self.constraintToBottom.constant = keyboardFrame!.height
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardWillHide(_ notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.constraintToBottom.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    // MARK: - Firebase Save Operation
    
    @IBAction func send(_ sender: Any) {
        let commentsReference = Comment()
        let newCommentID = commentsReference.childByAutoId().key
        
        let newCommentsReference = commentsReference.child(newCommentID)
        guard let currentUser = API.User.CURRENT_USER else { return }
        let currentUserID = currentUser.uid
        
        newCommentsReference.setValue(["uid": currentUserID, "commentText": commentTextField.text!]) { (error, reference) in
            if error != nil {
                ProgressHUD.showError("Photo Save Error: \(error?.localizedDescription)")
                return
            }
            
            let postCommentRef = API.PostComment.REF_POST_COMMENTS.child(self.postID).child(newCommentID)
            postCommentRef.setValue("true", withCompletionBlock: { (error, dbRef) in
                if error != nil {
                    ProgressHUD.showError(error?.localizedDescription)
                    return
                }
            })
            
            self.prepareForNewComment()
            self.view.endEditing(true)
        }
    }
    
    
    // MARK: - Load Comments from Firebase
    
    func loadComments() {
        ref = Database.database().reference()
        
        //observe child added works as a loop return each child individually
        ref.child("Posts").observe(.childAdded, with: { (snapshot) in
            guard let info = snapshot.value as? [String : Any]
                else { return }
            print("info: \(info)")
            print(snapshot)
            print(snapshot.key)
            
            //cast snapshot.value to correct Datatype
            
            if let caption = info["caption"] as? String,
                let imageURL = info["imageURL"] as? String,
                let imageFilename = info["imageFilename"] as? String,
                let id = info["id"] as? String,
                let likeCount = info["likeCount"] as? Int,
                let likes = info["likes"] as? String,
            let isLiked = info["isLiked"] as? Bool,
            let username = info["username"] as? String,
            let comment = info["comment"] as? String{
                
                
                
                
                //create new contact object
                let newPost = Post(aCaption: caption, aImageURL: imageURL, aImageFilename: imageFilename, anId: id, aLikeCount: likeCount, aLikes: nil, anIsLiked: isLiked, anUsername: username, aComment : comment)
                print(newPost)
                
                //append to contact array
                self.posts.append(newPost)
                
                
                //this is more efficient
                //insert indv rows as we retrive idv items
                let  index = self.posts.count - 1
                let indexPath = IndexPath(row: index, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .right)
            }
            
        })
        
        ref.child("Posts").observe(.value, with: { (snapshot) in
            guard let info = snapshot.value as? [String : Any]
                else { return }
            
            print (info)
        })
        
        ref.child("Posts").observe(.childRemoved, with: { (snapshot) in
            guard let info = snapshot.value as? [String : Any ] else { return }
            print(info)
            
            let deletedID = snapshot.key
            
            
            //filters through post returns index(deletedIndex) where Boolean condition is fulfilled
            if let deletedIndex = self.posts.index(where: { (student) -> Bool in
                return student.id == deletedID
            }) {
                //remove post when deletedIndex is found
                self.posts.remove(at: deletedIndex)
                let indexPath = IndexPath(row: deletedIndex, section: 0)
                
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
        })
        
        ref.child("Posts").observe(.childChanged, with: { (snapshot) in
            guard let info = snapshot.value as? [String:Any] else {return}
            
            guard let caption = info["caption"] as? String,
                let imageURL = info["imageURL"] as? String,
                let imageFilename = info["imageFilename"] as? String,
                let id = info["id"] as? String,
                let likeCount = info["likeCount"] as? Int,
                let isLiked = info["isLiked"] as? Bool,
                let username = info["username"] as? String else {return}
            
            if let matchedIndex = self.posts.index(where: { (post) -> Bool in
                return post.id == snapshot.key
            }) {
                let changedPost = self.posts[matchedIndex]
                changedPost.caption = caption
                changedPost.imageURL = imageURL
                changedPost.imageFilename = imageFilename
                changedPost.id = id
                changedPost.likeCount = likeCount
                if let likes = info["likes"] as? [String:Any] {
                    changedPost.likes = likes
                }
                changedPost.isLiked = isLiked
                changedPost.username = username
                
                let indexPath = IndexPath(row: matchedIndex, section: 0)
                self.tableView.reloadRows(at: [indexPath], with: .none)
            }
        })
    }
    
    
    // fetch all user info at once and cache it into the users array
    
    func fetchUser(uid: String, completed: @escaping () -> Void) {
        postID.observeUser(withID: uid) { user in
                self.users.append(user)
                
                completed()
            }
    }
    
    
    // MARK: - UI Methods
    
    func prepareForNewComment() {
        commentTextField.text = ""
        disableButton()
    }
    
    func handleTextField() {
        commentTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    func textFieldDidChange() {
        guard let comment = commentTextField.text, !comment.isEmpty else {
            // disable Send button if comment is blank and return
            disableButton()
            return
        }
        // otherwise enable the Send button
        enableButton()
    }
    
    func enableButton() {
        sendButton.alpha = 1.0
        sendButton.isEnabled = true
    }
    
    func disableButton() {
        sendButton.alpha = 0.2
        sendButton.isEnabled = false
    }
    
}


// MARK: - TableView Delegate and Data Source Methods

extension CommentViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentTableViewCell
        
        cell.comment = comments[indexPath.row]
        cell.user = users[indexPath.row]
        
        return cell
    }
    
}
