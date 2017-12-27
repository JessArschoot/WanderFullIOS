import UIKit

class OverviewController: UIViewController {
    
    @IBOutlet weak var articlesList: UITableView!
    
    var indexPath: IndexPath = []
    var articles : [Article] = []
    var service = ArticleService()
    var username: String = ""
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(OverviewController.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
     
        return refreshControl
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        username = UserDefaults.standard.string(forKey: "username")!
        self.articlesList.addSubview(self.refreshControl)
        service.fetchAllArticles(completion: { (response) -> Void in self.articles = response.reversed()
            self.articlesList.reloadData()
            })
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        service.fetchAllArticles(completion: { (response) -> Void in
            self.articles = response.reversed()
            self.articlesList.reloadData()
            refreshControl.endRefreshing()
        })
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
            case "showArticleDetail"?:
                let articleViewController = segue.destination as! ArticleDetailController
                let selection = articlesList.indexPathForSelectedRow!
                let article = articles[selection.row]
                articleViewController.article = article
            case "addArticle"?:
                break
            default:
                fatalError("Unknown segue")
            }
    }
    @IBAction func unwindFromAddPost(_ segue: UIStoryboardSegue) {
        switch segue.identifier {
        case "didAddArticle"?:
            let addArticleViewController = segue.source as! AddArticleViewController
            let article = addArticleViewController.article!
            articles.append(article)
            articlesList.insertRows(at: [IndexPath(row: articles.count - 1, section: 0)], with: .automatic)
        
        default:
            fatalError("Unknown segue")
        }
    }
  
  
}

extension OverviewController: UITableViewDelegate {
    
    func tableView(_: UITableView, didSelectRowAt: IndexPath){
        self.indexPath = didSelectRowAt
        
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Verwijder") {
            (action, view, completionHandler) in
            if (self.articles[indexPath.row].user?.username == self.username){
                self.service.removeArticle(articleId: self.articles[indexPath.row]._id!, completion: { () in
                    print("gelukt")
                    
                })
                _ = self.articles.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                
            }
            else{
                let alert = UIAlertController(title: "Mislukt", message: "Dit artikel kan je niet verwijderen wegens artikel van andere gebruiker.", preferredStyle: UIAlertControllerStyle.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
        
    }

    

}

extension OverviewController: UITableViewDataSource {
    
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






