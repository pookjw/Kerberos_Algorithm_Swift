//
//  SettingView.swift
//  Kerberos
//
//  Created by pook on 11/3/19.
//  Copyright © 2019 pookjw. All rights reserved.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject var enviromentClass: EnviromentClass
    @State var needRefresh: Bool = false
    
    var navigationBarButton: some View{
        HStack{
            Spacer()
                .frame(width: 50)
            Button(action: {self.enviromentClass.showSheet_1.toggle()}){
                Image(systemName: "xmark")
            }
        }
    }
    
    var body: some View {
        NavigationView{
            List{
                NavigationLink(destination: ClientView(needRefresh: self.$needRefresh)){
                    Text("Client List")
                }
                    .accentColor(self.needRefresh ? .white : .black)
                NavigationLink(destination: ServerView()){
                    Text("Server List")
                }
                NavigationLink(destination: wheelPicker(value: $enviromentClass.timeout, title: "Timeout")){
                    Text("Timeout")
                    Spacer()
                    Text(String(self.enviromentClass.timeout))
                        .foregroundColor(Color.gray)
                }
                NavigationLink(destination: wheelPicker(value: $enviromentClass.delay, title: "Delay")){
                    Text("Delay")
                    Spacer()
                    Text(String(self.enviromentClass.delay))
                        .foregroundColor(Color.gray)
                }
                Button(action: {self.enviromentClass.log = EnviromentClass.defaultLog}){
                    Text("Clear Log")
                        .foregroundColor(Color.red)
                }
                Button(action: {self.enviromentClass.logoutAllSessions()}){
                    Text("Logout All Sessions")
                        .foregroundColor(Color.red)
                }
            }
            .navigationBarTitle("Settings")
            .navigationBarItems(trailing: navigationBarButton)
        }
        
    }
}

struct wheelPicker: View{
    @Binding var value: Int
    var title: String
    
    var body: some View{
        Picker(selection: $value, label:
        Text("")){
            ForEach(0...500, id: \.self){ number in
                Text(String(number)).tag(number)
            }
        }
            .navigationBarTitle(title)
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
