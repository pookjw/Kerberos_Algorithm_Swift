//
//  Kerberos.swift
//  Kerberos
//
//  Created by pook on 11/3/19.
//  Copyright © 2019 pookjw. All rights reserved.
//

import Foundation
import CryptoSwift

class Kerberos{
    let servers: Session
    let client: Client
    let hacker: Client?
    let server_number: Int
    let timeout: Double
    let delay: UInt32
    init(servers: Session, client: Client, hacker: Client? = nil, server_number: Int, timeout: Double, delay: UInt32){
        self.servers = servers
        self.client = client
        self.hacker = hacker
        self.server_number = server_number
        self.timeout = timeout
        self.delay = delay
    }
    
    func add_log(_ number: Int, log: inout String){
        let list = [
            "- Requesting token1 to Authentication Server...", // 0
            "- Creating token2...", // 1
            "- Requesting token3 to Ticket Granting Service...", // 2
            "- Creating token4...", // 3
            "- Requesting token5 to Service Server...", // 4
            "- Checking token5...", // 5
            "- Success!", // 6
            
            // GT Mode Log
            "- Creating pwned token2...", // 7
            "- Creating pwned token4..." // 8
        ]
        print(list[number])
        log += "\n\(list[number])"
    }
    func add_log(text: String, log: inout String){
        print(text)
        log += "\n\(text)"
    }
    func clear_all(){
        client.token1 = nil
        client.token2 = nil
        client.token3 = nil
        client.token4 = nil
        client.token5 = nil
        if hacker != nil{
            hacker!.token1 = nil
            hacker!.token2 = nil
            hacker!.token3 = nil
            hacker!.token4 = nil
            hacker!.token5 = nil
        }
    }
    
    func stage1(log: inout String) -> Int{
        add_log(text: "", log: &log)
        add_log(text: "Client: \(client.client_id.toString)", log: &log)
        add_log(text: "Server: \(server_number)", log: &log)
        
        do{
            add_log(0, log: &log)
            client.token1 = try servers.as.stage1(client_id: client.client_id)
        } catch AS.AS_ERROR.ID_IS_NOT_SIGNED{
            add_log(text: "- Error: Client is not signed to Server!", log: &log)
            client.success_server_list[server_number] = false
            return 1
        } catch let error as NSError {
            add_log(text: "Error: \(error)", log: &log)
            return 1
        }
        return 0
    }
    
    func stage2(log: inout String) -> Int{
        do{
            add_log(1, log: &log)
            client.token2 = try client.stage2()
        } catch let error as NSError {
            add_log(text: "Error: \(error)", log: &log)
            client.success_server_list[server_number] = false
            return 1
        }
        return 0
    }
    
    func stage3(log: inout String) -> Int{
        do{
            add_log(2, log: &log)
            client.token3 = try servers.tgs.stage3(token2: client.token2)
        } catch let error as NSError {
            add_log(text: "Error: \(error)", log: &log)
            client.success_server_list[server_number] = false
            return 1
        }
        return 0
    }
    
    func stage4(log: inout String) -> Int{
        do{
            add_log(3, log: &log)
            client.token4 = try client.stage4()
        } catch let error as NSError {
            add_log(text: "Error: \(error)", log: &log)
            client.success_server_list[server_number] = false
            return 1
        }
        return 0
    }
    
    func stage5(log: inout String) -> Int{
        do{
            add_log(4, log: &log)
            client.token5 = try servers.ss.stage5(token4: client.token4)
        } catch let error as NSError {
            add_log(text: "Error: \(error)", log: &log)
            client.success_server_list[server_number] = false
            return 1
        }
        return 0
    }
    
    func stage6(log: inout String) -> Int{
        do{
            add_log(5, log: &log)
            try client.stage6(timeout: timeout, delay: delay)
            add_log(6, log: &log)
            client.success_server_list[server_number] = true
        } catch Client.CLIENT_ERROR.TIMEOUT{
            add_log(text: "- Error: Timeout!", log: &log)
            client.success_server_list[server_number] = false
            return 1
        } catch let error as NSError {
            add_log(text: "Error: \(error)", log: &log)
            client.success_server_list[server_number] = false
            return 1
        }
        return 0
    }
    
