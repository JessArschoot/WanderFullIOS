import UIKit

class ArticleDetailController: UIViewController {
    
    @IBOutlet weak var commentList: UITableView!
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var titel: UILabel!
    @IBOutlet weak var descriptionArticle: UILabel!
    @IBOutlet weak var likelabel: UILabel!
    @IBOutlet weak var commentlabel: UILabel!
    @IBOutlet weak var like: UIButton!
    @IBOutlet weak var comment: UIButton!
    @IBOutlet weak var pictureUser: UIImageView!

    
    @IBOutlet weak var nameUser: UILabel!
    var username: String = ""
    var service = ArticleService()
    var likeBool: Bool = false
    var article: Article!
    
    override func viewDidLoad() {
        title = article.nation
        self.commentList.rowHeight = 75
        self.username = UserDefaults.standard.string(forKey: "username")!
        self.alreadyLiked()
        let dataDecoded : Data = Data(base64Encoded: article.picture!, options: .ignoreUnknownCharacters)!
        let decodedimage = UIImage(data: dataDecoded)
        self.picture.image = decodedimage
        self.titel.text = article.title
        self.descriptionArticle.text = article.text
        self.likelabel.text = "\( article.likes?.count ?? 0)"
        if(self.likeBool){
            self.like.tintColor = .red
        }
        self.commentlabel.text = "\(article.comments?.count ?? 0)"
        let dataDecoded2 : Data = Data(base64Encoded: (article.user?.picture!)!, options: .ignoreUnknownCharacters)!
        let decodedimage2 = UIImage(data: dataDecoded2)
        self.pictureUser.layer.cornerRadius = self.pictureUser.frame.size.width / 2
        self.pictureUser.clipsToBounds = true
        self.pictureUser.image = decodedimage2
        self.nameUser.text = article.user?.username
        
        
    }
    @IBAction func btnLike()
    {
        self.alreadyLiked()
        if(!self.likeBool){
            self.article.likes?.append(self.username)
            self.likelabel.text = "\( article.likes?.count ?? 0)"
            self.like.tintColor = UIColor.red
            self.likeBool = true
            service.likeArticle(username: username, id: article._id!, completion: { (response) in
                print("gelukt")
            })
        }
        else{
            let i = self.article.likes?.index{$0 == self.username}
            self.article.likes?.remove(at: i! )
            self.likelabel.text = "\( article.likes?.count ?? 0)"
            self.like.tintColor = UIColor.black
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

extension ArticleDetailController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
       
                let deleteAction = UIContextualAction(style: .destructive, title: "Verwijder") {
                    (action, view, completionHandler) in
                    if (self.article.user?.username == self.username){
                        self.service.removeCommentArticle(articleId: self.article._id!, commentId: self.article.comments![indexPath.row]._id!, completion: { (response) in
                            print("gelukt")
                        })
                        _ = self.article.comments![indexPath.row]
                        _ = self.article.comments!.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    }
                    else{
                        let alert = UIAlertController(title: "Mislukt", message: "Deze comment kan je niet verwijderen wegens post van andere gebruiker.", preferredStyle: UIAlertControllerStyle.alert)
                        
                        // add an action (button)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        
                        // show the alert
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                return UISwipeActionsConfiguration(actions: [deleteAction])
        
    }
    
}
extension ArticleDetailController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return article.comments!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
        cell.comment = article.comments![indexPath.row]
        return cell
    }
}

//extension ArticleDetailController: UITableViewDelegate {
//
//
//}






