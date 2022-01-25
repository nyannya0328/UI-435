//
//  NewTaskView.swift
//  UI-434
//
//  Created by nyannyan0328 on 2022/01/24.
//

import SwiftUI

struct NewTaskView: View {
    @EnvironmentObject var model : TaskViewModel
    
    @State var taskTilte : String = ""
    @State var taskDescription : String = ""
    @State var taskDate : Date = Date()
    
    
    @Environment(\.dismiss) var dissmiss
    
    @Environment(\.managedObjectContext) var context
    var body: some View {
        NavigationView{
            

                
                
                List{
                    
                    
                    Section {
                        
                        
                        TextField("Enter Task", text: $taskTilte)
                        
                        
                    } header: {
                        
                        
                        Text("Task Title")
                    }
                    
                    Section {
                        
                        
                        TextField("Nothing", text: $taskDescription)
                        
                        
                    } header: {
                        
                        
                        Text("Task Description")
                    }
                    
                    
                    if model.editTask == nil{
                        
                        
                        
                        Section {
                            
                            DatePicker("", selection: $taskDate)
                                .datePickerStyle(.graphical)
                                .labelsHidden()
                        } header: {
                            
                            Text("Chose Date")
                            
                            
                        }

                        
                    }
                    
                    
                    
                    


                    
                    
                }
                .listStyle(.insetGrouped)
                .navigationTitle(taskTilte == "" ? "ADD New Task View" : taskTilte)
                .navigationBarTitleDisplayMode(.inline)
                .interactiveDismissDisabled()
                .toolbar {
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        
                        
                        Button {
                            
                            if let task = model.editTask{
                                
                                task.taskTitle = taskTilte
                                task.taskDescription = taskDescription
                                
                                
                            }
                            
                            else{
                                
                                
                                let task = Task(context: context)
                                
                                
                                task.taskTitle = taskTilte
                                task.taskDescription = taskDescription
                                task.taskDate = taskDate
                                
                                
                                
                                
                                
                            }
                            
                            try? context.save()
                            dissmiss()
                            
                        } label: {
                            
                            
                            Text("SAVE")
                                
                            
                            
                        }

                        
                    }
                    
                    
                    ToolbarItem(placement: .navigationBarLeading) {
                        
                        
                        Button {
                            
                            dissmiss()
                            
                            
                        } label: {
                            
                            
                            Text("Cancel")
                                .font(.system(size: 15, weight: .bold))
                            
                            
                            
                        }

                        
                    }
                    
                    
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        
                        
                        Button {
                            
                            
                            exportPDF {
                                self
                                    .environmentObject(model)
                            } cometion: { staus, url in
                                if let url = url,staus{
                                    
                                    model.url = url
                                    model.isSheet.toggle()
                                    
                                    
                                }
                            }

                            
                        } label: {
                            
                            Image(systemName: "square.and.arrow.up.fill")
                                .font(.title3)
                                .foregroundColor(.black)
                            
                        }

                    }
                    
                    
                }
                .onAppear {
                    
                    
                    
                    if let task = model.editTask{
                        
                        
                        taskTilte = task.taskTitle ?? ""
                        taskDescription = task.taskDescription ?? ""
                    }
                }
                .sheet(isPresented: $model.isSheet) {
                    
                    model.url = nil
                } content: {
                    
                    
                    if let url = model.url{
                        
                        
                        sheetView(ursl: [url])
                    }
                }

                
                
      
            
        }
    }
}

struct NewTaskView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct sheetView : UIViewControllerRepresentable{
    
    var ursl : [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        
        
        let viewController = UIActivityViewController(activityItems: ursl, applicationActivities: nil)
        
        
        
        return viewController
        
        
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        
        
    }
}
