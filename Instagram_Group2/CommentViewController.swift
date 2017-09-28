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
    
    //the id of the user which want to comment
    var postID: String!
    //the contents of the comment
    var comments = [Comment]()
    var users = [Contact]()
    var ref: DatabaseReference!
    var posts : [Post] = []
    
    // MARK: - View Lifecycle
    //
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
        let comments : [String:Any] = ["name" : "", "text": "" ,"userID": "randomUserID1"]
        
        let randomID = String(Int(Date().timeIntervalSince1970))
        
        
        ref.child("Comments").child(randomID).setValue(comments)
    }



// MARK: - Load Comments from Firebase

    func loadComments() {
        
        ref = Database.database().reference()
        
        //observe child added works as a loop return each child individually
        ref.child("Comments").child("postID").observe(.childAdded, with: { (snapshot) in
            guard let info = snapshot.value as? [String : Any]
                else { return }
            print("info: \(info)")
            print(snapshot)
            print(snapshot.key)
            
            let newcomment = Comment.transformComment(postDictionary: info)
            
            
            
            let comment = Comment()
            
            //append to contact array
            
            
            //this is more efficient
            //insert indv rows as we retrive idv items
            DispatchQueue.main.async {
                self.comments.append(newcomment)
                let  index = self.comments.count - 1
                let indexPath = IndexPath(row: index, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .right)
            }
        })
        
        ref.child("Comments").observe(.childRemoved, with: { (snapshot) in
            guard let info = snapshot.value as? [String : Any ] else { return }
            print(info)
            
            let deletedID = snapshot.key
            
            
            //filters through post returns index(deletedIndex) where Boolean condition is fulfilled
            if let deletedIndex = self.comments.index(where: { (user) -> Bool in
                return Comment.transformComment(postDictionary: info).uid == deletedID
            }) {
                //remove post when deletedIndex is found
                self.posts.remove(at: deletedIndex)
                let indexPath = IndexPath(row: deletedIndex, section: 0)
                
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
        })
    }


    // fetch all user info at once and cache it into the users array



    //
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
       // cell.user = users[indexPath.row]
        
        return cell
    }
    
}


