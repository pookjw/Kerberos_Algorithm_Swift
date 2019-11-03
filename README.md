# Kerberos_Algorithm_Swift

![1](https://live.staticflickr.com/65535/49004869416_e55e40abd9_o.png)

Not a real Kerberos. It doesn't communicate with servers. Just commutes with Swift-class with Kerberos algorithm.

Used AES-128 with [krzyzanowskim/CryptoSwift](https://github.com/krzyzanowskim/CryptoSwift).

한국어 (Korean) : [explanation_kor.md](explanation_kor/explanation_kor.md)

**This project is still in progress**

## Fundamental Algorithm

More Details can check from [Kerberos (protocol)](https://en.wikipedia.org/wiki/Kerberos_(protocol))

1. Client sends ID to AS

2. AS gives:

- messageA : TGS Session Key encrypted with the client secret key

- messageB : TGT (client ID, TGS session key) encrypted with the TGS secret key

These are combined on Token1.

3. Client attempts to decrypt messageA, and client sends the following messages to the TGS

- messageC : messageB

- messageD : Authenticator (client ID encrypted) with the TGS session key (from messageA)

These are combined on Token2. Now Client knows TGS Session Key from messageA.

4. The TGS retrieves messageC and decrypts using TGS secret key and gets TGS session key. Using this key, the TGS decrypts messageD and compare client ID from C and D. If they match,'

- messageE : Client-to-server ticket (client ID, Server Session Key) encrypted using the Server secret key

- messageF : Server Session Key encypted using TGS Session key (from messageC)

These are combined on Token3.

5. Client receives E and F. Now client knows Server Session Key from messageF (TGS Session Key can get from messageA)

- messageE : messageE from the previous step

- messageG : another Authenticator (client ID) encrypted using Server Seesion key 
 
 These are combined on Token4.
 
6. SS decrypts messageE using Server secret key and gets Server Session Key. Using this Server Session Key, SS decrypts messageG and compare client ID. If match,

- messageH : timestamp encrypted using Server Session Key.

This is called on Token5.

7. Client gets messageH and check timestamp.

## Todo

- Multi clients and sessions

- Add Kerberos fundamental vulnerability

- Enhance timestamp

- Add LogView

- More error handling

- Multi Encryption Algorithm
