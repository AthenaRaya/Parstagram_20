//
//  FeedViewController.swift
//  Parstagram_
//
//  Created by Athena Raya on 3/3/20.
//  Copyright © 2020 Athena Raya. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage
import MessageInputBar

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MessageInputBarDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    let commentBar = MessageInputBar( ) // creaating a instance.
    var showsCommentBar = false;
    
    var posts = [PFObject]() //  empty array of post
    var selectedPost : PFObject!    
    override func viewDidLoad() {
         super.viewDidLoad()
         
        commentBar.inputTextView.placeholder = " Add a comment..."
        commentBar.sendButton.title = "Post"
        commentBar.delegate = self
        
        
         tableView.delegate = self
         tableView.dataSource = self
         
         tableView.keyboardDismissMode = .interactive
        
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyBoardWillBeHidden(note:)), name: UIResponder.keyboardWillHideNotification, object: nil)
         

         // Do any additional setup after loading the view.
     }
    
    
    @objc func keyBoardWillBeHidden(note: Notification){
        commentBar.inputTextView.text = nil 
        showsCommentBar = false
        becomeFirstResponder()
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let post = posts[section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        return comments.count + 2
        
        
    }
    
    override var inputAccessoryView: UIView?{
        return commentBar
    }
    
    override var canBecomeFirstResponder: Bool {
        return showsCommentBar
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
                let post = posts[indexPath.section]
                let comments = (post["comments"] as? [PFObject]) ?? []
        
                if indexPath.row == 0 {
        
                let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
                
                let user = post["author"] as! PFUser
                cell.usernameLabel.text = user.username
                
                cell.captionLabel.text = post["caption"] as! String
                
                let imageFile = post["image"] as! PFFileObject
                let urlString = imageFile.url!
                let url = URL(string: urlString)!
                
                cell.photoView.af_setImage(withURL: url)
                
               return cell
                }else if indexPath.row > comments.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
                    
            let comment = comments[indexPath.row-1]
            cell.commentLabel.text = comment["text"] as? String
            
            let user = comment["author"] as! PFUser
            cell.nameLabel.text = user.username
            
            return cell

                } else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "AddCommentCell")!
                    return cell
                  }
      
        
    }
    
   
   
    
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
           
           let query = PFQuery(className: "Posts") //  query for parse
        
           query.includeKeys(["author", "comments", "comments.author"]) // dot . notation
           query.limit = 20 // last 20
           
           query.findObjectsInBackground{ (posts, error) in
               if posts != nil {
                   self.posts = posts! //
                   self.tableView.reloadData()
                   // get the query
                   // store the data
                   //reload the table view
               }
               
           }
        
        
        func messageInputBar(_inputBar: MessageInputBar, didPressSendButtonWith text: String){
            //create the comment
        
           let comment = PFObject(className: "Comments")
            
           comment["text"] = "This is a random comment"
           comment["post"] = selectedPost
           comment["author"] = PFUser.current()!
            
            
           selectedPost.add(comment, forKey: "comments")
            
           selectedPost.saveInBackground{ (success, error)in
                  if success {
                       print("Comment saved")
                }else{
                        print("Error saving comment")
                        }
                      }
                 }
            
          tableView.reloadData()
            //clear and dismiss.
            commentBar.inputTextView.text = nil
        
            showsCommentBar = false
            becomeFirstResponder()
            commentBar.inputTextView.resignFirstResponder()
           
          

    }
        
   
     @IBAction func onLogoutButton(_ sender: Any) {
              
              PFUser.logOut() // clear parsh cache
              let main = UIStoryboard(name: "Main" , bundle: nil)
              let loginViewController = main.instantiateViewController(identifier:  "LoginViewController")
              
             let delegate =  UIApplication.shared.delegate as! AppDelegate
              
              delegate.window?.rootViewController = loginViewController
          }
    
  
      
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
              let post = posts[indexPath.section]
              let comments = (post["comments"] as? [PFObject]) ?? []
        
        
         if indexPath.row == comments.count + 1 {
            showsCommentBar = true
            becomeFirstResponder()
            commentBar.inputTextView.becomeFirstResponder() // raising the keyboard
            selectedPost = post
        }
              
    }

     
   
    }
    
  


