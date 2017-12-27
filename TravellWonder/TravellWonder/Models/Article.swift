import UIKit
import ObjectMapper

class Article: Mappable {
    
    var _id : String?
    var user: User?
    var nation : String?
    var date : Date?
    var title : String?
    var text : String?
    var picture : String?
    var likes : [String]?
    var comments: [Comment]?
    
    required init?(map: Map) {
        
    }
    init(user: User, date: Date, nation: String, title:String, text:String, picture:String, likes: [String]){
        self.user = user
        self.date = date
        self.nation = nation
        self.title = title
        self.text = text
        self.picture = picture
        self.likes = likes
    }
    
    func mapping(map: Map) {
        _id    <- map["_id"]
        user   <- map["user"]
        nation <- map["nation"]
        date   <- map["date"]
        title  <- map["title"]
        text   <- map["text"]
        picture <- map["picture"]
        likes  <- map["likes"]
        comments <- map["comments"]
        
    }
    
   
    
}

