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
    
    var body: some View {
        NavigationView{
            VStack{
                Button(action: {self.enviromentClass.log += runKerberos(servers: self.enviromentClass.server_list[self.enviromentClass.selected_server], client: self.enviromentClass.client_list[self.enviromentClass.selected_client])}){
                    Text("Run")
                        .fontWeight(.heavy)
                        .font(.system(size: 40))
                }
                Spacer()
                    .frame(height: 40)
                NavigationLink(destination: SettingView()){
                    Image(systemName: "gear")
                        .scaleEffect(2.5)
                }
                Spacer()
                    .frame(height: 40)
                Text("Selected Client: \(self.enviromentClass.client_list[self.enviromentClass.selected_client].client_id.toString)")
                Text("Selected Server: \(self.enviromentClass.selected_server)")
                Spacer()
                    .frame(height: 30)
                LogView()
            }
            .padding([.leading, .bottom, .trailing], 10.0)
                .navigationBarTitle("Kerberos")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
