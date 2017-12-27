import UIKit

class LogOutController: UIViewController {

    @IBOutlet weak var articlesList: UITableView!
    var articles : [Article] = []
    
    var service = ArticleService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = UserDefaults.standard.string(forKey: "username")!
        service.fetchAllArticlesByUser(user: user, completion: { (response) -> Void in self.articles = response.reversed()
            self.articlesList.reloadData()
        })
    }
    
    
    
    
    
    
    @IBAction func btnLogOut(sender: UIButton ){
        UserDefaults.standard.removeObject(forKey: "authtoken")
        UserDefaults.standard.removeObject(forKey: "username")
        self.performSegue(withIdentifier: "unwindLogInController", sender: self)
    }
    
}
extension LogOutController: UITableViewDelegate {
    
    func tableView(_: UITableView, didSelectRowAt: IndexPath){
        
        
    }
    
    
}

extension LogOutController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! ArticleCell
        cell.article = articles[indexPath.row]
        return cell
    }
}

