import UIKit

class CommentCell: UITableViewCell {
    
@IBOutlet weak var picture: UIImageView!
@IBOutlet weak var descriptionComment: UILabel!
var userService = UserService()

var comment : Comment!{
    didSet {
        self.userService.fetchUser(id: (comment!.userId)!, completion: { (response) -> Void in
            let dataDecoded : Data = Data(base64Encoded: response.picture!, options: .ignoreUnknownCharacters)!
            let decodedimage = UIImage(data: dataDecoded)
            self.picture.image = decodedimage
            self.descriptionComment.text = self.comment.text
        })
        
        
        
    }
}

}
