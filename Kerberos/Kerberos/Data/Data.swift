//
//  Data.swift
//  Kerberos
//
//  Created by pook on 11/3/19.
//  Copyright © 2019 pookjw. All rights reserved.
//

import Foundation

var session_1 = Session()
let name_1 = randomString()
let name_2 = randomString()
var client_1 = Client(client_id: name_1.toArrayUInt8, client_key: randomArray(), client_iv: randomArray(), session: session_1)
var client_2 = Client(client_id: name_2.toArrayUInt8, client_key: randomArray(), client_iv: randomArray(), session: session_1)

func runKerberos(servers: Session, client: Client){
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
    }catch AS.AS_ERROR.ID_IS_NOT_SIGNED{
        print("Error!")
    }catch{
        ()
    }
}

final class EnviromentClass: ObservableObject{
    @Published var client_list: [String: Client] = [name_1: client_1, name_2: client_2]
    @Published var server_list: [Int: Session] = [0: session_1]
    @Published var selected_client: String = name_1
    @Published var selected_server: Int = 0
    @Published var showSheet = false
    
    func add_client(){
        let id = randomString()
        self.client_list[id] = Client(client_id: id.toArrayUInt8, client_key: randomArray(), client_iv: randomArray(), session: session_1)
    }
    
    func add_server(){
        let number = self.server_list.keys.reduce(0, {a, b in a>b ? a : b}) + 1
        self.server_list[number] = Session()
    }
}
