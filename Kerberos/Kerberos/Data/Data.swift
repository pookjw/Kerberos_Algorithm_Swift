//
//  Data.swift
//  Kerberos
//
//  Created by pook on 11/3/19.
//  Copyright © 2019 pookjw. All rights reserved.
//

import Foundation

var session_1 = Session()
var client_1 = Client(client_id_raw: randomString(), client_key: randomArray(), client_iv: randomArray(), session: &session_1)

func runKerberos(servers: inout Session, client: inout Client){
    print("Requesting token1 to Authentication Server...")
    do{
        client.token1 = try servers.as.stage2(client_id: client.client_id)
        print("Creating token2...")
        client.token2 = try client.stage3()
        print("Requesting token3 to Ticket Granting Service...")
        client.token3 = try servers.tgs.stage4(token2: client.token2)
        print("Creating token4...")
        client.token4 = try client.stage5()
        print("Requesting token5 to Service Server...")
        client.token5 = try servers.ss.stage6(token4: client.token4)
        print("Checking token5...")
        try client.stage7()
        print("Success!")
    }catch{
        ()
    }
}

final class EnviromentClass: ObservableObject{
    @Published var showSettingSheet = false
    @Published var client_list: [Client] = [client_1]
    @Published var server_list: [Session] = []
    @Published var selected_client: Client?
    @Published var selected_server: Session?
}
