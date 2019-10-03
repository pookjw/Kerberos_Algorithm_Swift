//
//  main.swift
//  Kerberos
//
//  Created by pook on 10/3/19.
//  Copyright © 2019 pook. All rights reserved.
//

import Foundation
import CryptoSwift

protocol Session_Protocol: AnyObject {
    var session_key: [UInt8] {get}
    var session_iv: [UInt8] {get}
}

class Person{
    var id: String
    var password: String
    init(id: String, password: String){
        self.id = id
        self.password = password
    }
    func stage1(message: [UInt8], iv: [UInt8]) throws -> [UInt8]{
        let key = Array<UInt8>(self.password.utf8)
        return try decrypt(message: message, key: key, iv: iv)
    }
    func stage2(server_session_key: [UInt8], server_session_iv: [UInt8]) throws -> [UInt8]{
        return try encrypt(message: stringToArrayUInt8(self.id), key: server_session_key, iv: server_session_iv)
    }
    func stage3(final_message: [UInt8], server_session_key: [UInt8], server_session_iv: [UInt8]) throws{
        if try decrypt(message: final_message, key: server_session_key, iv: server_session_iv) == stringToArrayUInt8("SUCCESS!!!!!!!!!"){
            print("Success!")
        }
    }
}

class Authentication_Server: Session_Protocol{
    var account_list = Dictionary<String, String>()
    let secret_key: [UInt8]
    let secret_iv: [UInt8]
    let session_key: [UInt8]
    let session_iv: [UInt8]
    weak var tgs_delegate: Session_Protocol?
    init(secret_key: [UInt8], secret_iv: [UInt8]){
        self.secret_key = secret_key
        self.secret_iv = secret_iv
        // These keys will delegate to TGS (Ticket_Granting_Service)
        self.session_key = generateRandomArray() // TGS Session key
        self.session_iv = generateRandomArray() // TGS Session IV
    }
    enum AS_ERROR: Error{
        case ALREADY_REGISTERED
        case VALID_ID
        case USER_FAILED_TO_DECRYPT_MESSAGE
    }
    func register(id: String, password: String) throws{
        if self.valid_id(id: id){
            throw AS_ERROR.ALREADY_REGISTERED
        }else{
            self.account_list[id] = password
        }
    }
    func valid_id(id: String) -> Bool{
        for (value, _) in self.account_list{
            if value == id{
                return true
            }
        }
        return false
    }
    
    func stage1(id: String) throws -> (message: [UInt8], iv: [UInt8]){
        var message = Array<UInt8>()
        let iv = generateRandomArray()

        if !self.valid_id(id: id){
            throw AS_ERROR.VALID_ID
        }
        do {
            let key = Array<UInt8>(self.account_list[id]!.utf8)
            message = try encrypt(message: tgs_delegate!.session_key, key: stringToArrayUInt8(self.account_list[id]!), iv: iv)
        } catch {}
        return (message: message, iv: iv)
    }
    
    func stage2(tgs_session_key: [UInt8], id: String) throws -> (TGT: Ticket_Granting_Ticket, encrypted_id: [UInt8]){
        if tgs_session_key != self.tgs_delegate!.session_key {throw AS_ERROR.USER_FAILED_TO_DECRYPT_MESSAGE}
        let TGT = Ticket_Granting_Ticket(encrypted_id: try encrypt(message: stringToArrayUInt8(id), key: secret_key, iv: secret_iv))
        return (TGT, try encrypt(message: stringToArrayUInt8(id), key: session_key, iv: session_iv))
    }
}

class Ticket_Granting_Service: Session_Protocol{
    let secret_key: [UInt8]
    let secret_iv: [UInt8]
    let session_key: [UInt8]
    let session_iv: [UInt8]
    weak var as_delegate: Session_Protocol?
    weak var ss_delegate: Session_Protocol?
    init(secret_key: [UInt8], secret_iv: [UInt8]){
        self.secret_key = secret_key
        self.secret_iv = secret_iv
        self.session_key = generateRandomArray()
        self.session_iv = generateRandomArray()
    }
    
    enum TGS_ERROR: Error{
        case TGT_AND_ID_ARE_NOT_MATCHING
    }
    
    func stage1(TGT: Ticket_Granting_Ticket, encrypted_id: [UInt8]) throws -> (ticket: [UInt8], server_session_key: [UInt8], server_session_iv: [UInt8]){
        let decrypted_id_secret = try decrypt(message: TGT.encrypted_id, key: secret_key, iv: secret_iv)
        let decrypted_id_session = try decrypt(message: encrypted_id, key: as_delegate!.session_key, iv: as_delegate!.session_iv)
        print("[Ticket_Granting_Service.stage1()] \(decrypted_id_secret) \(decrypted_id_session)")
        if decrypted_id_secret != decrypted_id_session{
            throw TGS_ERROR.TGT_AND_ID_ARE_NOT_MATCHING
        }
        print("Ticket_Granting_Service: \(secret_key), \(secret_iv)")
        return (ticket: try encrypt(message: decrypted_id_secret, key: secret_key, iv: secret_iv), server_session_key: ss_delegate!.session_key, server_session_iv: ss_delegate!.session_iv)
    }
}

