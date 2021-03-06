//
//  Home.swift
//  Canyou
//
//  Created by Zakaria Mosa on 2021-02-02.
//
import SwiftUI
import Firebase


struct Home: View {
    var db=Firestore.firestore()
    @State private var taskname : String = (Auth.auth().currentUser?.phoneNumber)!//"taskName"
    @State private var taskdetails : String = "taskDetails"
    @ObservedObject var tasks = Tasks()
    @ObservedObject var tasksIWillMake = Tasks()
    @State private var showingMyOwnTask = false
    @State private var showingAnotherPersonsTask = false
    @State private var goToTask = false

    @State private var selectedItem: String? = ""
    @State private var selectedAnotherItem: String? = ""
    @State var deviceDefaultPlace: Place = Place(name: "deviceDefaultPlace", latitude: 37.332331, longitude: -122.034)
    
    
    let locationManager = LocationManager()
    
    var body: some View {
        NavigationView{
            List(){
                ForEach(tasks.entries){task in
                    NavigationLink(destination: TheTaskView(showingMyOwnTask: $showingMyOwnTask, task: task, tasks: tasks, taskPlace: self.deviceDefaultPlace), tag: task.id!, selection: $selectedItem){
                        RowView(task: task).onTapGesture {
                            self.selectedItem = task.id
                            showingMyOwnTask = true
                        }
                        
                       
                  
                     
                    }
                    
                }.onDelete(perform: { indexSet in
                    delete(rowindex: indexSet)
                    tasks.entries.remove(atOffsets: indexSet)
                })
                
                
                
                ForEach(tasksIWillMake.entries){task in
                    NavigationLink(destination: ForeginTaskInfoView(showingAnotherPersonsTask: $showingAnotherPersonsTask, task: task), tag: task.id!, selection: $selectedAnotherItem){
                        RowView(task: task).onTapGesture {
                            self.selectedAnotherItem = task.id
                            showingAnotherPersonsTask = true
                        }
                        
                    }
                    
                }
                
                
                
            }
            .navigationBarItems(trailing: NavigationLink(destination: TheTaskView(showingMyOwnTask: $showingMyOwnTask,tasks: tasks, taskPlace: self.deviceDefaultPlace), isActive: $goToTask){
                Image(systemName: "plus.circle").font(.system(size: 30)).onTapGesture {
                    getLocation()
                    self.goToTask = true
                }
            })
  
            .onAppear(){
                readTasks()
                readTasksIWillMake()
                locationManager.askForPermission()
                
            }
            
            
            
            .navigationBarTitle("Home")
            
            
            .toolbar{
                ToolbarItem(placement: .bottomBar){
                    HStack{
                        
                        
                        Button(action: {
                            
                        }, label: {
                            NavigationLink(destination: Settings()){
                                //FirebaseImageViewSmall(imageURL: imageURL)
                                Image(systemName: "gearshape").font(.system(size: 50))
                                
                            }
                        })
                        Spacer()
                        
                        Button(action: {
                            
                            
                        }, label: {
                            NavigationLink(destination: SearchTasks()){
                                Image(systemName: "magnifyingglass.circle").font(.system(size: 50))
                                
                            }
                        })
                        Spacer()
                        
                        Button(action: {
                            
                            
                        }, label: {
                            NavigationLink(destination: History()){
                                Image(systemName: "clock").font(.system(size: 50))
                                
                            }
                        })
                        Spacer()
                        
                        
                    }
                }
            }
            
            
        }//.frame(width: 300, height: 700, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        
    }
    
    
    
    func getLocation(){
       
        if let location = locationManager.location {
            let taskPlace = Place(name: "Task Location", latitude: location.latitude, longitude: location.longitude)
            self.deviceDefaultPlace = taskPlace
            print("self.deviceDefaultPlace \(self.deviceDefaultPlace)")
        }else{
            //locationManager.askForPermission()
            //getLocation()
        }
        
        
        
    }
    
    
    
    func delete(rowindex: IndexSet){
        
        
        rowindex.forEach{(i) in
            print("\(String(tasks.entries[i].id!))")
            do{
                _ = try db.collection("Tasks").document("\(String(tasks.entries[i].id!))").delete()
            }catch{
                print("Print error saving to DB")
            }
        }
        
        readTasks()
        //taskname=""
        //taskdetails=""
        
    }
    func readTasks(){
            
        db.collection("Tasks").whereField("taskowneruid", isEqualTo: (Auth.auth().currentUser?.uid)!).whereField("done", isEqualTo: false).addSnapshotListener{(snabshot,err) in
                if let err=err{
                    print("Error getting document\(err)")
                }else{
                    
                    
                    
                    tasks.entries.removeAll()
                    for document in snabshot!.documents{
                        let result = Result {
                            try document.data(as: Task.self)
                        }
                        switch result{
                        case .success(let task):
                            if let task = task{
                                tasks.entries.append(task)
                                //print("\(task)")
                            }else{
                                print("Document does not exists")
                            }
                        case .failure(let error):
                            print("Error decoding Task \(error)")
                        }
                    }
                    
                }
                
            }
            
            
        }
    
