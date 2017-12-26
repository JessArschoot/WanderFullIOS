import UIKit
import ObjectMapper

    class Comment: Mappable {
        var _id: String?
        var date: Date?
        var text: String?
        var userId: String?
        var user: User?


    required init?(map: Map) {
        
    }

    func mapping(map: Map) {
        _id    <- map["_id"]
        date <- map["date"]
        text   <- map["text"]
        userId <- map["user"]
        
    }

}
