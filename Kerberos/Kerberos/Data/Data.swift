//
//  Data.swift
//  Kerberos
//
//  Created by pook on 11/3/19.
//  Copyright © 2019 pookjw. All rights reserved.
//

import SwiftUI
import Foundation

final class EnviromentClass: ObservableObject{
    static let defaultLog = """
    Welcome to Kerberos Swift!
    This is a presentational data. Copyright pookjw. All rights reserved.
    Check GitHub for more information!!!
    """ // Initial log
    @Published var client_list: [Client]
    @Published var server_list: [Session]
    @Published var selected_client: Int
    @Published var selected_server: Int
    @Published var selected_hacker: Int
    @Published var showAlert = false // ContentView
    @Published var showSheet = false // ServerView
    @Published var return_code: Int? // Return value from Kerberos.swift - runKerberos()
    @Published var GTMode = false // Golden Ticket Mode
    @Published var timeout = 3
    @Published var delay = 0
    @Published var log: String
    
    // Theme for LogView. Can configure at ThemeSettingView
    @Published var log_background_color = Color.black
    @Published var log_text_color = Color.green
    @Published var log_overlay_color = Color.gray
    @Published var log_line_spacing = 0
    
    @Published var SBSMode = true
    
    init(){
        self.log = EnviromentClass.defaultLog
        self.client_list = []
        self.server_list = []
        self.selected_client = 0
        self.selected_server = 0
        self.selected_hacker = 1
        self.add_server()
        self.add_client()
        self.add_client()
        self.server_list[0].as.signUp(client: self.client_list[0])
    }
    
    func add_client(){
        let id = randomArray()
        let key = randomArray()
        let iv = randomArray()
        self.client_list.append(Client(client_id: id, client_key: key, client_iv: iv))
        
        // Initialize server list on new client
        for value in 0..<self.server_list.count{
            self.client_list.last!.success_server_list[value] = false
        }
    }
    
    func add_server(){
        self.server_list.append(Session())
        // Initialize new server on all client
        for value in 0..<self.client_list.count{
            self.client_list[value].success_server_list[self.server_list.count-1] = false
        }
    }
    
    func unauthorizeAllSessions(){
        for value_1 in 0..<self.client_list.count{
            for value_2 in 0..<self.server_list.count{
                self.client_list[value_1].success_server_list[value_2] = false
            }
        }
    }
}