    func gt_stage1(log: inout String) -> Int{
        add_log(text: "", log: &log)
        add_log(text: "Client: \(client.client_id.toString)", log: &log)
        add_log(text: "Hacker: \(hacker!.client_id.toString)", log: &log)
        add_log(text: "Server: \(server_number)", log: &log)
        
        do{
            add_log(7, log: &log)
            hacker!.token2 = try hacker!.gt_stage_2(fake_client_id: client.client_id, tgs_secret_key: servers.tgs.secret_key, tgs_secret_iv: servers.tgs.secret_iv)
        } catch let error as NSError {
            add_log(text: "Error: \(error)", log: &log)
            client.success_server_list[server_number] = false
            return 1
        }
        return 0
    }
    
    func gt_stage2(log: inout String) -> Int{
        do{
            add_log(2, log: &log)
            hacker!.token3 = try servers.tgs.stage3(token2: hacker!.token2)
        } catch let error as NSError {
            add_log(text: "Error: \(error)", log: &log)
            client.success_server_list[server_number] = false
            return 1
        }
        return 0
    }
    
    func gt_stage3(log: inout String) -> Int{
        do{
            add_log(8, log: &log)
            hacker!.token4 = try hacker!.gt_stage_4(fake_client_id: client.client_id)
        } catch let error as NSError {
            add_log(text: "Error: \(error)", log: &log)
            client.success_server_list[server_number] = false
            return 1
        }
        return 0
    }
    
    func gt_stage4(log: inout String) -> Int{
        do{
            add_log(4, log: &log)
            hacker!.token5 = try servers.ss.stage5(token4: hacker!.token4)
        } catch let error as NSError {
            add_log(text: "Error: \(error)", log: &log)
            client.success_server_list[server_number] = false
            return 1
        }
        return 0
    }
    
    func gt_stage5(log: inout String) -> Int{
        do{
            add_log(5, log: &log)
            try hacker!.stage6(timeout: timeout, delay: delay)
            add_log(6, log: &log)
            hacker!.success_server_list[server_number] = true
        } catch Client.CLIENT_ERROR.TIMEOUT{
            add_log(text: "- Error: Timeout!", log: &log)
            client.success_server_list[server_number] = false
            return 1
        } catch let error as NSError {
            add_log(text: "Error: \(error)", log: &log)
            client.success_server_list[server_number] = false
            return 1
        }
        return 0
    }
    
    func run_all(log: inout String) -> Int{
        if hacker == nil{ // If GT_Mode is off
            if stage1(log: &log) == 1 { clear_all(); return 1 }
            if stage2(log: &log) == 1 { clear_all(); return 1 }
            if stage3(log: &log) == 1 { clear_all(); return 1 }
            if stage4(log: &log) == 1 { clear_all(); return 1 }
            if stage5(log: &log) == 1 { clear_all(); return 1 }
            if stage6(log: &log) == 1 { clear_all(); return 1 }
        } else {
            if gt_stage1(log: &log) == 1 { clear_all(); return 1 }
            if gt_stage2(log: &log) == 1 { clear_all(); return 1 }
            if gt_stage3(log: &log) == 1 { clear_all(); return 1 }
            if gt_stage4(log: &log) == 1 { clear_all(); return 1 }
            if gt_stage5(log: &log) == 1 { clear_all(); return 1 }
        }
        clear_all(); return 0
    }
}

protocol Server: AnyObject{
    var secret_key: [UInt8]{get}
    var secret_iv: [UInt8]{get}
}

class Client{
    let client_id: [UInt8]
    let client_key: [UInt8]
    let client_iv: [UInt8]
    var token1: Token1?
    var token2: Token2?
    var token3: Token3?
    var token4: Token4?
    var token5: Token5?
    var tgs_session_key: [UInt8] = []
    var tgs_session_iv: [UInt8] = []
    var server_session_key: [UInt8] = []
    var server_session_iv: [UInt8] = []
    var success_server_list: [Int: Bool] = [:]
    enum CLIENT_ERROR: Error{
        case TOKEN1_IS_NIL
        case TOKEN3_IS_NIL
        case TOKEN5_IS_NIL
        case TIMEOUT
    }
    init(client_id: [UInt8], client_key: [UInt8], client_iv: [UInt8]){
        self.client_id = client_id
        self.client_key = client_key
        self.client_iv = client_iv
    }
    func stage2() throws -> Token2{
        if token1 == nil{
            throw CLIENT_ERROR.TOKEN1_IS_NIL
        }
        var result = Token2()
        result.encrypted_client_id_with_tgs_secret = token1!.encrypted_client_id_wuth_tgs_secret
        result.encrypted_tgs_seesion_key_with_tgs_secret = token1!.encrypted_tgs_seesion_key_with_tgs_secret
        result.encrypted_tgs_seesion_iv_with_tgs_secret = token1!.encrypted_tgs_seesion_iv_with_tgs_secret
        tgs_session_key = try token1!.encrypted_tgs_session_key_with_client.decrypt(key: client_key, iv: client_iv)
        tgs_session_iv = try token1!.encrypted_tgs_seesion_iv_with_client.decrypt(key: client_key, iv: client_iv)
        result.encrypted_client_id_with_tgs_session = try client_id.encrypt(key: tgs_session_key, iv: tgs_session_iv)
        return result
    }
    
