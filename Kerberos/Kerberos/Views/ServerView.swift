//
//  ServerView.swift
//  Kerberos
//
//  Created by pook on 11/3/19.
//  Copyright © 2019 pookjw. All rights reserved.
//

import SwiftUI

struct ServerView: View {
    @EnvironmentObject var enviromentClass: EnviromentClass
    
    var navtigationBarButton: some View{
        HStack{
            Button(action: {self.enviromentClass.showSheet.toggle()}){
                Image(systemName: "pencil")
            }
            Button(action: {self.enviromentClass.add_server()}){
                Image(systemName: "plus")
            }
        }
            .scaleEffect(1.5)
    }
    
    var body: some View {
        List{
            ForEach(0..<self.enviromentClass.server_list.count, id: \.self){ value in
                HStack{
                    Button(action: {self.enviromentClass.selected_server = value}){
                        if self.enviromentClass.selected_server == value{
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(Color.blue)
                        }else{
                            Image(systemName: "circle")
                        }
                    }
                    Text(String(value))
                    Spacer()
                }
                
            }
        }
        .navigationBarTitle(Text("Server"))
        .navigationBarItems(trailing: navtigationBarButton)
        .sheet(isPresented: $enviromentClass.showSheet){
            EditView()
                .environmentObject(self.enviromentClass)
        }
    }
}


struct EditView: View{
    @EnvironmentObject var enviromentClass: EnviromentClass
    var server_number: Int = 0
    
    var sheetToggle: some View{
        Button(action: {self.enviromentClass.showSheet.toggle()}){
            Image(systemName: "xmark")
        }
    }
    
    var body: some View{
        NavigationView{
            List{
                ForEach(0..<self.enviromentClass.server_list.count, id: \.self){ value in
                    NavigationLink(destination: SignedClientView(server_number: value)){
                        Text("Server \(value)")
                    }
                }
            }
            .navigationBarTitle(Text("Edit Client Server"))
            .navigationBarItems(trailing: sheetToggle)
        }
    }
}

struct SignedClientView: View{
    @EnvironmentObject var enviromentClass: EnviromentClass
    var server_number: Int
    var body: some View{
        List{
            ForEach(0..<self.enviromentClass.server_list[server_number].as.client_id_list.count, id: \.self){ value in
                Text(self.enviromentClass.server_list[self.server_number].as.client_id_list[value].toString)
            }
            NavigationLink(destination: ClientListView(server_number: server_number)){
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(Color.green)
                Text("Add item...")
                Spacer()
            }
        }
        .navigationBarTitle(Text("\(server_number)"), displayMode: .inline)
    }
}

struct ClientListView: View{
    @EnvironmentObject var enviromentClass: EnviromentClass
    var server_number: Int
    var body: some View{
        List{
            ForEach(0..<self.enviromentClass.client_list.count, id: \.self){ value in
                Button(action: {
                    self.enviromentClass.server_list[self.server_number].as.signUp(client: self.enviromentClass.client_list[value])
                }){
                    HStack{
                        if self.enviromentClass.server_list[self.server_number].as.client_id_list.contains(self.enviromentClass.client_list[value].client_id){
                        Text(self.enviromentClass.client_list[value].client_id.toString)
                            .foregroundColor(Color.gray)
                        Spacer()
                        Text("Signed")
                            .foregroundColor(Color.gray)
                        }else{
                            Text(self.enviromentClass.client_list[value].client_id.toString)
                        }
                    }
                }
            }
        }
        .navigationBarTitle(Text("Add Client"))
    }
}

struct ServerView_Previews: PreviewProvider {
    static var previews: some View {
        ServerView()
    }
}
