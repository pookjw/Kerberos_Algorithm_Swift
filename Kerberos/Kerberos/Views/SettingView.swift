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
    
    var body: some View {
        List{
            NavigationLink(destination: ClientView(needRefresh: self.$needRefresh)){
                Text("Client List")
            }
                .accentColor(self.needRefresh ? .white : .black)
            NavigationLink(destination: ServerView()){
                Text("Server List")
            }
        }
        .navigationBarTitle("Kerberos Settings", displayMode: .inline)
        
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
