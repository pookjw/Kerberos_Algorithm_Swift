# Kerberos_Modeling_Swift

Not a real Kerberos. It doens't communicate with servers. Just commutes with Swift-class with Kerberos algorithm.

Used AES-128 with [krzyzanowskim/CryptoSwift#calculate-digest](https://github.com/krzyzanowskim/CryptoSwift).

## How to use

**This project is still in progress**

1. Add **CryptoSwift.framework** from [krzyzanowskim/CryptoSwift#calculate-digest](https://github.com/krzyzanowskim/CryptoSwift).

2. Initialize `Person` and `Servers`. And register person to AS.

`let person = Person(id: "HelloThereHelloT", password: "ByeByeByeByeByeB")` // all values must be 16 characters

`let server = Servers()` // Secret Key and Each Session Key of servers are initialized and delegated (by `protocol Session_Protocol: AnyObject`).

`try server1.AS.register(id: person.id, password: person.password)`

3. Get Token1 (MessageA - encrypted TCG Session Key). MessageB is dropped because it isn't used on this script.

`let Token1 = try server1.AS.stage1(id: person.id)`

4. Decrypt MessageA with `person.password`. That is decrypted TCG Session Key. 

`let Token2 = try person.stage1(message: Token1.message, iv: Token1.iv)`

5. Verify TGS Session Key. If key is same, returns TGT (with `person.id` encrypted with Secret Key), and `person.id` encrypted with AS Session Key. (MessageC and MessageD). Call it as Token3.

`let Token3 = try person.AS.stage2(tgs_session_key: Token2, id: person.id)`

6. TGS verifies Token4 and return Ticket (MessageE - includes ID encrypted with secret key), and Server Session Key (MessageF). Call it as Token4.

`let Token4 = try server1.TGS.stage1(TGT: Token3.TGT, encrypted_id: Token3.encrypted_id)`

7. Encrypt `person.id` with Server Session Key (MessageG). Call it as Token4.

`let Token5 = try person.stage2(server_session_key: Token4.server_session_key, server_session_iv: Token4.server_session_iv)`

8. SS verifies MessageE and MessageG. And return "SUCCESS!!!!!!!!!" encrypted with SS Session Key. (MessageH)

`let Token6 = try server1.SS.stage1(ticket: Token4.ticket, encrypted_id: Token5)`

9. person verifies Token6 with Token4's Server Session Key.

`try person.stage3(final_message: Token6, server_session_key: Token4.server_session_key, server_session_iv: Token4.server_session_iv)`

Then will print `Success!`.

## Reference

[Kerberos (protocol)](https://en.wikipedia.org/wiki/Kerberos_(protocol))
