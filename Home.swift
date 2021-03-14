//
//  Home.swift
//  Toryun
//
//  Created by Jin on 2021/3/7.
//  Copyright © 2021 TORYUN. All rights reserved.
//

import SwiftUI

//全局变量
var editingMode: Bool = false //表示用户是否正在编辑代表事项
var editingTodo: Todo = emptyTodo //表示用户正在编辑的代办事项是什么
var editingIndex: Int = 0 //表示用户正在编辑代办事项列表中的第几个代办事项
var detailsShouldUpdateTitle: Bool = false //表示是否更新代办事项


class Main: ObservableObject{
    @Published var todos: [Todo] = [] //实时更新首页代办事项列表
    @Published var detailsShowing: Bool = false //表示是否弹出编辑代办事项
    @Published var detailsTitle: String = "" //代办事项标题文本框
    @Published var detailsDueDate: Date = Date() //代办事项执行时间
    func sort(){
        //排序代办事项
        self.todos.sort(by: {$0.dueDate.timeIntervalSince1970 < $1.dueDate.timeIntervalSince1970})
        for i in 0 ..< self.todos.count{
            self.todos[i].i = i
        }
    }
    
}
struct Home: View {
    @ObservedObject var main: Main
    var body: some View {
        ZStack {
            todoList(main: main)
            Button(action: {
                editingMode = false
                editingTodo = emptyTodo
                detailsShouldUpdateTitle = true
                self.main.detailsTitle = ""
                self.main.detailsDueDate = Date()
                self.main.detailsShowing = true
                
            }){
                    btnAdd()
                }.offset(x: UIScreen.main.bounds.width/2 - 60, y: UIScreen.main.bounds.height/2 - 80)
                TodoDetails(main: main).offset(x: 0, y: main.detailsShowing ? 0 : UIScreen.main.bounds.height)
            }
        }
}
struct btnAdd: View{
    var size: CGFloat = 65.0
    var body: some View{
        ZStack{
            Group{
                Circle().fill(Color("btnAdd-bg"))
            }.frame(width: self.size, height: self.size)
            .shadow(color: Color("btnAdd-shadow"), radius: 10)
            Group{
                Image(systemName: "plus.circle.fill").resizable().frame(width: self.size, height: self.size)
                    .foregroundColor(Color("theme"))
            }
        }
    }
}
struct Home_Previews: PreviewProvider {
    @available(iOS 13.0.0, *)
    static var previews: some View {
        Home(main: Main())
            .previewDevice("iPhone 12")
    }
}
