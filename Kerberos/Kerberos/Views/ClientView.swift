//
//  ClientView.swift
//  Kerberos
//
//  Created by pook on 11/3/19.
//  Copyright © 2019 pookjw. All rights reserved.
//

import SwiftUI

struct ClientView: View {
    @EnvironmentObject var enviromentClass: EnviromentClass
    var addButton: some View{
        Button(action: {self.enviromentClass.add_client()}){
            Image(systemName: "plus")
        }
    }
    
    var body: some View {
        List{
            ForEach(self.enviromentClass.client_list.keys.sorted(), id: \.self){ value in
                HStack{
                    Button(action: {self.enviromentClass.selected_client = value}){
                        if self.enviromentClass.selected_client == value{
                            Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Color.blue)
                        }else{
                            Image(systemName: "circle")
                        }
                    }
                    Text(self.enviromentClass.client_list[value]!.client_id.toString)
                    Spacer()
                    Text(String(self.enviromentClass.client_list[value]!.success))
                        .foregroundColor(Color.gray)
                }
            }
        }
        .navigationBarTitle(Text("Client"))
        .navigationBarItems(trailing: addButton)
    }
}

struct ClientView_Previews: PreviewProvider {
    static var previews: some View {
        ClientView()
    }
}
