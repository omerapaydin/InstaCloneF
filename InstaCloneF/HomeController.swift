//
//  HomeController.swift
//  InstaCloneF
//
//  Created by Ömer on 28.09.2024.
//

import UIKit
import Firebase
import SDWebImage
import SDWebImageMapKit


class HomeController: UIViewController , UITableViewDelegate , UITableViewDataSource{
    

    @IBOutlet weak var tableView: UITableView!
    
    
    var userEmailArray = [String]()
    var userCommentArray = [String]()
    var likeArray = [Int]()
    var userImageArray = [String]()
    var documentIdArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        
        getData()
        
        // Do any additional setup after loading the view.
    }
    
    func getData(){
        
        let database = Firestore.firestore()
        
        database.collection("Posts").order(by: "date").addSnapshotListener { (snapshot, error) in
            
            if error != nil {
                print(error?.localizedDescription)
            }else{
                
                if snapshot?.isEmpty != true && snapshot != nil{
                    
                    self.userImageArray.removeAll(keepingCapacity: false)
                    self.userEmailArray.removeAll(keepingCapacity: false)
                    self.userCommentArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    self.documentIdArray.removeAll(keepingCapacity: false)
                    
                    
                    for document in snapshot!.documents{
                        
                        let documentId = document.documentID
                        self.documentIdArray.append(documentId)
                        
                        if let postedBy = document.get("posteBy") as? String{
                            self.userEmailArray.append(postedBy)
                        }
                        
                        if let comment = document.get("comment") as? String{
                            self.userCommentArray.append(comment)
                        }
                        
                        if let like = document.get("like") as? Int{
                            self.likeArray.append(like)
                        }
                        
                        if let imageUrl = document.get("imageUrl") as? String{
                            self.userImageArray.append(imageUrl)
                        }
                        
                        
                        
                    }
                    
                    self.tableView.reloadData()
                    
                }
                
                
            }
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.descCell.text = userCommentArray[indexPath.row]
        cell.imageCell.sd_setImage(with: URL(string: self.userImageArray[indexPath.row]))
        cell.userCell.text = userEmailArray[indexPath.row]
        cell.likeCell.text = String(likeArray[indexPath.row])
        cell.labelCell.text = documentIdArray[indexPath.row]
        return cell
    }

   

}
