//
//  DynamicFilterdView.swift
//  UI-434
//
//  Created by nyannyan0328 on 2022/01/24.
//

import SwiftUI
import CoreData

struct DynamicFilterdView<Content : View,T>: View where T : NSManagedObject{
    
    
    @FetchRequest var request : FetchedResults<T>
    
    let content : (T) -> Content
    
    
    init(dateFilterd : Date,@ViewBuilder content : @escaping(T) -> Content){
        
        
        let calendar = Calendar.current
        
        let today = calendar.startOfDay(for: dateFilterd)
        
        let tommorrow = calendar.date(byAdding: .day, value: 1, to: today)!
        
        
        let filterKey = "taskDate"
        
        
        let predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@", argumentArray: [today,tommorrow])
        
        
        
        
        
        _request = FetchRequest(entity: T.entity(), sortDescriptors: [.init(keyPath: \Task.taskDate, ascending: false)], predicate: predicate, animation: nil)
      self.content = content
        
    }
    var body: some View {
        Group{
            
            if request.isEmpty{
                
                
                Text("Not Task")
                    .font(.largeTitle.weight(.heavy))
                    .foregroundColor(.black)
                    .offset(y: 100)
                
                
                
            }
            
            else{
                
                
                ForEach(request,id:\.objectID){object in
                    
                    
                    self.content(object)
                }
            }
        }
    }
}

