import UIKit

class LoginController: UIViewController {
    
    @IBOutlet weak var gebruikersnaam: UITextField!
    @IBOutlet weak var wachtwoord: UITextField!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var lblWachtwoord: UILabel!
    @IBOutlet weak var lblGebruikersnaam: UILabel!
    var userService = UserService()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if  UserDefaults.standard.string(forKey: "username") != nil {
            gebruikersnaam.isHidden = true
            lblGebruikersnaam.text = UserDefaults.standard.string(forKey: "username")
            lblWachtwoord.isHidden = true
            wachtwoord.isHidden = true
            login.setTitle("Ga verder", for: .normal)
            
        }
       
    }
    @IBAction func hideKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    @IBAction func moveFocus() {
        gebruikersnaam.resignFirstResponder()
        wachtwoord.becomeFirstResponder()
    }
    @IBAction func btnLogin(sender: UIButton ){
        if  UserDefaults.standard.string(forKey: "username") != nil {
            ShowOverview()
        }
        else{
        userService.logIn(username: self.gebruikersnaam.text!, password: self.wachtwoord.text!, completion: {
            if  UserDefaults.standard.string(forKey: "authtoken") != nil {
                self.ShowOverview()
            } })
        }
    }
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){
        gebruikersnaam.isHidden = false
        lblGebruikersnaam.text = "Gebruikersnaam"
        lblWachtwoord.isHidden = false
        wachtwoord.isHidden = false
        gebruikersnaam.text = ""
        wachtwoord.text = ""
    }
    func ShowOverview()
    {
        performSegue(withIdentifier: "ShowOverview", sender: self)
    }
}
