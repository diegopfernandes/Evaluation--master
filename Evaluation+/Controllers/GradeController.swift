import UIKit
class GradeController: UIViewController, UITableViewDataSource,
UITableViewDelegate, UITextViewDelegate, UITextFieldDelegate {
    //----------------- @IBOutlet ------------
    @IBOutlet weak var studentNameLabel: UILabel!
    @IBOutlet weak var courseField: UITextField!
    @IBOutlet weak var gradeField: UITextField!
    @IBOutlet weak var infoTableView: UITableView!
    @IBOutlet weak var averageField: UILabel!
    
    
    typealias studentName = String
    typealias course = String
    typealias grade = Double
    typealias gradeFinal = [Double: Double]
    //-----------------
    let userDefaultsObj = UserDefaultsManager()
    var studentGrades: [studentName: [course: grade]]!
    var arrayOfCourses: [course]!
    var arrayOfGrades: [grade]!
    //-----------------
    override func viewDidLoad() {
        super.viewDidLoad()
        studentNameLabel.text = userDefaultsObj.getValue(theKey: "name") as? String
        loadUserDefaults()
        fillUpArray()
    }
    //-----------------
    func fillUpArray() {
        let name = studentNameLabel.text
        let coursesAndGrades = studentGrades[name!]
        arrayOfCourses = [course](coursesAndGrades!.keys)
        arrayOfGrades = [grade](coursesAndGrades!.values)
    }
    
    //-----------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->
        Int {
            return arrayOfCourses.count
    }
    //-----------------
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
            let cell: UITableViewCell = infoTableView.dequeueReusableCell(withIdentifier:
                "protoCell")!
            
            if let aCourse = cell.viewWithTag(100) as! UILabel! {
                aCourse.text = arrayOfCourses[indexPath.row]
            }
            
            if let aValue = cell.viewWithTag(101) as! UILabel! {
                aValue.text = String(arrayOfGrades[indexPath.row])
            }
            return cell
    }
    //-----------------supprimer
    func tableView(_ tableView: UITableView, commit editingStyle:
        UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let name  = studentNameLabel.text
            var coursesAndGrades = studentGrades[name!]!
            let grades = [course](coursesAndGrades.keys)[indexPath.row]
            coursesAndGrades[grades] = nil
            studentGrades[name!] = coursesAndGrades
            userDefaultsObj.setKey(theValue: studentGrades as AnyObject, theKey: "grades")
            fillUpArray()
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.automatic)
        }
    }

    //-----------------
    func loadUserDefaults() {
        if userDefaultsObj.doesKeyExist(theKey: "grades") {
            studentGrades = userDefaultsObj.getValue(theKey: "grades") as!
                [studentName: [course: grade]]
        } else {
            studentGrades = [studentName: [course: grade]]()
        }
    }
    //-----------------
    
    
    
    func calculateAverage(gradeFinal: [Double: Double], proportion: (_ sum: Double, _ sur: Double) -> Double) -> String {
        let sumGrades = [Double](gradeFinal.keys).reduce(0, +)
        let sumSur = [Double](gradeFinal.values).reduce(0, +)
        let conversion = proportion(sumGrades, sumSur)
        return String(format: "Average = %0.1/%0.1f or %0.1f/100", sumGrades, sumSur, conversion)
    }
    
    func moyenne() -> [Double: Double] {
        let average = arrayOfGrades.reduce(0, +)
        let sum = arrayOfGrades.count
        let moyenne = Double(average/Double(sum))
        let gradeFinal = [moyenne: 10.0]
        return gradeFinal
    }
    
    //-----------------
    @IBAction func add(_ sender: UIButton) {
        let name = studentNameLabel.text!
        var studentCourses = studentGrades[name]!
        studentCourses[courseField.text!] = Double(gradeField.text!)
        studentGrades[name] = studentCourses
        userDefaultsObj.setKey(theValue: studentGrades as AnyObject, theKey:
            "grades")
        fillUpArray()
        infoTableView.reloadData()
        averageField.text = calculateAverage(gradeFinal: moyenne(), proportion: { $0 * 100.0 / $1 })
        
    }
}

