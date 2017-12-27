import UIKit

class ArticleCell: UITableViewCell {
    
    @IBOutlet weak var picture: UIImageView!
    //@IBOutlet weak var nation: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var descriptionArticle: UILabel!
    @IBOutlet weak var like: UIButton!
    var username: String = ""
    var likeBool: Bool = false
    var service = ArticleService()
    var article: Article! {
        didSet {
            self.username = UserDefaults.standard.string(forKey: "username")!
            self.alreadyLiked()
            let dataDecoded : Data = Data(base64Encoded: article.picture!, options: .ignoreUnknownCharacters)!
            let decodedimage = UIImage(data: dataDecoded)
            picture.image = decodedimage
            
            if(likeBool)
            {
                self.like.tintColor = .red
            }
            title.text = String(format: article.nation! + " -- " + article.title!)
            descriptionArticle.text = article.text
        }
    }
    
    @IBAction func btnLike()
    {
        self.alreadyLiked()
        if(!self.likeBool){
            self.article.likes?.append(self.username)
            self.like.tintColor = .red
            self.likeBool = true
            service.likeArticle(username: username, id: article._id!, completion: { (response) in
                print("gelukt")
            })
        }
        else{
            let i = self.article.likes?.index{$0 == self.username}
            self.article.likes?.remove(at: i! )
            self.like.tintColor = .black
            self.likeBool = false
            service.removeLikeArticle(username: username, id: article._id!, completion: { (response) in
                print("gelukt")
            })
        }

    }
    func alreadyLiked(){
        self.article.likes?.forEach { n in
            if(n != username ){
                self.likeBool = false
            }
            else{
                self.likeBool = true
            }
        }
        
    }
    
}
