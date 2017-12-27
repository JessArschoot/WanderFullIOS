import UIKit
class AddCommentViewController: UIViewController{
    
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    
    
   
    var userService = UserService()
    var articleService = ArticleService()
    var comment: Comment?
    var articleId: String?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    @IBAction func save() {
        let username = UserDefaults.standard.string(forKey: "username")
        print(username!)
        userService.fetchUserByName(name: username!, completion: { (response) -> Void in
           
            self.comment = Comment(text: self.textField.text!, user: response)
            if self.comment != nil {
                print("gelukt")
                self.performSegue(withIdentifier: "didAddComment", sender: self)
            } else {
                print("mislukt")
            }
        }
        )
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "didAddComment"?:
            break
        default:
            fatalError("Unknown segue")
        }
    }
    @IBAction func hideKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    
}

extension AddCommentViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text {
            let oldText = text as NSString
            let newText = oldText.replacingCharacters(in: range, with: string)
            
                saveButton.isEnabled = text.count > 0
            }
        return true
        }
    
    
}

