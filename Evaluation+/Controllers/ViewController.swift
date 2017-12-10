
import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    //-------------------IBOutlet connections
    @IBOutlet weak var studentNameField: UITextField!
    @IBOutlet weak var studentNameTableView: UITableView!
    //-------------------
    typealias studentName = String
    typealias course = String
    typealias grade = Double
    //-------------------
    let userDefaultsObj = UserDefaultsManager()
    var studentGrades: [studentName: [course: grade]]!
    //-------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserDefaults()
    }
    //-------------------tablewview functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentGrades.count
    }
    //-------------------
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        cell.textLabel?.text = [studentName](studentGrades.keys)[indexPath.row]
        return cell
    }
    //----supprimer---
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete{
            let name  = [studentName](studentGrades.keys)[indexPath.row]
            studentGrades[name] = nil
            userDefaultsObj.setKey(theValue: studentGrades as AnyObject, theKey: "grades")
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.automatic)
        }
    }
    //-----enregistrer&&montrer dans l'autre view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = [studentName](studentGrades.keys)[indexPath.row]
        userDefaultsObj.setKey(theValue: name as AnyObject, theKey: "name")
        performSegue(withIdentifier: "segue", sender: nil)
    }
    //-------------------show/hide keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //------------
    @IBAction func addStudent(_ sender: UIButton) {
        if studentNameField.text != "" {
            studentGrades[studentNameField.text!] = [course: grade]()
            studentNameField.text = ""
            userDefaultsObj.setKey(theValue: studentGrades as AnyObject, theKey: "grades")
            studentNameTableView.reloadData()
        }
    }
    
    //-------------
    func loadUserDefaults() {
        if userDefaultsObj.doesKeyExist(theKey: "grades"){
            studentGrades = userDefaultsObj.getValue(theKey: "grades") as! [studentName: [course: grade]]
        }else{
            studentGrades = [studentName: [course: grade]]()
        }
    }
    //-------------------
}

