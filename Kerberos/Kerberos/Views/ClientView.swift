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
    @Binding var needRefresh: Bool
    var navigationBarButton: some View{
        HStack{
            Button(action: {self.needRefresh.toggle()}){
                Spacer()
                    .frame(width: 50)
                Image(systemName: "arrow.clockwise")
            }
            Button(action: {self.enviromentClass.add_client()}){
                Spacer()
                    .frame(width: 25)
                Image(systemName: "plus")
            }
        }
    }
    
    var body: some View {
        List{
            ForEach(0..<self.enviromentClass.client_list.count, id: \.self){ value in
                HStack{
                    Button(action: {self.enviromentClass.selected_client = value}){
                        if self.enviromentClass.selected_client == value{
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(Color.blue)
                        }else{
                            Image(systemName: "circle")
                        }
                    }
                    Text(self.enviromentClass.client_list[value].client_id.toString)
                    Spacer()
                    if self.enviromentClass.client_list[value].success_server_list[self.enviromentClass.selected_server]!{
                        Image(systemName: "lock.open.fill")
                    }else{
                        Image(systemName: "lock.fill")
                    }
                    Text("(at: \(self.enviromentClass.selected_server))")
                }
            }
        }
        .navigationBarTitle(Text("Client"), displayMode: .inline)
        .navigationBarItems(trailing: navigationBarButton)
    }
}