    func stage4() throws -> Token4{
        if token3 == nil{
            throw CLIENT_ERROR.TOKEN3_IS_NIL
        }
        var result = Token4()
        server_session_key = try token3!.encrypted_server_session_key_with_tgs_session.decrypt(key: tgs_session_key, iv: tgs_session_iv)
        server_session_iv = try token3!.encrypted_server_seesion_iv_with_tgs_session.decrypt(key: tgs_session_key, iv: tgs_session_iv)
        let encrypted_client_id_with_server_session = try client_id.encrypt(key: server_session_key, iv: server_session_iv)
        
        result.encrypted_client_id_with_server_secret_key = token3!.encrypted_client_id_with_server_secret_key
        result.encrypted_server_seesion_key_with_server_secret = token3!.encrypted_server_seesion_key_with_server_secret
        result.encrypted_server_seesion_iv_with_server_secret = token3!.encrypted_server_seesion_iv_with_server_secret
        result.encrypted_client_id_with_server_session = encrypted_client_id_with_server_session
        
        return result
    }
    
    func stage6(timeout: Double, delay: UInt32) throws{
        if token5 == nil{
            throw CLIENT_ERROR.TOKEN5_IS_NIL
        }
        
        let dataformatter = DateFormatter()
        dataformatter.dateFormat = "yyyyMMddHHmmss'00'"
        
        let ss_time_uint8_array = try token5!.encrypted_timestamp_with_server_session.decrypt(key: server_session_key, iv: server_session_iv)
        let ss_time_date = dataformatter.date(from: ss_time_uint8_array.toString)
        sleep(delay)
        
        if Date().timeIntervalSince(ss_time_date!) > timeout{
            throw CLIENT_ERROR.TIMEOUT
        }
    }
    
    func gt_stage_2(fake_client_id: [UInt8], tgs_secret_key: [UInt8], tgs_secret_iv: [UInt8]) throws -> Token2{
        var result = Token2()
        
        tgs_session_key = randomArray()
        tgs_session_iv = randomArray()
        
        /*
        struct Token2{
            var encrypted_client_id_with_tgs_secret = Array<UInt8>() // messageC
            var encrypted_tgs_seesion_key_with_tgs_secret = Array<UInt8>() // messageC
            var encrypted_tgs_seesion_iv_with_tgs_secret = Array<UInt8>() // messageC
            var encrypted_client_id_with_tgs_session = Array<UInt8>() // messageD
        }
         */
        result.encrypted_client_id_with_tgs_secret = try fake_client_id.encrypt(key: tgs_secret_key, iv: tgs_secret_iv)
        result.encrypted_tgs_seesion_key_with_tgs_secret = try tgs_session_key.encrypt(key: tgs_secret_key, iv: tgs_secret_iv)
        result.encrypted_tgs_seesion_iv_with_tgs_secret = try tgs_session_iv.encrypt(key: tgs_secret_key, iv: tgs_secret_iv)
        
        result.encrypted_client_id_with_tgs_session = try fake_client_id.encrypt(key: tgs_session_key, iv: tgs_session_iv)
        
        return result
    }
    
    func gt_stage_4(fake_client_id: [UInt8]) throws -> Token4{
        if token3 == nil{
            throw CLIENT_ERROR.TOKEN3_IS_NIL
        }
        var result = Token4()
        server_session_key = try token3!.encrypted_server_session_key_with_tgs_session.decrypt(key: tgs_session_key, iv: tgs_session_iv)
        server_session_iv = try token3!.encrypted_server_seesion_iv_with_tgs_session.decrypt(key: tgs_session_key, iv: tgs_session_iv)
        let encrypted_client_id_with_server_session = try fake_client_id.encrypt(key: server_session_key, iv: server_session_iv)
        
        result.encrypted_client_id_with_server_secret_key = token3!.encrypted_client_id_with_server_secret_key
        result.encrypted_server_seesion_key_with_server_secret = token3!.encrypted_server_seesion_key_with_server_secret
        result.encrypted_server_seesion_iv_with_server_secret = token3!.encrypted_server_seesion_iv_with_server_secret
        result.encrypted_client_id_with_server_session = encrypted_client_id_with_server_session
        
        return result
    }
}

