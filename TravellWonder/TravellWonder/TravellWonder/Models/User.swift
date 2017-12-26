import UIKit
import ObjectMapper

class User: Mappable {
    var id: String?
    var name : String?
    var username: String?
    var hash: String?
    var salt: String?
    var picture: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["_id"]
        name    <- map["name"]
        username   <- map["username"]
        hash <- map["hash"]
        salt <- map["salt"]
        picture <- map["picture"]
        
    }
    
    
}
