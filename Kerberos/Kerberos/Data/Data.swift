//
//  Data.swift
//  Kerberos
//
//  Created by pook on 11/3/19.
//  Copyright © 2019 pookjw. All rights reserved.
//

import Foundation

final class EnviromentClass: ObservableObject{
    static let defaultLog = """
    Welcome to Kerberos Swift!
    This is a presentational data. Copyright pookjw. All rights reserved.
    Check GitHub for more information!!!
    """
    @Published var client_list: [Client]
    @Published var server_list: [Session]
    @Published var selected_client: Int
    @Published var selected_server: Int
    @Published var showSheet_1 = false
    @Published var showSheet_2 = false
    @Published var log = EnviromentClass.defaultLog
    
    init(){
        self.client_list = []
        self.server_list = []
        self.selected_client = 0
        self.selected_server = 0
        self.add_server()
        self.add_client()
        self.server_list[0].as.signUp(client: self.client_list[0])
    }
    
    func add_client(){
        let id = randomArray()
        let key = randomArray()
        let iv = randomArray()
        self.client_list.append(Client(client_id: id, client_key: key, client_iv: iv))
        //self.client_list.last!.success_server_list
        for value in 0..<self.server_list.count{
            self.client_list.last!.success_server_list[value] = false
        }
    }
    
    func add_server(){
        self.server_list.append(Session())
        for value in 0..<self.client_list.count{
            self.client_list[value].success_server_list[self.server_list.count-1] = false
        }
    }
    
    func logoutAllSessions(){
        for value_1 in 0..<self.client_list.count{
            self.client_list[value_1].token1 = nil
            self.client_list[value_1].token2 = nil
            self.client_list[value_1].token3 = nil
            self.client_list[value_1].token4 = nil
            self.client_list[value_1].token5 = nil
            for value_2 in 0..<self.server_list.count{
                self.client_list[value_1].success_server_list[value_2] = false
            }
        }
    }
}
