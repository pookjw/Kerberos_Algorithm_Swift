//
//  Data.swift
//  Kerberos
//
//  Created by pook on 11/3/19.
//  Copyright © 2019 pookjw. All rights reserved.
//

import Foundation

final class EnviromentClass: ObservableObject{
    @Published var client_list: [Client]
    @Published var server_list: [Session]
    @Published var selected_client: Int
    @Published var selected_server: Int
    @Published var showSheet = false
    @Published var log = """
    Welcome to Kerberos Swift!
    This is a presentational data. Copyright pookjw. All rights reserved.
    Check GitHub for more information!!!
    
    """
    
    init(){
        let initial_session = Session()
        let initial_client = Client(client_id: randomArray(), client_key: randomArray(), client_iv: randomArray())
        self.client_list = [initial_client]
        self.server_list =  [initial_session]
        self.selected_client = 0
        self.selected_server = 0
        self.server_list[0].as.signUp(client: initial_client)
    }
    
    func add_client(){
        let id = randomArray()
        let key = randomArray()
        let iv = randomArray()
        self.client_list.append(Client(client_id: id, client_key: key, client_iv: iv))
    }
    
    func add_server(){
        self.server_list.append(Session())
    }
}
