# Kerberos_Algorithm_Swift

![1](https://live.staticflickr.com/65535/49004869416_e55e40abd9_o.png)

Not a real Kerberos. It doesn't communicate with servers. Just commutes with Swift-class with Kerberos algorithm.

Used AES-128 with [krzyzanowskim/CryptoSwift](https://github.com/krzyzanowskim/CryptoSwift).

한국어 (Korean) : [explanation_kor.md](explanation_kor/explanation_kor.md)

**This project is still in progress**

## Fundamental Algorithm

More Details can check from [Kerberos (protocol)](https://en.wikipedia.org/wiki/Kerberos_(protocol))

1. Client sends ID to AS. AS checks that Client is signed up.

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

## How to use this

- Creating new Client

Go to **Settings (gear icon) → Client List → Plus Button (located on right top)**

![3](https://live.staticflickr.com/65535/49011271766_9c7f29dcff_o.png)

- Creating new Server

Go to **Settings (gear icon) → Server List → Plus Button (located on right top)**

![2](https://live.staticflickr.com/65535/49011267841_df941b6246_o.png)

- Signing up Client to Server

Go to **Settings (gear icon) → Server List → Pencil Button (located on right top) → Select Server you want to sign up → Add item...  → Select Client you want to sign up**

![3](https://live.staticflickr.com/65535/49011277536_720504b922_o.png)

- Select Client and Server to run algorithm

Select Client: Go to **Settings (gear icon) → Client List →  Touch Client you want to select**

Select Server: Go to **Settings (gear icon) → Server List →  Touch Server you want to select**

- Running Algorithm

![1](https://live.staticflickr.com/65535/49011461207_10dbbd00a3_o.png)

Touch **Run** button. If running algorithm was successful, you can see this message:

```
Requesting token1 to Authentication Server...
Creating token2...
Requesting token3 to Ticket Granting Service...
Creating token4...
Requesting token5 to Service Server...
Checking token5...
Success!
```

**Make sure that selected Client is signed up to selected Server!!! If it didn't you will see AS.AS_ERROR.**

## To Do

- Fix SwiftUI EnviromentObject refresh bug

- Add Kerberos fundamental vulnerability

- Enhance timestamp

- Add LogView

- More error handling

- Multi Encryption Algorithm
