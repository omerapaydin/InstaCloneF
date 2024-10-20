//
//  FeedCell.swift
//  InstaCloneF
//
//  Created by Ömer on 29.09.2024.
//

import UIKit
import Firebase

class FeedCell: UITableViewCell {

    
    @IBOutlet weak var heartImage: UIImageView!
    @IBOutlet weak var likeCell: UILabel!
    @IBOutlet weak var descCell: UILabel!
    @IBOutlet weak var labelCell: UILabel!
    @IBOutlet weak var userCell: UILabel!
    @IBOutlet weak var imageCell: UIImageView!
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)

        heartImage.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        heartImage.addGestureRecognizer(tapGesture)
        
        
        }
    
    
    
    @objc func handleTap(){
        
        let fireStoreDatabase = Firestore.firestore()
        
        if let likeCount = Int(likeCell.text!){
            
            
            
            let likeStore = ["like": likeCount + 1] as [String : Any]
            
            fireStoreDatabase.collection("Posts").document(labelCell.text!).setData(likeStore, merge: true)
        }
        
    }

}
