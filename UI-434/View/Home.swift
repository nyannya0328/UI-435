//
//  Home.swift
//  UI-434
//
//  Created by nyannyan0328 on 2022/01/24.
//

import SwiftUI

struct Home: View {
    
    @StateObject var model = TaskViewModel()
    
    @Environment(\.managedObjectContext) var context
    
    @Environment(\.editMode) var editMode
    @Namespace var animation
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            
            
            Section {
                
                
                
                ScrollView(.horizontal, showsIndicators: false) {
                    
                    
                    HStack(spacing:30){
                        
                        
                        ForEach(model.currentWeek,id:\.self){day in
                            
                            
                            VStack(spacing:10){
                                
                                
                                Text(model.extracteDate(date: day, formated: "dd"))
                                
                                Text(model.extracteDate(date: day, formated: "EEE"))
                                
                                
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 5, height: 5)
                                    .opacity(model.isToday(date: day) ? 1 : 0)
                                
                            }
                            .foregroundStyle(model.isToday(date: day) ? .secondary : .primary)
                            .foregroundColor(model.isToday(date: day) ? .white : .black)
                            .background(
                            
                            
                                ZStack{
                                    
                                    if model.isToday(date: day){
                                        
                                        
                                        Capsule()
                                            .fill(.black)
                                            .frame(width: 45, height: 90)
                                    }
                                    
                                    
                                    
                                }
                            
                            )
                            .contentShape(Capsule())
                            .onTapGesture {
                                
                                
                                withAnimation{
                                    
                                    
                                    model.currentDay = day
                                }
                            }
                            
                        }
                    }
                    .padding()
                    .padding(.horizontal)
                    
                    
                }
                
                
                TaskView()
                
            } header: {
                
                
                HeaderView()
                
                
            }

        }
        .overlay(
        
            Button(action: {
                
                withAnimation{
                    
                    model.addNewTask.toggle()
                }
                
            }, label: {
                
                Image(systemName: "plus")
                    .font(.title)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.black,in: Circle())
            })
                .padding()
            
            ,alignment: .bottomTrailing
        
        )
        .sheet(isPresented: $model.addNewTask) {
            
            model.editTask = nil
        } content: {
            
            
            NewTaskView()
                .environmentObject(model)
            
            
            
        }

    }
    
    @ViewBuilder
    func TaskCardView(task : Task)-> some View{
        
        
        
        HStack(alignment: editMode?.wrappedValue == .active ? .center : .top, spacing: 10) {
            
            
            if editMode?.wrappedValue == .active{
                
                
                
                VStack(spacing:15){
                    
                    
                    if task.taskDate?.compare(Date()) == .orderedAscending || Calendar.current.isDateInToday(task.taskDate ?? Date()){
                        
                        
                        Button {
                            
                            
                            model.editTask = task
                            model.addNewTask.toggle()
                            
                        } label: {
                            
                            
                            Image(systemName: "pencil.circle.fill")
                            
                        }
                        
                        
                        
                        Button {
                            
                            context.delete(task)
                            try? context.save()
                            
                        } label: {
                            
                            
                            Image(systemName: "minus.circle.fill")
                            
                            
                        }
                        
                        
                        
                    }
                    
                    
                
                    
                    
                    

                }
                
                
            }
            else{
                
                
                VStack(spacing:10){
                    
                    
                    Circle()
                        .fill(model.isCurrentHour(date: task.taskDate ?? Date()) ? (task.isCompeted ? .green : .black) : .clear)
                        .frame(width: 10, height: 10)
                        .background(
                        
                        Circle()
                            .stroke(.black,lineWidth: 1)
                            .padding(-3)
                            .scaleEffect(!model.isCurrentHour(date: task.taskDate ?? Date()) ? 0.8 : 1)
                        
                        
                        
                        
                        
                        )
                    
                    
                    Rectangle()
                        .fill(.black)
                        .frame(width: 3)
                    
                        
                    
                    
                }
            }
            
            
            VStack{
                
                
                HStack(alignment: .top, spacing: 15) {
                    
                    
                    VStack(alignment: .leading, spacing: 19) {
                        
                        
                        
                        
                        Text(task.taskTitle ?? "")
                            .font(.system(size: 15, weight: .bold))
                        
                        
                        Text(task.taskDescription ?? "")
                            .font(.system(size: 15, weight: .bold))
                        
                        
                        
                    }
                    .Hleading()
                    
                    
                    Text(task.taskDate?.formatted(date: .abbreviated, time: .omitted) ?? "")
                    
                    
                    
                }
                
                if model.isCurrentHour(date: task.taskDate ?? Date()){
                    
                    
                    HStack(spacing:15){
                        
                        
                        if !task.isCompeted{
                            
                            Button {
                                
                                task.isCompeted = true
                                try? context.save()
                                
                            } label: {
                                
                                
                                Image(systemName: "checkmark")
                                    .font(.title)
                                    .foregroundColor(.black)
                                    .padding(14)
                                    .background(Color.white,in: RoundedRectangle(cornerRadius: 10))
                                
                                
                                
                            }

                            
                            
                        }
                        
                        
                    }
                    .Hleading()
                }
                
                
                Text(task.isCompeted ? "Marked as Completed" : "Mark Task as Completed")
                    .font(.system(size: task.isCompeted ? 15 : 16, weight: .light))
                    .foregroundColor(task.isCompeted ? .gray : .white)
                    .Hleading()
                
                
            }
            .foregroundColor(model.isCurrentHour(date: task.taskDate ?? Date()) ? .white : .black)
            .padding(model.isCurrentHour(date: task.taskDate ?? Date()) ? 15 : 0)
            .padding(.bottom,model.isCurrentHour(date: task.taskDate ?? Date()) ? 0 : 10)
            .Hleading()
            .background(Color.black
            
                            .cornerRadius(20)
                            .opacity(model.isCurrentHour(date: task.taskDate ?? Date()) ? 1 : 0)
            
            )
            
            
            
        }
        .padding()
        
        
        
        
    }
    
    @ViewBuilder
    func TaskView() -> some View{
        
        
        LazyVStack(spacing:15){
            
            
            DynamicFilterdView(dateFilterd: model.currentDay) { (object : Task) in
                
                
                
                TaskCardView(task: object)
                
            }
            
            
        }
        
    }
    
    
    
    @ViewBuilder
    func HeaderView()->some View{
        
        
        HStack{
            
            
            VStack(alignment: .leading, spacing: 15) {
                
                
                
                Text(Date().formatted(date: .abbreviated, time: .omitted))
                    .font(.title3.weight(.bold))
                
                
                
                Text("Today")
                    .font(.title3.weight(.semibold))
                    .foregroundColor(.gray)
                
                
                
            }
            .Hleading()
            
            
        EditButton()
            
            
        }
        .padding()
        
        
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}