    func readTasksIWillMake(){
            
            db.collection("Tasks").whereField("taskowneruid", isNotEqualTo: (Auth.auth().currentUser?.uid)!).whereField("done", isEqualTo: false).addSnapshotListener{(snabshot,err) in
                if let err=err{
                    print("Error getting document\(err)")
                }else{
                    
                    
                    
                    tasksIWillMake.entries.removeAll()
                    for document in snabshot!.documents{
                        let result = Result {
                            try document.data(as: Task.self)
                        }
                        switch result{
                        case .success(let task):
                            if let tsk = task{
                                //check if I gave an accepted offer to this task
                                
                                
                                db.collection("TasksOffers").whereField("taskid", isEqualTo: tsk.id).whereField("taskofferaccepted", isEqualTo: true).whereField("taskofferowneruid", isEqualTo: (Auth.auth().currentUser?.uid)!).addSnapshotListener{(snabshot,err) in
                                    if let err=err{
                                        print("Error getting document\(err)")
                                    }else{
                                        
                                        
                                        var taskofferexists: Bool = false
                                        
                                        for document in snabshot!.documents{
                                            let result = Result {
                                                try document.data(as: TaskOffer.self)
                                            }
                                            switch result{
                                            case .success(let taskoffer):
                                                if let tskoffer = taskoffer{
                                                    //check if I gave an accepted offer to this task
                                                    for singelTaskOffer in tasksIWillMake.entries {
                                                        if singelTaskOffer.id == tskoffer.taskid {
                                                            taskofferexists = true
                                                        }
                                                    }
                                                    if !taskofferexists {
                                                        tasksIWillMake.entries.append(tsk)
                                                    }
                                                    /*if !tasksIWillMake.entries.contains(tsk) {
                                                        tasksIWillMake.entries.append(tsk)
                                                    }*/
                                                    
                                                    //print("\(task)")
                                                }else{
                                                    print("Document does not exists")
                                                }
                                            case .failure(let error):
                                                print("Error decoding Task \(error)")
                                            }
                                        }
                                        
                                    }
                                    
                                }
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                //print("\(task)")
                            }else{
                                print("Document does not exists")
                            }
                        case .failure(let error):
                            print("Error decoding Task \(error)")
                        }
                    }
                    
                }
                
            }
            
            
        }
        
        
        
        
        
        
        
        
    }

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

struct RowView : View {
    var db=Firestore.firestore()
    var task : Task
    @State private var thistaskhasoffers : Bool = false
    @State  var taskstatus = TaskStatus.taskinitializedbuthasnotoffers
    @State var TaskUser : String = "hhhh"

  
    
    var body: some View {
        HStack{
            Text(task.taskname)
            Spacer()
            Text(TaskUser)
            Spacer()
            
            //Image(systemName: thistaskhasoffers ? "exclamationmark.bubble":"bubble.left" ).font(.system(size: 30))
            switch taskstatus{
            case TaskStatus.taskhasoffersbutnoofferaccepted:
                Image(systemName: "exclamationmark.bubble" ).font(.system(size: 30))
            case TaskStatus.taskinprogress:
                Image(systemName: "eyes" ).font(.system(size: 30))
            default:
                Image(systemName: "bubble.left" ).font(.system(size: 30))
            }
            
            
            /*Image(systemName: task.done ? "checkmark.square" : "square")
            Button(action: {
             if let id=task.id{
             db.collection("Tasks").document(id).updateData(["done" : !task.done])
             //readTasks()
             }
             }, label: {
             Image(systemName: task.done ? "checkmark.square" : "square")
             })*/
        }.onAppear{
            doesthistaskhasoffers(taskid: task.id!)
            doesthistaskhasacceptedoffers(taskid: task.id!)
            print("\(taskstatus)")
            getUserById(userid: task.taskowneruid)
        }
    }
    
    func doesthistaskhasoffers(taskid: String) {
        
        db.collection("TasksOffers").whereField("taskid", isEqualTo: taskid).addSnapshotListener{(snabshot,err) in
            if let err=err{
                print("Error getting document\(err)")
            }else{
                
                
                
                
                for document in snabshot!.documents{
                    let result = Result {
                        try document.data(as: TaskOffer.self)
                    }
                    switch result{
                    case .success(let taskOffer):
                        if let taskOffer = taskOffer{
                            thistaskhasoffers = true
                            taskstatus = TaskStatus.taskhasoffersbutnoofferaccepted
                            print("if \(taskstatus)")
                        }else{
                            thistaskhasoffers = false
                            taskstatus = TaskStatus.taskinitializedbuthasnotoffers
                            print("else \(taskstatus)")
                        }
                    case .failure(let error):
                        print("Error decoding Task \(error)")
                    }
                }
                
            }
            
        }
         
       
    }
    
    
    func doesthistaskhasacceptedoffers(taskid: String) {
        
        db.collection("TasksOffers").whereField("taskid", isEqualTo: taskid).whereField("taskofferaccepted", isEqualTo: true).addSnapshotListener{(snabshot,err) in
            if let err=err{
                print("Error getting document\(err)")
            }else{
                
                
                
                
                for document in snabshot!.documents{
                    let result = Result {
                        try document.data(as: TaskOffer.self)
                    }
                    switch result{
                    case .success(let taskOffer):
                        if let taskOffer = taskOffer{
                            thistaskhasoffers = true
                            taskstatus = TaskStatus.taskinprogress
                            print("if \(taskstatus)")
                        }else{
                            thistaskhasoffers = false
                            taskstatus = TaskStatus.taskinitializedbuthasnotoffers
                            print("else \(taskstatus)")
                        }
                    case .failure(let error):
                        print("Error decoding Task \(error)")
                    }
                }
                
            }
            
        }
         
       
    }
    
    func getUserById(userid: String){
        
        
        
        db.collection("Users").whereField("userid", isEqualTo: userid).addSnapshotListener{(snabshot,err) in
            if let err=err{
                print("Error getting document\(err)")
            }else{
                
                
                
                
                for document in snabshot!.documents{
                    let result = Result {
                        try document.data(as: User.self)
                    }
                    switch result{
                    case .success(let user):
                        if let usr = user{
                            TaskUser = usr.firstname
                        }else{
                            print("Document does not exists")
                        }
                    case .failure(let error):
                        print("Error decoding Task \(error)")
                    }
                }
                
            }
            
        }
        
      
    }
    
    
}
