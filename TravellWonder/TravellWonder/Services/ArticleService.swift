import SwiftyJSON
import Alamofire
import ObjectMapper


class ArticleService {

    private let url : String = "https://webapps-frontend-jess.herokuapp.com/"
    
    public init() {}
    
     func fetchAllArticles (completion: @escaping (Array<Article>) -> Void) -> Void{
        
            Alamofire.request(url + "API/articles").validate(statusCode: 200..<300).responseJSON { response in
                switch response.result {
                    case .success:
                        //to get JSON return value
                        guard let responseJSON = response.result.value as? Array<[String: AnyObject]> else {
                               // failure(0,"Error reading response")
                                return
                        }
                        guard let articles:[Article] = Mapper<Article>().mapArray(JSONArray: responseJSON) else {
                               // failure(0,"Error mapping response")
                                return
                        }
                    completion(articles)
                    //case .failure(let error):
                        //failure(0,"Error \(error)")
                case .failure(_):
                    print("failure")
                }
            }
    }
    func postArticle (article: Article, completion: @escaping (Article) -> Void) -> Void{
        let token = UserDefaults.standard.string(forKey: "authtoken")
            let headers = [
                "Authorization": "Bearer "+token!
            ]
        let parameters = [
            "username": article.user?.username! as Any,
            "nation": article.nation!,
            "title": article.title!,
            "text": article.text!,
            "picture": article.picture!,
            "likes": article.likes!
            ]

        var statusCode: Int = 0
        Alamofire.request(url + "API/article/add-articleIOs", method: .post, parameters: parameters as? [String: Any], encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success(_):
                    statusCode = (response.response?.statusCode)! //Gets HTTP status code, useful for debugging
                    if response.result.value != nil {
                        //Handle the results as JSON
                        //let post = JSON(value)
                        guard let responseJSON = response.result.value as? [String: AnyObject] else {
                            // failure(0,"Error reading response")
                            return
                        }
                        guard let article = Mapper<Article>().map(JSON: responseJSON) else {
                            // failure(0,"Error mapping response")
                            return
                        }
                        completion(article)
                    }
                    
                case .failure(_):
                    print("fault")
                }
                
    }
    }
    
