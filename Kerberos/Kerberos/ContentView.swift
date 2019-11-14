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
            // When SBS (Step By Step) Mode is off, show this button. This button runs all algoritgm.
            // Kerberos(...).run_all(log:)
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
    
    // When running algorithm was done, will show this. returned 0 value is Success, 1 is Error.
    var alert: Alert{
        Alert(title: Text("Result"),
              message: self.enviromentClass.return_code == 0 ? Text("Success!") : Text("Error! Check result log!"),
              dismissButton: .default(Text("Dismiss")
            )
        )
    }
    
    // Body
    var body: some View {
        NavigationView{
            VStack{
                Spacer()
                LogView()
                
                // If SBS (Step By Step) is On or Off.
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
                            .frame(height: 300)
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
                            .frame(height: 300)
                    }
                }
                Spacer()
                    .frame(height: 10)
                
                // Show GT (Golden Ticket) Mode status
                if self.enviromentClass.GTMode{
                    Text("Golden Ticket Mode: (Enabled)")
                        .font(.system(size: 15))
                }else{
                    Text("Golden Ticket Mode: (Disabled)")
                        .font(.system(size: 15))
                }
                
                // Show Selected Client
                Text("Selected Client: \(self.enviromentClass.client_list[self.enviromentClass.selected_client].client_id.toString)")
                    .font(.system(size: 15))
                
                // Show Selected Hacker when GT Mode is enabled
                if self.enviromentClass.GTMode{
                    Text("Selected Hacker: \(self.enviromentClass.client_list[self.enviromentClass.selected_hacker].client_id.toString)")
                        .font(.system(size: 15))
                }
                
                // Show Selected Server
                Text("Selected Server: \(self.enviromentClass.selected_server)")
                    .font(.system(size: 15))
                
                // Link Kerberos Settings View
                NavigationLink(destination: SettingsView()){
                    Image(systemName: "gear")
                    Text("Settings...")
                }
                
                Spacer()
                    .frame(height: 20)
            }
            .navigationViewStyle(StackNavigationViewStyle()) // for iPadOS
            .navigationBarTitle(Text("Kerberos"))
            .navigationBarItems(trailing: navtigationBarButton)
            .alert(isPresented: $enviromentClass.showAlert, content: {self.alert}) // show alert when running Kerberos function was done
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