class Service_Server: Session_Protocol{
    let secret_key: [UInt8]
    let secret_iv: [UInt8]
    let session_key: [UInt8]
    let session_iv: [UInt8]
    init(secret_key: [UInt8], secret_iv: [UInt8]){
        self.secret_key = secret_key
        self.secret_iv = secret_iv
        self.session_key = generateRandomArray()
        self.session_iv = generateRandomArray()
    }
    
    enum SS_ERROR:Error{
        case ID_NOT_MATCH
    }
    
    func stage1(ticket: [UInt8], encrypted_id: [UInt8]) throws -> [UInt8]{
        let decrypted_ticket = try decrypt(message: ticket, key: secret_key, iv: secret_iv)
        let decrypted_id = try decrypt(message: encrypted_id, key: session_key, iv: session_iv)
        print(ticket)
        if decrypted_ticket != decrypted_id{
            throw SS_ERROR.ID_NOT_MATCH
        }
        return try encrypt(message: stringToArrayUInt8("SUCCESS!!!!!!!!!"), key: session_key, iv: session_iv)
    }
}

class Servers{
    let AS: Authentication_Server
    let TGS: Ticket_Granting_Service
    let SS: Service_Server
    let secret_key = generateRandomArray()
    let secret_iv = generateRandomArray()
    init(){
        self.AS = Authentication_Server(secret_key: secret_key, secret_iv: secret_iv)
        self.TGS = Ticket_Granting_Service(secret_key: secret_key, secret_iv: secret_iv)
        self.SS = Service_Server(secret_key: secret_key, secret_iv: secret_iv)
        self.AS.tgs_delegate = self.TGS
        self.TGS.as_delegate = self.AS // delegate tgs_session_key/iv
        self.TGS.ss_delegate = self.SS // delegate ss_session_key/iv
    }
}

struct Ticket_Granting_Ticket{
    var encrypted_id: [String.UTF8View.Element]
    init(encrypted_id: [UInt8]){
        self.encrypted_id = encrypted_id
    }
}

func randomString() -> String {
  let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  return String((0..<16).map{ _ in letters.randomElement()! })
}

func generateRandomArray() -> [UInt8]{
    return Array<UInt8>(randomString().utf8)
}

func stringToArrayUInt8(_ input: String) -> [UInt8]{
    return Array<UInt8>(input.utf8)
}

func encrypt(message: [UInt8], key: [UInt8], iv: [UInt8]) throws -> [UInt8]{
    return try AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs7).encrypt(message)
}

func decrypt(message: [UInt8], key: [UInt8], iv: [UInt8]) throws -> [UInt8]{
    return try AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs7).decrypt(message)
}



let sejun = Person(id: "keykeykeykeykeyk", password: "1111111111111111")
let server1 = Servers()
try server1.AS.register(id: sejun.id, password: sejun.password) // 1
print("List of server1.AS account: \(server1.AS.account_list)")
print("Generated random secret key: \(server1.AS.secret_key)")
let Token1 = try server1.AS.stage1(id: sejun.id) // 2. Returns TGS Session Key (MessageA - encrypted with sejun's password), and that IV Key. MessageB was dropped.
print("Generated Token1 from AS: \(Token1)")
let Token2 = try sejun.stage1(message: Token1.message, iv: Token1.iv) // 3. Returns decrypted MessageA which is TGS Session Key
print("Passed sejun.stage1()")
let Token3 = try server1.AS.stage2(tgs_session_key: Token2, id: sejun.id) // 4. Returns TGT (MessageC - encrypted with secret key), ID encrypted with AS Session Key (MessageD)
let Token4 = try server1.TGS.stage1(TGT: Token3.TGT, encrypted_id: Token3.encrypted_id) // 5. Returns Ticket(MessageE - includes ID encrypted with secret key), and Server Session Key (MessageF)
let Token5 = try sejun.stage2(server_session_key: Token4.server_session_key, server_session_iv: Token4.server_session_iv) // 6. ID encrypted with server_session_key (MessageG)
print("Passed server1.TGS.stage1()")
let Token6 = try server1.SS.stage1(ticket: Token4.ticket, encrypted_id: Token5)
try sejun.stage3(final_message: Token6, server_session_key: Token4.server_session_key, server_session_iv: Token4.server_session_iv)
