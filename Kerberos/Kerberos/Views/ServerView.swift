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
    
    var sheetToggle: some View{
        Button(action: {self.enviromentClass.showSheet.toggle()}){
            Text("Show Data")
        }
    }
    
    var body: some View {
        List{
            ForEach(self.enviromentClass.server_list.keys.sorted(), id: \.self){ value in
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
        .navigationBarItems(trailing: sheetToggle)
        .sheet(isPresented: $enviromentClass.showSheet){
            SignedClientView()
                .environmentObject(self.enviromentClass)
        }
    }
}


struct SignedClientView: View{
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
                ForEach(self.enviromentClass.server_list.keys.sorted(), id: \.self){ value in
                    VStack(alignment: .leading){
                        HStack{
                            Text(String(value))
                                .fontWeight(.heavy)
                                .font(.system(size: 40))
                            Spacer()
                            Image(systemName: "plus")
                        }
                        ForEach(self.enviromentClass.server_list[value]!.as.client_id_list, id: \.self){ new_value in
                            Text(new_value.toString)
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Signed Client"))
            .navigationBarItems(trailing: sheetToggle)
        }
    }
}

struct ServerView_Previews: PreviewProvider {
    static var previews: some View {
        ServerView()
    }
}
