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
                Button(action: {runKerberos(servers: self.enviromentClass.server_list[self.enviromentClass.selected_server]!, client: self.enviromentClass.client_list[self.enviromentClass.selected_client]!)}){
                    Text("Run")
                        .fontWeight(.heavy)
                        .font(.system(size: 40))
                }
                NavigationLink(destination: SettingView()){
                    Image(systemName: "gear")
                }
            }
                .navigationBarTitle("Kerberos")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
