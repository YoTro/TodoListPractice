//
//  ToryunItem.swift
//  Toryun
//  For record the todo, remaind the user
//  Created by Jin on 2021/3/7.
//  Copyright © 2021 TORYUN. All rights reserved.
//

import SwiftUI
class Todo: NSObject, NSCoding, Identifiable {
    func encode(with coder: NSCoder) {
        //压缩继承的内容
        coder.encode(self.title, forKey: "title")
        coder.encode(self.dueDate, forKey: "dueDate")
        coder.encode(self.checked, forKey: "checked")
    }
    
    required init?(coder: NSCoder) {
        //解压缩该类
        self.title = coder.decodeObject(forKey: "title") as? String ?? ""
        self.dueDate = coder.decodeObject(forKey: "dueDate") as? Date ?? Date()
        self.checked = (coder.decodeObject(forKey: "checked") != nil)
    }
    
    var title: String = "" //代办事项标题
    var dueDate: Date = Date() //执行时间
    var checked: Bool = false //确认
    var i: Int = 0 //代办事项序号
    init(title: String, dueDate: Date){
        self.title = title
        self.dueDate = dueDate
    }
}

var emptyTodo: Todo = Todo(title: "", dueDate: Date())



struct ToryunItem: View {

    @ObservedObject var main: Main
    //显示Main类的数据
    @Binding var todoIndex: Int
    @State var checked: Bool = false //实时刷新所有用到的checked数据
    var body: some View {
        //定义界面
        HStack{
            Button(action: {
                editingMode = true
                editingTodo = self.main.todos[self.todoIndex]
                editingIndex = self.todoIndex
                self.main.detailsTitle = editingTodo.title
                self.main.detailsDueDate = editingTodo.dueDate
                self.main.detailsShowing = true
                detailsShouldUpdateTitle = true
                
            }){
                HStack{
                    VStack{
                        //边框蓝色修饰
                        Rectangle()
                            .fill(Color("theme"))
                            .frame(width: 8)
                    }
                    Spacer().frame(width: 10)
                    VStack{
                        Spacer().frame( height: 12 )
                        HStack{
                            Text(main.todos[todoIndex].title).font(Font.headline)
                                .foregroundColor(Color("todoItemTitle"))
                            Spacer()
                        }
                        Spacer()
                            .frame(height: 4)
                        HStack{
                            //日期
                            Image(systemName: "clock").resizable().frame(width: 12, height: 12)
                            Text(formatter.string(from: main.todos[todoIndex].dueDate)).font(.subheadline)
                            Spacer()
                        }.foregroundColor(Color("todoItemSubTitle"))
                        Spacer().frame(height: 12)
                    }


                }
            }
            Button(action: {
                self.main.todos[self.todoIndex].checked.toggle() //代办事项打勾
                self.checked = self.main.todos[self.todoIndex].checked
                do {
                    let archivedDate = try NSKeyedArchiver.archivedData(withRootObject: self.main.todos, requiringSecureCoding: false)
                    UserDefaults.standard.set(archivedDate, forKey: "todos")
                } //保存数据
                catch {
                    print("error")
                }
            }){
                HStack{
                    Spacer()
                    VStack{
                        Spacer()
                        Image(systemName: self.checked ? "checkmark.square.fill" : "square").resizable().frame(width: 24, height: 24).foregroundColor(.gray)
                        Spacer()
                    }
                    Spacer().frame(width: 12)
                }
                }.onAppear{
                    self.checked = self.main.todos[todoIndex].checked
                }
            }.background(Color(self.checked ? "todoItem-bg-checked" : "todoItem-bg")).animation(.spring())
        }
    }


struct ToryunItem_Previews: PreviewProvider {

    static var previews: some View {
        ToryunItem(main: Main(), todoIndex: .constant(0))
    }
}//预览窗口
