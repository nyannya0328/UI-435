//
//  TaskViewModel.swift
//  UI-434
//
//  Created by nyannyan0328 on 2022/01/24.
//

import SwiftUI

class TaskViewModel: ObservableObject {
    @Published var addNewTask : Bool = false
    @Published var editTask : Task?
    
    
    @Published var currentWeek : [Date] = []
    
    @Published var currentDay : Date = Date()
    
    @Published var isSheet : Bool = false
    @Published var url : URL?
    
    
    
    
    init() {
        
        fetchCurrentWeek()
        
        
    }
    
    func fetchCurrentWeek(){
        
        
        let calendar = Calendar.current
        
        let today = Date()
        
        
        let week = calendar.dateInterval(of: .weekOfMonth, for: today)
        
        
        guard let firstWeek = week?.start else{
            
            return
        }
        
        
        
        (0..<7).forEach { day in
            
            
            if let weekDay = calendar.date(byAdding: .day, value: day, to: firstWeek){
                
                
                currentWeek.append(weekDay)
            }
        }
        
        
        
    }
    
    
    func extracteDate(date : Date,formated : String)->String{
        
        
        let formatt = DateFormatter()
        
        formatt.dateFormat = formated
        
        return formatt.string(from: date)
        
        
    }
    
    func isToday(date : Date) -> Bool{
        
        
        let calendar = Calendar.current
        
        return calendar.isDate(currentDay, inSameDayAs: date)
        
        
        
    }
    
    
    func isCurrentHour(date : Date) -> Bool{
        
        
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        
        let currentHour = calendar.component(.hour, from: date)
        
        
        let isToday = calendar.isDateInToday(date)
        
        
       return (hour == currentHour && isToday)
        
        
    
        
        
        
        
    }
    
    
    
}


