//Health Tracker
//Deecon Precht
    //dgprecht@iu.edu
//Nicholas Van Burk
    //ndvanbur@iu.edu
//28 APR 2023
import Foundation
import CoreData
import UIKit


class User {
    
    var currWeight : Int;
    var goalWeight : Int;
    var weightMeasurements : [WtMeasurment];
    var heartRates : [HrMeasurment];
    var firstName : String;
    var lastName : String;
    var goals : [Goal]
        
    init() {
        self.currWeight = 0
        self.goalWeight = 0
        self.weightMeasurements = [WtMeasurment]()
        self.heartRates = [HrMeasurment]()
        self.firstName = ""
        self.lastName = ""
        self.goals =  [Goal]()
    }
    
    // helper method to calculate the average heart rate for profile page label
    func calculateAvgHr() -> String {
        var sum : Int = 0
        for hr in heartRates { sum += hr.value(forKey: "value") as! Int }
        return String(sum/heartRates.count)
    }
    func setCurrWeight(currWeight : Int) { self.currWeight = currWeight }
    func setGoalWeight(goalWeight : Int) { self.goalWeight = goalWeight }
    
    
    func reloadWtAndHr(){
        var updated_wt = [WtMeasurment]()
        var updated_hr = [HrMeasurment]()
        
        do {
            updated_wt =
            try (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext.fetch(WtMeasurment.fetchRequest())
            updated_hr = try (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext.fetch(HrMeasurment.fetchRequest())
        } catch {
            print("couldnt fetch goals")
        }
        
        
    self.heartRates = updated_hr
    self.weightMeasurements = updated_wt
    }
    func addWeightMeasurement(measurement : Int) {
        let new_wt = NSEntityDescription.insertNewObject(forEntityName: "WtMeasurment", into: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
        new_wt.setValue(measurement, forKey: "value")
       
        
       (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        weightMeasurements.append(new_wt as! WtMeasurment)
        
    }
    func getWeightMeasurments() -> [WtMeasurment] {
        return weightMeasurements
    }
    func getHRMeasurments() -> [HrMeasurment] {
        return heartRates
    }
    func addHeartRates(hr : Int) {
        let new_hr = NSEntityDescription.insertNewObject(forEntityName: "HrMeasurment", into: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
        new_hr.setValue(hr, forKey: "value")
       (UIApplication.shared.delegate as! AppDelegate).saveContext()
        heartRates.append(new_hr as! HrMeasurment)
    }
    
    func setFirstName(name : String) { self.firstName = name }
    func setLastName(name : String) { self.lastName = name }
    
    func getGoal(index : Int) -> Goal {
        return goals[index]
    }
    
    func reloadGoals(){
            var updated_goals = [Goal]()
            do {
                updated_goals =
                try (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext.fetch(Goal.fetchRequest())
            } catch {
                print("couldnt fetch goals")
            }
        self.goals = updated_goals
    }
    
    func addGoal(title : String, date : Date) {
        let newGoal = NSEntityDescription.insertNewObject(forEntityName: "Goal", into: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
        newGoal.setValue(title, forKey: "title")
        newGoal.setValue(date, forKey: "date")
        
       (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        goals.append(newGoal as! Goal)
    }
    
}

