//
//  TodoDetails.swift
//  Toryun
//
//  Created by Jin on 2021/3/11.
//  Copyright © 2021 TORYUN. All rights reserved.
//

import SwiftUI

struct TodoDetails: View {
    @ObservedObject var main: Main
    var body: some View {
        
        VStack{
            HStack{
                let keyWindow = UIApplication.shared.connectedScenes
                        .filter({$0.activationState == .foregroundActive})
                        .map({$0 as? UIWindowScene})
                        .compactMap({$0})
                        .first?.windows
                        .filter({$0.isKeyWindow}).first
                Button(action:{
                    keyWindow?.endEditing(true)
                    self.main.detailsShowing = false
                }){
                    Text("取消").padding()
                }
                Spacer()
                Button(action: {
                    keyWindow?.endEditing(true)
                    if editingMode {
                        self.main.todos[editingIndex].title = self.main.detailsTitle
                        self.main.todos[editingIndex].dueDate = self.main.detailsDueDate
                    } else {
                        let newTodo = Todo(title: self.main.detailsTitle, dueDate: self.main.detailsDueDate)
                        newTodo.i = self.main.todos.count
                        self.main.todos.append(newTodo)
                        
                    }
                    self.main.sort()
                    do {
                        let archivedDate = try NSKeyedArchiver.archivedData(withRootObject: self.main.todos, requiringSecureCoding: false)
                        UserDefaults.standard.set(archivedDate, forKey: "todos")
                    } //保存数据
                    catch {
                        print("error")
                    }
                    self.main.detailsShowing = false
                }){
                    Text(editingMode ? "完成" : "添加").padding()
                }.disabled(main.detailsTitle == "")
            }
            SATextField(tag: 0, text: editingTodo.title, placeholder: "你说你是谁?", changeHandler: {
                (newString) in self.main.detailsTitle = newString
            }){}
                .padding(8).foregroundColor(.white)
                DatePicker(selection: $main.detailsDueDate, displayedComponents: .date, label: { () -> EmptyView in })
                    .padding()
                Spacer()
        }
        .padding()
        .background(Color("todoDetails-bg"))
        .edgesIgnoringSafeArea(.all)

    }
}

struct TodoDetails_Previews: PreviewProvider {
    static var previews: some View {
        TodoDetails(main: Main())
    }
}
