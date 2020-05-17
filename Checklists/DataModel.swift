//
//  DataModel.swift
//  Checklists
//
//  Created by Buck Rozelle on 5/15/20.
//  Copyright © 2020 buckrozelledotcomLLC. All rights reserved.
//

import Foundation

class DataModel {
    var lists = [Checklist]()
    
    //computer property
    var indexOfSelectedChecklist: Int {
        get {
            return UserDefaults.standard.integer(forKey: "ChecklistIndex")
        }
        set {
            UserDefaults.standard.set(newValue,
                                      forKey: "ChecklistIndex")
        }
    }
    
    init() {
        loadChecklists()
        registerDefaults()
        handleFirstTime()
    }
    
    //Sets default values for user defaults
    func registerDefaults() {
        let dictionary = [ "ChecklistIndex": -1, "FirstTime": true] as [String : Any]
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    //first time running the app
    func handleFirstTime() {
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        
        if firstTime {
            let checklist = Checklist(name: "List")
            lists.append(checklist)
            
            indexOfSelectedChecklist = 0
            userDefaults.set(false, forKey: "FirstTime")
            userDefaults.synchronize()
        }
    }
    
    //MARK:- Data Saving
    //gets the full path to the documents folder
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory,
                                             in: .userDomainMask)
        return paths[0]
    }
    
    //Uses documentsDirectory to construct the full path to the Checklists.plist file.
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    //sorting the checklists
    func sortChecklists() {
        lists.sort(by: { list1, list2 in
            return list1.name.localizedStandardCompare(list2.name) == .orderedAscending
        })
    }
    
    func saveChecklists() {
        //Create an instance of PropertyListEncoder
        let encoder = PropertyListEncoder()
        
        //Sets up a block to catch errors.
        do {
            //try to encode the lists array.
            let data = try encoder.encode(lists)
            //if the constant was created then write the data to a file.
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
            //execute if an error was thrown.
        } catch {
            //print the error.
            print("Error encoding item array: \(error.localizedDescription)")
        }
        
    }
    
    func loadChecklists() {
        //put the results dataFilePath in a temp constant.
        let path = dataFilePath()
        //try to load the contents of Checklists.plist into a new data object
        if let data = try? Data(contentsOf: path) {
            //load the entire array its contents
            let decoder = PropertyListDecoder()
            
            do {
                //load the saved data back into items
                lists = try decoder.decode([Checklist].self, from: data)
                //and sorts them
                sortChecklists()
            } catch {
                //if there was an error, print it in the console.
                print("Error decoding item array:  \(error.localizedDescription)")
            }
        }
    }
}
