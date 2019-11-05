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
            }
            .navigationBarTitle("Settings")
            .navigationBarItems(trailing: navigationBarButton)
        }
        
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
