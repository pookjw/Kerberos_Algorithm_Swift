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
                Button(action: { self.enviromentClass.return_code =
                    runKerberos(
                        servers: self.enviromentClass.server_list[self.enviromentClass.selected_server],
                        client: self.enviromentClass.client_list[self.enviromentClass.selected_client],
                        hacker: self.enviromentClass.client_list[self.enviromentClass.selected_hacker],
                        server_number: self.enviromentClass.selected_server,
                        timeout: Double(self.enviromentClass.timeout),
                        delay: UInt32(self.enviromentClass.delay),
                        log: &self.enviromentClass.log
                    )
                    self.enviromentClass.showAlert = true
                }){
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
                Button(action: { self.enviromentClass.return_code =
                    runKerberos(
                        servers: self.enviromentClass.server_list[self.enviromentClass.selected_server],
                        client: self.enviromentClass.client_list[self.enviromentClass.selected_client],
                        server_number: self.enviromentClass.selected_server,
                        timeout: Double(self.enviromentClass.timeout),
                        delay: UInt32(self.enviromentClass.delay),
                        log: &self.enviromentClass.log
                    )
                    self.enviromentClass.showAlert = true
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
                Spacer()
                    .frame(height: 20)
                Text("Selected Client: \(self.enviromentClass.client_list[self.enviromentClass.selected_client].client_id.toString)")
                    .font(.system(size: 15))
                if self.enviromentClass.GTMode{
                    Text("Selected Hacker: \(self.enviromentClass.client_list[self.enviromentClass.selected_hacker].client_id.toString)")
                        .font(.system(size: 15))
                }
                Text("Selected Server: \(self.enviromentClass.selected_server)")
                    .font(.system(size: 15))
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
            .alert(isPresented: $enviromentClass.showAlert, content: {self.alert})
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
