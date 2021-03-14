//
//  todoList.swift
//  Toryun
//
//  Created by Jin on 2021/3/8.
//  Copyright © 2021 TORYUN. All rights reserved.
//

import SwiftUI
var exampleTodos: [Todo] = [
    Todo(title: "擦地", dueDate: Date()),
    Todo(title: "洗澡", dueDate: Date()),
    Todo(title: "吃饭", dueDate: Date()),
    Todo(title: "跑步", dueDate: Date())
]

struct todoList: View {
    @ObservedObject var main: Main
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(main.todos) {
                    todo in VStack {
                        if todo.i == 0 || formatter.string(from: todo.dueDate) != formatter.string(from: self.main.todos[todo.i - 1].dueDate){
                            HStack{
                                Spacer().frame(width: 30)
                                Text(date2Word(date: todo.dueDate))
                                Spacer()
                            }
                        }
                        HStack{
                            Spacer().frame(width: 20)
                            ToryunItem(main: main, todoIndex: .constant(todo.i)).cornerRadius(10).clipped().shadow(color: Color(.gray), radius: 5)
                            Spacer().frame(width: 20)
                        }
                        Spacer().frame(height: 20)
                    }
                }
            
            }
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarTitle(Text("待办事项"))
            .onAppear{
                if let data = UserDefaults.standard.object(forKey: "todos") as? Data {
                    let todolist = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Todo] ?? []
                    for todo in todolist{
                        if !todo.checked{
                            self.main.todos.append(todo)
                    }
                }
                } else {
                    self.main.todos = exampleTodos
                    self.main.sort()
                }
                
            }
        }
        
    }
struct todoList_Previews: PreviewProvider {
 
        static var previews: some View {
            todoList(main: Main())
    }
}

}
