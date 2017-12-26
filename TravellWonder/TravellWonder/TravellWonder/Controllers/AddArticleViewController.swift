import UIKit
class AddArticleViewController: UITableViewController, UIImagePickerControllerDelegate,UIPopoverControllerDelegate,UINavigationControllerDelegate{

    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var btnPicture: UIButton!
    @IBOutlet weak var statusPicker: UIPickerView!
    @IBOutlet weak var imageView: UIImageView!
    
    
    var imagePicker = UIImagePickerController()
    var userService = UserService()
    var articleService = ArticleService()
    var article: Article?
    var titleBool: Bool = false
    var textBool:Bool = false
    var photoBool:Bool = false
    var nationBool: Bool = false
    var saveArray: [Bool] = []
    var nations: [String] = ["Frankrijk", "Spanje", "Italië", "Amerika", "België", "Duitsland"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.saveArray = [self.titleBool, self.textBool,self.nationBool, self.photoBool]
        imagePicker.delegate = self
    }
    
    @IBAction func moveFocus() {
        titleField.resignFirstResponder()
        textField.becomeFirstResponder()
    }
  
    @IBAction func save() {
        let username = UserDefaults.standard.string(forKey: "username")
        print(username!)
        let image = UIImagePNGRepresentation(self.imageView.image!)!.base64EncodedString(options: .lineLength64Characters)
        userService.fetchUserByName(name: username!, completion: { (response) -> Void in
            let nation = self.nations[self.statusPicker.selectedRow(inComponent: 0)]
            self.article = Article( user: response, date: Date(), nation : nation, title : self.titleField.text!, text : self.textField.text, picture : image, likes : [])
            if self.article != nil {
                print("gelukt")
                self.articleService.postArticle(article: self.article!, completion: { (response) -> Void in
                    print(response._id!)
                })
                self.performSegue(withIdentifier: "didAddArticle", sender: self)
            } else {
                print("mislukt")
            }
        }
        )
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "didAddArticle"?:
            break
        default:
            fatalError("Unknown segue")
        }
    }
    @IBAction func hideKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
  
    @IBAction func btnClicked() {

        openGallary()
    }
    func openGallary()
    {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        self.photoBool = true
        self.saveArray[3] = self.photoBool
        
        if(!self.saveArray.contains(false))
        {
            saveButton.isEnabled = true
        }
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
}

extension AddArticleViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text {
            let oldText = text as NSString
            let newText = oldText.replacingCharacters(in: range, with: string)
           
            self.titleBool = newText.count > 0
             self.saveArray[0] = self.titleBool
            if(!self.saveArray.contains(false))
            {
                saveButton.isEnabled = true
            }
        } else {
            if(!self.saveArray.contains(false))
            {
                saveButton.isEnabled = true
            }
        }
        return true
    }
}
extension AddArticleViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let text = textView.text{
            let oldText = text as NSString
            let newText = oldText.replacingCharacters(in: range, with: text)
            self.textBool = newText.count > 0
            self.saveArray[1] = self.textBool
            print(self.saveArray)
            if(!self.saveArray.contains(false))
            {
                saveButton.isEnabled = true
                
            }
            
            
        }
     
        return true
    }
}

extension AddArticleViewController: UIPickerViewDataSource {
   
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.nations.count
    }
}

extension AddArticleViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.nationBool = true
         self.saveArray[2] = self.nationBool
        if(!self.saveArray.contains(false))
        {
            saveButton.isEnabled = true
        }
        return self.nations[row]
    }
}