//    let token = UserDefaults.standard.string(forKey: "authtoken")
//    let headers = [
//        "Authorization": "Bearer "+token!
//    ]
    func likeArticle (username : String, id : String, completion: @escaping (Article) -> Void) -> Void{
        let token = UserDefaults.standard.string(forKey: "authtoken")
        let headers = [
            "Authorization": "Bearer "+token!
        ]
        let parameters = [
            "username": username as Any,
            
        ]
        
        var statusCode: Int = 0
        Alamofire.request(url + "API/article/add-like/" + id, method: .post, parameters: parameters as? [String: Any], encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success(_):
                    statusCode = (response.response?.statusCode)! //Gets HTTP status code, useful for debugging
                    if response.result.value != nil {
                        //Handle the results as JSON
                        //let post = JSON(value)
                        guard let responseJSON = response.result.value as? [String: AnyObject] else {
                            // failure(0,"Error reading response")
                            return
                        }
                        guard let article = Mapper<Article>().map(JSON: responseJSON) else {
                            // failure(0,"Error mapping response")
                            return
                        }
                        completion(article)
                    }
                    
                case .failure(_):
                    print("fault")
                }
                
        }
    }
    func removeLikeArticle (username : String, id : String, completion: @escaping (Article) -> Void) -> Void{
        let token = UserDefaults.standard.string(forKey: "authtoken")
        let headers = [
            "Authorization": "Bearer "+token!
        ]
        let parameters = [
            "username": username as Any,
            
            ]
        
        var statusCode: Int = 0
        Alamofire.request(url + "API/article/remove-like/" + id, method: .post, parameters: parameters as? [String: Any], encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success(_):
                    statusCode = (response.response?.statusCode)! //Gets HTTP status code, useful for debugging
                    if response.result.value != nil {
                        //Handle the results as JSON
                        //let post = JSON(value)
                        guard let responseJSON = response.result.value as? [String: AnyObject] else {
                            // failure(0,"Error reading response")
                            return
                        }
                        guard let article = Mapper<Article>().map(JSON: responseJSON) else {
                            // failure(0,"Error mapping response")
                            return
                        }
                        completion(article)
                    }
                    
                case .failure(_):
                    print("fault")
                }
                
        }
    }
    
    func fetchAllArticlesByUser (user: String, completion: @escaping (Array<Article>) -> Void) -> Void{
        let token = UserDefaults.standard.string(forKey: "authtoken")
        let headers = [
            "Authorization": "Bearer "+token!
        ]
        Alamofire.request(url + "API/users/articles/" + user, method: .get, encoding: JSONEncoding.default, headers: headers ).validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case .success:
                //to get JSON return value
                guard let responseJSON = response.result.value as? Array<[String: AnyObject]> else {
                    // failure(0,"Error reading response")
                    return
                }
                guard let articles:[Article] = Mapper<Article>().mapArray(JSONArray: responseJSON) else {
                    // failure(0,"Error mapping response")
                    return
                }
                completion(articles)
                //case .failure(let error):
            //failure(0,"Error \(error)")
            case .failure(_):
                print("failure")
            }
        }
    }
    
    func removeCommentArticle (articleId : String, commentId : String, completion: @escaping (Article) -> Void) -> Void{
        let token = UserDefaults.standard.string(forKey: "authtoken")
        let headers = [
            "Authorization": "Bearer "+token!
        ]
        let parameters = [
            "id": articleId as Any,
            
            ]
        
        var statusCode: Int = 0
        Alamofire.request(url + "API/article/remove-comment/" + commentId, method: .post, parameters: parameters as? [String: Any], encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success(_):
                    statusCode = (response.response?.statusCode)! //Gets HTTP status code, useful for debugging
                    if response.result.value != nil {
                        //Handle the results as JSON
                        //let post = JSON(value)
                        guard let responseJSON = response.result.value as? [String: AnyObject] else {
                            // failure(0,"Error reading response")
                            return
                        }
                        guard let article = Mapper<Article>().map(JSON: responseJSON) else {
                            // failure(0,"Error mapping response")
                            return
                        }
                        completion(article)
                    }
                    
                case .failure(_):
                    print("fault")
                }
                
        }
    }
    
    func postComment (comment: Comment,username: String,articleId: String, completion: @escaping (Article) -> Void) -> Void{
        let token = UserDefaults.standard.string(forKey: "authtoken")
        let headers = [
            "Authorization": "Bearer "+token!
        ]
        let parameters = [
            "username": username,
            "text": comment.text!
            ] as [String : Any]
        
        var statusCode: Int = 0
        Alamofire.request(url + "API/article/add-commentIos/" + articleId, method: .post, parameters: parameters as? [String: Any], encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success(_):
                    statusCode = (response.response?.statusCode)! //Gets HTTP status code, useful for debugging
                    if response.result.value != nil {
                        //Handle the results as JSON
                      
                        guard let responseJSON = response.result.value as? [String: AnyObject] else {
                             print(0,"Error reading response")
                            return
                        }
                        guard let article = Mapper<Article>().map(JSON: responseJSON) else {
                            print(0,"Error mapping response")
                            return
                        }
                        completion(article)
                    }
                    
                case .failure(_):
                    print("fault")
                }
                
        }
    }

    func removeArticle (articleId : String, completion: @escaping () -> Void) -> Void{
        let token = UserDefaults.standard.string(forKey: "authtoken")
        let headers = [
            "Authorization": "Bearer "+token!
        ]
        var statusCode: Int = 0
        Alamofire.request(url + "API/article/remove-article/" + articleId, method: .post, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success(_):
                    statusCode = (response.response?.statusCode)! //Gets HTTP status code, useful for debugging
                        completion()
                    
                case .failure(_):
                    print("fault")
                }
                
        }
    }
    
}
