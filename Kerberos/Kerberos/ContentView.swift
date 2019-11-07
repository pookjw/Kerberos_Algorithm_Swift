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
            if self.enviromentClass.GTMode{
                Button(action: {self.enviromentClass.log += "\nGolden Ticket Feature: Coming Soon!"}){
                    Spacer()
                        .frame(width: 50)
                    Text("GT Mode")
                        .foregroundColor(Color.orange)
                    Image(systemName: "play.fill")
                        .foregroundColor(Color.orange)
                        .scaleEffect(1.5)
                }
            }
            else{
                Button(action: {
                    self.enviromentClass.log += "\n"
                    self.enviromentClass.log += "\nClient: \(self.enviromentClass.client_list[self.enviromentClass.selected_client].client_id.toString)"
                    self.enviromentClass.log += "\nServer: \(self.enviromentClass.selected_server)"
                    runKerberos(
                        servers: self.enviromentClass.server_list[self.enviromentClass.selected_server],
                        client: self.enviromentClass.client_list[self.enviromentClass.selected_client],
                        server_number: self.enviromentClass.selected_server,
                        timeout: Double(self.enviromentClass.timeout),
                        delay: UInt32(self.enviromentClass.delay),
                        log: &self.enviromentClass.log
                    )
                }
                    )
                {
                    Spacer()
                        .frame(width: 100)
                    Image(systemName: "play.fill")
                        .scaleEffect(1.5)
                }
            }
        }
    }
    
    var body: some View {
        NavigationView{
            VStack{
                Spacer()
                LogView()
                Spacer()
                    .frame(height: 20)
                Text("Selected Client: \(self.enviromentClass.client_list[self.enviromentClass.selected_client].client_id.toString)")
                if self.enviromentClass.GTMode{
                    Text("Selected Hacker: \(self.enviromentClass.client_list[self.enviromentClass.selected_hacker].client_id.toString)")
                }
                Text("Selected Server: \(self.enviromentClass.selected_server)")
                NavigationLink(destination: SettingView()){
                    Image(systemName: "gear")
                    Text("Settings...")
                }
                Spacer()
                    .frame(height: 20)
            }
            .padding([.leading, .trailing], 10.0)
            .navigationBarTitle("Kerberos")
            .navigationBarItems(trailing: navtigationBarButton)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