class AS{
    var client_id_list: [[UInt8]] = []
    var client_key_list: [[UInt8]: [UInt8]] = [:]
    var client_iv_list: [[UInt8]: [UInt8]] = [:]
    enum AS_ERROR: Error{
        case ID_IS_NOT_SIGNED
    }
    weak var tgs_delegate: Server?
    func signUp(client: Client){
        if !self.client_id_list.contains(client.client_id){
            self.client_id_list.append(client.client_id)
            self.client_key_list[client.client_id] = client.client_key
            self.client_iv_list[client.client_id] = client.client_iv
        }
    }
    func stage1(client_id: [UInt8]) throws -> Token1{
        if !self.client_id_list.contains(client_id){
            throw AS_ERROR.ID_IS_NOT_SIGNED
        }
        var result = Token1()
        let tgs_session_key = randomArray()
        let tgs_session_iv = randomArray()
        result.encrypted_tgs_session_key_with_client = try tgs_session_key.encrypt(key: client_key_list[client_id]!, iv: client_iv_list[client_id]!)
        result.encrypted_tgs_seesion_iv_with_client = try tgs_session_iv.encrypt(key: client_key_list[client_id]!, iv: client_iv_list[client_id]!)
        
        result.encrypted_client_id_wuth_tgs_secret = try client_id.encrypt(key: tgs_delegate!.secret_key, iv: tgs_delegate!.secret_iv)
        result.encrypted_tgs_seesion_key_with_tgs_secret = try tgs_session_key.encrypt(key: tgs_delegate!.secret_key, iv: tgs_delegate!.secret_iv)
        result.encrypted_tgs_seesion_iv_with_tgs_secret =  try tgs_session_iv.encrypt(key: tgs_delegate!.secret_key, iv: tgs_delegate!.secret_iv)
        return result
    }
}

class TGS: Server{
    let secret_key: [UInt8]
    let secret_iv: [UInt8]
    weak var ss_delegate: Server?
    init(){
        self.secret_key = randomArray()
        self.secret_iv = randomArray()
    }
    
    enum TGS_ERROR: Error{
        case ID_IS_NOT_MATCHING
        case TOKEN2_IS_NIL
    }
    func stage3(token2: Token2?) throws -> Token3{
        if token2 == nil{
            throw TGS_ERROR.TOKEN2_IS_NIL
        }
        
        var result = Token3()
        let tgs_session_key = try token2!.encrypted_tgs_seesion_key_with_tgs_secret.decrypt(key: secret_key, iv: secret_iv)
        let tgs_session_iv = try token2!.encrypted_tgs_seesion_iv_with_tgs_secret.decrypt(key: secret_key, iv: secret_iv)
        let client_id_from_session = try token2!.encrypted_client_id_with_tgs_session.decrypt(key: tgs_session_key, iv: tgs_session_iv)
        let client_id_from_secret = try token2!.encrypted_client_id_with_tgs_secret.decrypt(key: secret_key, iv: secret_iv)
        
        if client_id_from_session != client_id_from_secret{
            throw TGS_ERROR.ID_IS_NOT_MATCHING
        }
        
        let server_session_key = randomArray()
        let server_session_iv = randomArray()
        
        result.encrypted_client_id_with_server_secret_key = try client_id_from_session.encrypt(key: ss_delegate!.secret_key, iv: ss_delegate!.secret_iv)
        result.encrypted_server_seesion_key_with_server_secret = try server_session_key.encrypt(key: ss_delegate!.secret_key, iv: ss_delegate!.secret_iv)
        result.encrypted_server_seesion_iv_with_server_secret = try server_session_iv.encrypt(key: ss_delegate!.secret_key, iv: ss_delegate!.secret_iv)
        result.encrypted_server_session_key_with_tgs_session = try server_session_key.encrypt(key: tgs_session_key, iv: tgs_session_iv)
        result.encrypted_server_seesion_iv_with_tgs_session = try server_session_iv.encrypt(key: tgs_session_key, iv: tgs_session_iv)
        return result
    }
}

