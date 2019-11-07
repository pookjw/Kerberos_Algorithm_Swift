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
                HStack{
                    Image(systemName: "person")
                        .foregroundColor(Color.blue)
                        .frame(width: 30)
                    Text("Client List")
                    Spacer()
                    Text(self.enviromentClass.client_list[self.enviromentClass.selected_client].client_id.toString)
                        .foregroundColor(Color.gray)
                }
            }
            .accentColor(self.needRefresh ? .white : .black)
            NavigationLink(destination: ServerView()){
                HStack{
                    Image(systemName: "cloud")
                        .foregroundColor(Color.blue)
                        .frame(width: 30)
                    Text("Server List")
                    Spacer()
                    Text("Server: \(self.enviromentClass.selected_server)")
                        .foregroundColor(Color.gray)
                }
            }
            NavigationLink(destination: GTView()){
                HStack{
                    Image(systemName: "doc.plaintext")
                        .foregroundColor(Color.orange)
                        .frame(width: 30)
                    Text("Golden Ticket")
                    Spacer()
                    if self.enviromentClass.GTMode{
                        Text(self.enviromentClass.client_list[self.enviromentClass.selected_hacker].client_id.toString)
                                .foregroundColor(Color.gray)
                    }else{
                        Text("(Disabled)")
                                .foregroundColor(Color.gray)
                    }
                }
                
            }
            NavigationLink(destination: wheelPicker(value: $enviromentClass.timeout, title: "Timeout")){
                HStack{
                    Image(systemName: "timer")
                        .foregroundColor(Color.blue)
                        .frame(width: 30)
                    Text("Timeout")
                    Spacer()
                    Text(String(self.enviromentClass.timeout))
                        .foregroundColor(Color.gray)
                }
            }
            NavigationLink(destination: wheelPicker(value: $enviromentClass.delay, title: "Delay")){
                HStack{
                    Image(systemName: "timelapse")
                        .foregroundColor(Color.blue)
                        .frame(width: 30)
                    Text("Delay")
                    Spacer()
                    Text(String(self.enviromentClass.delay))
                        .foregroundColor(Color.gray)
                }

            }
            Button(action: {self.enviromentClass.log = EnviromentClass.defaultLog}){
                Text("Clear Log")
                    .foregroundColor(Color.red)
            }
            Button(action: {self.enviromentClass.unauthorizeAllSessions()}){
                Text("Unauthorize All Sessions")
                    .foregroundColor(Color.red)
            }
        }
        .navigationBarTitle("Settings", displayMode: .inline)
    }
}

struct wheelPicker: View{
    @Binding var value: Int
    var title: String
    
    var body: some View{
        Picker(selection: $value, label:
        Text("")){
            ForEach(0...10, id: \.self){ number in
                Text(String(number)).tag(number)
            }
        }
        .padding(.horizontal, 99999999999.0)
            .navigationBarTitle(title)
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
