//
//  Kerberos.swift
//  Kerberos
//
//  Created by pook on 11/3/19.
//  Copyright © 2019 pookjw. All rights reserved.
//

import Foundation
import CryptoSwift

func runKerberos(servers: Session, client: Client, server_number: Int) -> String{
    var result = ""
    do{
        result += "\nRequesting token1 to Authentication Server..."
        client.token1 = try servers.as.stage2(client_id: client.client_id)
        result += "\nCreating token2..."
        client.token2 = try client.stage3()
        result += "\nRequesting token3 to Ticket Granting Service..."
        client.token3 = try servers.tgs.stage4(token2: client.token2)
        result += "\nCreating token4..."
        client.token4 = try client.stage5()
        result += "\nRequesting token5 to Service Server..."
        client.token5 = try servers.ss.stage6(token4: client.token4)
        result += "\nChecking token5..."
        try client.stage7(server_number: server_number)
        result += "\nSuccess!"
    }catch let error as NSError {
        result += "\n\(error)"
    }
    return result
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
        case INVALID_TIMESTAMP
    }
    init(client_id: [UInt8], client_key: [UInt8], client_iv: [UInt8]){
        self.client_id = client_id
        self.client_key = client_key
        self.client_iv = client_iv
    }
    func stage3() throws -> Token2{
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
    
    func stage5() throws -> Token4{
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
    
    func stage7(server_number: Int) throws{
        if token5 == nil{
            throw CLIENT_ERROR.TOKEN5_IS_NIL
        }
        let timestamp = try token5!.encrypted_timestamp_with_server_session.decrypt(key: server_session_key, iv: server_session_iv)
        if timestamp != token5?.timestamp{
            throw CLIENT_ERROR.INVALID_TIMESTAMP
        }
        self.success_server_list[server_number] = true
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
    func stage2(client_id: [UInt8]) throws -> Token1{
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
    func stage4(token2: Token2?) throws -> Token3{
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
    func stage6(token4: Token4?) throws -> Token5{
        if token4 == nil{
            throw SS_ERROR.TOKEN4_IS_NIL
        }
        var result = Token5()
        
        let server_session_key = try token4!.encrypted_server_seesion_key_with_server_secret.decrypt(key: secret_key, iv: secret_iv)
        let server_session_iv = try token4!.encrypted_server_seesion_iv_with_server_secret.decrypt(key: secret_key, iv: secret_iv)
        
        
        let client_id_from_secret_key = try token4!.encrypted_client_id_with_server_secret_key.decrypt(key: secret_key, iv: secret_iv)
        let client_id_from_server_seesion = try token4!.encrypted_client_id_with_server_session.decrypt(key: server_session_key, iv: server_session_iv)
        
        if client_id_from_secret_key != client_id_from_server_seesion{
            throw SS_ERROR.ID_IS_NOT_MATCHING
        }
        
        result.timestamp = timestamp()
        result.encrypted_timestamp_with_server_session = try result.timestamp.encrypt(key: server_session_key, iv: server_session_iv)
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
    var timestamp = Array<UInt8>()
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

func timestamp() -> [UInt8]{
    return randomArray()
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
