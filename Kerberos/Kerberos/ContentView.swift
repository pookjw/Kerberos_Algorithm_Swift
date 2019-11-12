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
            // When SBSMode (Step By Step) is off, show this button. This button runs all algoritgm.
            if !self.enviromentClass.SBSMode{
                // When GTMode (Golden Ticket Mode) is true(on), it shows yellow button on Navigation Bar. If not, shows blue button.
                if !self.enviromentClass.GTMode{
                    Button(action: { self.enviromentClass.return_code =
                        Kerberos(
                            servers: self.enviromentClass.server_list[self.enviromentClass.selected_server],
                            client: self.enviromentClass.client_list[self.enviromentClass.selected_client],
                            server_number: self.enviromentClass.selected_server,
                            timeout: Double(self.enviromentClass.timeout),
                            delay: UInt32(self.enviromentClass.delay)
                        ).run_all(log: &self.enviromentClass.log)
                        self.enviromentClass.showAlert = true
                    }
                        )
                    {
                        Spacer()
                            .frame(width: 100)
                        Image(systemName: "play.fill")
                            .foregroundColor(Color.blue)
                            .scaleEffect(1.5)
                    }
                } else {
                    Button(action: { self.enviromentClass.return_code =
                        Kerberos(
                            servers: self.enviromentClass.server_list[self.enviromentClass.selected_server],
                            client: self.enviromentClass.client_list[self.enviromentClass.selected_client],
                            hacker: self.enviromentClass.client_list[self.enviromentClass.selected_hacker],
                            server_number: self.enviromentClass.selected_server,
                            timeout: Double(self.enviromentClass.timeout),
                            delay: UInt32(self.enviromentClass.delay)
                        ).run_all(log: &self.enviromentClass.log)
                        self.enviromentClass.showAlert = true
                    }){
                        Spacer()
                            .frame(width: 100)
                        Image(systemName: "play.fill")
                            .foregroundColor(Color.orange)
                            .scaleEffect(1.5)
                    }
                }
            }
        }
    }
    
    // When running algorithm was done, will show this.
    var alert: Alert{
        Alert(title: Text("Result"),
              message: self.enviromentClass.return_code == 0 ? Text("Success!") : Text("Error! Check result log!"),
              dismissButton: .default(Text("Dismiss")
            )
        )
    }
    
    var body: some View {
        NavigationView{
            VStack{
                Spacer()
                LogView()
                if self.enviromentClass.SBSMode{
                    if !self.enviromentClass.GTMode{
                        StepListView(kerberos: Kerberos(
                            servers: self.enviromentClass.server_list[self.enviromentClass.selected_server],
                            client: self.enviromentClass.client_list[self.enviromentClass.selected_client],
                            server_number: self.enviromentClass.selected_server,
                            timeout: Double(self.enviromentClass.timeout),
                            delay: UInt32(self.enviromentClass.delay)
                            )
                        )
                            .frame(height: 200)
                    }else{
                        StepListView(kerberos:  Kerberos(
                            servers: self.enviromentClass.server_list[self.enviromentClass.selected_server],
                            client: self.enviromentClass.client_list[self.enviromentClass.selected_client],
                            hacker: self.enviromentClass.client_list[self.enviromentClass.selected_hacker],
                            server_number: self.enviromentClass.selected_server,
                            timeout: Double(self.enviromentClass.timeout),
                            delay: UInt32(self.enviromentClass.delay)
                            )
                        )
                            .frame(height: 200)
                    }
                }
                Spacer()
                    .frame(height: 10)
                
                if self.enviromentClass.GTMode{
                    Text("Golden Ticket Mode: (Enabled)")
                        .font(.system(size: 15))
                }else{
                    Text("Golden Ticket Mode: (Disabled)")
                        .font(.system(size: 15))
                }
                Text("Selected Client: \(self.enviromentClass.client_list[self.enviromentClass.selected_client].client_id.toString)")
                    .font(.system(size: 15))
                if self.enviromentClass.GTMode{
                    Text("Selected Hacker: \(self.enviromentClass.client_list[self.enviromentClass.selected_hacker].client_id.toString)")
                        .font(.system(size: 15))
                }
                Text("Selected Server: \(self.enviromentClass.selected_server)")
                    .font(.system(size: 15))
                
                NavigationLink(destination: SettingsView()){
                    Image(systemName: "gear")
                    Text("Settings...")
                }
                
                Spacer()
                    .frame(height: 20)
            }
            .navigationBarTitle(Text("Kerberos"))
            .navigationBarItems(trailing: navtigationBarButton)
            .alert(isPresented: $enviromentClass.showAlert, content: {self.alert})
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