class SS: Server{
    let secret_key: [UInt8]
    let secret_iv: [UInt8]
    enum SS_ERROR:Error{
        case ID_IS_NOT_MATCHING
        case TOKEN4_IS_NIL
    }
    init(){
        self.secret_key = randomArray()
        self.secret_iv = randomArray()
    }
    func stage5(token4: Token4?) throws -> Token5{
        if token4 == nil{
            throw SS_ERROR.TOKEN4_IS_NIL
        }
        
        let dataformatter = DateFormatter()
        dataformatter.dateFormat = "yyyyMMddHHmmss'00'"
        let current_time_uint8_array = dataformatter.string(from: Date()).toArrayUInt8
        
        var result = Token5()
        
        let server_session_key = try token4!.encrypted_server_seesion_key_with_server_secret.decrypt(key: secret_key, iv: secret_iv)
        let server_session_iv = try token4!.encrypted_server_seesion_iv_with_server_secret.decrypt(key: secret_key, iv: secret_iv)
        
        
        let client_id_from_secret_key = try token4!.encrypted_client_id_with_server_secret_key.decrypt(key: secret_key, iv: secret_iv)
        let client_id_from_server_seesion = try token4!.encrypted_client_id_with_server_session.decrypt(key: server_session_key, iv: server_session_iv)
        
        if client_id_from_secret_key != client_id_from_server_seesion{
            throw SS_ERROR.ID_IS_NOT_MATCHING
        }
        
        result.encrypted_timestamp_with_server_session = try current_time_uint8_array.encrypt(key: server_session_key, iv: server_session_iv)
        return result
    }
}

class Session{
    let `as` = AS()
    let tgs = TGS()
    let ss = SS()
    init(){
        self.`as`.tgs_delegate = self.tgs
        self.tgs.ss_delegate = self.ss
    }
}

struct Token1{
    var encrypted_tgs_session_key_with_client = Array<UInt8>() // messageA
    var encrypted_tgs_seesion_iv_with_client = Array<UInt8>() // messageA
    var encrypted_client_id_wuth_tgs_secret = Array<UInt8>() // messageB
    var encrypted_tgs_seesion_key_with_tgs_secret = Array<UInt8>() // messageB
    var encrypted_tgs_seesion_iv_with_tgs_secret = Array<UInt8>() // messageB
}

struct Token2{
    var encrypted_client_id_with_tgs_secret = Array<UInt8>() // messageC
    var encrypted_tgs_seesion_key_with_tgs_secret = Array<UInt8>() // messageC
    var encrypted_tgs_seesion_iv_with_tgs_secret = Array<UInt8>() // messageC
    var encrypted_client_id_with_tgs_session = Array<UInt8>() // messageD
}

struct Token3{
    var encrypted_client_id_with_server_secret_key = Array<UInt8>() // messageE
    var encrypted_server_seesion_key_with_server_secret = Array<UInt8>() // messageE
    var encrypted_server_seesion_iv_with_server_secret = Array<UInt8>() // messageE
    var encrypted_server_session_key_with_tgs_session = Array<UInt8>() // messageF
    var encrypted_server_seesion_iv_with_tgs_session = Array<UInt8>() // messageF
}

struct Token4{
    var encrypted_client_id_with_server_secret_key = Array<UInt8>() // messageE
    var encrypted_server_seesion_key_with_server_secret = Array<UInt8>() // messageE
    var encrypted_server_seesion_iv_with_server_secret = Array<UInt8>() // messageE
    var encrypted_client_id_with_server_session = Array<UInt8>() // messageG
}

struct Token5{
    var encrypted_timestamp_with_server_session = Array<UInt8>() // messageH
}

func randomString() -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0..<16).map{ _ in letters.randomElement()! })
}

func randomArray() -> [UInt8]{
    return Array<UInt8>(randomString().utf8)
}

func randomArray(input: String) -> [UInt8]{
    return Array<UInt8>(input.utf8)
}

extension String{
    var toArrayUInt8: [UInt8]{
        Array<UInt8>(self.utf8)
    }
}

extension Array where Element == UInt8 {
    var toString: String{
        String(bytes: self, encoding: .utf8)!
    }
}

extension Array where Iterator.Element == UInt8{
    func encrypt(key: [UInt8], iv: [UInt8]) throws -> [UInt8]{
        return try AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs7).encrypt(self)
    }
    func decrypt(key: [UInt8], iv: [UInt8]) throws -> [UInt8]{
        return try AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs7).decrypt(self)
    }

}
