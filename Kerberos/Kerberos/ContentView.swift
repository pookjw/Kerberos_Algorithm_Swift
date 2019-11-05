//
//  ContentView.swift
//  Kerberos
//
//  Created by pook on 11/3/19.
//  Copyright © 2019 pookjw. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var enviromentClass: EnviromentClass
    
    var navtigationBarButton: some View{
        HStack{
            Button(action: {self.enviromentClass.showSheet_1.toggle()}){
                Spacer()
                    .frame(width: 50)
                Image(systemName: "gear")
            }
            Button(action: {
                self.enviromentClass.log += "\n"
                self.enviromentClass.log += "\nClient: \(self.enviromentClass.client_list[self.enviromentClass.selected_client].client_id.toString)"
                self.enviromentClass.log += "\nServer: \(self.enviromentClass.selected_server)"
                runKerberos(
                    servers: self.enviromentClass.server_list[self.enviromentClass.selected_server],
                    client: self.enviromentClass.client_list[self.enviromentClass.selected_client],
                    server_number: self.enviromentClass.selected_server,
                    log: &self.enviromentClass.log
                )
            }
                )
            {
                Spacer()
                    .frame(width: 25)
                Image(systemName: "play.fill")
                    .foregroundColor(Color.red)
                    .scaleEffect(1.5)
            }
        }
    }
    
    var body: some View {
        NavigationView{
            VStack{
                Spacer()
                LogView()
                Spacer()
                    .frame(height: 30)
                Text("Selected Client: \(self.enviromentClass.client_list[self.enviromentClass.selected_client].client_id.toString)")
                Text("Selected Server: \(self.enviromentClass.selected_server)")
                Spacer()
                    .frame(height: 30)
            }
            .padding([.leading, .trailing], 10.0)
            .navigationBarTitle("Kerberos")
            .navigationBarItems(trailing: navtigationBarButton)
            .sheet(isPresented: $enviromentClass.showSheet_1){
                SettingView()
                    .environmentObject(self.enviromentClass)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
