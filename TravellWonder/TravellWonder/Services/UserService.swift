import Alamofire
import ObjectMapper
import SwiftyJSON

class UserService {
    
    private let url : String = "https://webapps-frontend-jess.herokuapp.com/"
    
    public init() {}

    func logIn(username : String, password : String, completion: @escaping () -> Void ){
        
        let parameters = [
            "username": username, //email
            "password": password //password
        ]
        
        var statusCode: Int = 0
        Alamofire.request(url + "API/users/login", method: .post, parameters: parameters as? [String: Any], encoding: JSONEncoding.default, headers: [:])
            .responseJSON { response in
                switch response.result {
                    case .success(_):
                    statusCode = (response.response?.statusCode)! //Gets HTTP status code, useful for debugging
                    if let value = response.result.value {
                        //Handle the results as JSON
                        let post = JSON(value)
                        if let key = post["token"].string {
                            // Userdefaults helps to store session data locally
                            //print(key)
                            UserDefaults.standard.setValue(key, forKey: "authtoken")
                            UserDefaults.standard.setValue(username, forKey:"username")
                            UserDefaults.standard.synchronize()
                        }
                        completion()
                    }
              
                case .failure(_):
                    print("fault")
                }
       
    }
       
    
}
    func fetchUser (id: String, completion: @escaping (User) -> Void) -> Void{
        let token = UserDefaults.standard.string(forKey: "authtoken")
        let headers = [
            "Authorization": "Bearer "+token!
        ]
        
        Alamofire.request(url + "API/users/" + id, method: .get, encoding: JSONEncoding.default, headers: headers  ).validate(statusCode: 200..<310).responseJSON { response in
           
            switch response.response?.statusCode {
            case (200...310)?:
                //to get JSON return value
                guard let responseJSON = response.result.value as? [String: AnyObject] else {
                    // failure(0,"Error reading response")
                    return
                }
                guard let user:User = Mapper<User>().map(JSON: responseJSON) else {
                    // failure(0,"Error mapping response")
                    return
                }
                completion(user)
                //case .failure(let error):
            //failure(0,"Error \(error)")
            default:
                print("failure")
            }
        }
    }
    func fetchUserByName (name: String, completion: @escaping (User) -> Void) -> Void{
        let token = UserDefaults.standard.string(forKey: "authtoken")
        let headers = [
            "Authorization": "Bearer "+token!
        ]
        
        Alamofire.request(url + "API/users/user/" + name, method: .get, encoding: JSONEncoding.default, headers: headers  ).validate(statusCode: 200..<310).responseJSON { response in
            
            switch response.response?.statusCode {
            case (200...310)?:
                //to get JSON return value
                guard let responseJSON = response.result.value as? [String: AnyObject] else {
                    // failure(0,"Error reading response")
                    return
                }
                guard let user:User = Mapper<User>().map(JSON: responseJSON) else {
                    // failure(0,"Error mapping response")
                    return
                }
                completion(user)
                //case .failure(let error):
            //failure(0,"Error \(error)")
            default:
                print("failure")
            }
        }
    }
}


