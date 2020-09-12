[![](https://img.shields.io/github/license/HasanEltantawy/ArchBell)](https://github.com/HasanEltantawy/ArchBell/blob/master/LICENSE)
[![version](https://img.shields.io/badge/version-1.0.0-yellow.svg)]()

# ArchBell
Educational App for architecture students at
Mansoura University
This App is Licensed under MIT License so you can use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software

# To Test
- [WEBSITE](https://archnews-ee4c7.web.app/#/) this website is not official .only for test and baased on the old version of the code
- App `Make one on your own`

# To Create your app
- Download the last version from the source code
- Open it in your editor
- Open pubspec and hit git pub
- Create a firebase project
- Just download `google-services.json`
- Put the file in `<project-name>/android/app`
- Remember to remove below code from `<project-name>/android/app/build.gradle`

```
    signingConfigs {
       release {
           keyAlias keystoreProperties['keyAlias']
           keyPassword keystoreProperties['keyPassword']
           storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
           storePassword keystoreProperties['storePassword']
       }
   }
```

# To Create your website
- First ypu must be in beta channel
- From your firebase project add website
- Only copy your API and paste it in `<project-name>/web/firebase-config.js`
- will be like this

```
var firebaseConfig = {
  apiKey: <>,
  authDomain: <>,
  databaseURL: <>,
  projectId: <>,
  storageBucket: <>,
  messagingSenderId: <>,
  appId: <>,
  measurementId: <>
};
// Initialize Firebase
firebase.initializeApp(firebaseConfig);
firebase.analytics();
```
- Then you can deploy it

# Warning ⚠ 
- The Adminstator dahboard might not work with you
- go to your firestore and add a collection called `ADMIN`
- Typicaly like this picture 
![Screenshot 2020-09-08 235742](https://user-images.githubusercontent.com/50374022/92531706-24065180-f22f-11ea-95cb-e710ed1e6997.png)

# App Features 
- Follow the educational process with ease
- No signing required
- Enter your name and your profile image URL
- Choose your year and term and you are ready to go
- You can find Lectures
- Have a look on your weekly tasks
- Read articles from your department's friends
- Write articles with a password so you can delete it or modify
- See How may people read your article
- Comment on articles and have a constructive discussions
- Administrator dashboard to add subjects & Lectures & weeks and Tasks
- Administrator dashboard is accessed by a password connected to database

# Future features 
- add signing
- add notifications

# Dev side
- Articles in the app based on markdown but html tag not included

# Screenshots



<p align="center">
  <img src="https://user-images.githubusercontent.com/50374022/92532588-dc80c500-f230-11ea-94fd-ebbed6ce8d39.png" width="250" >
  <img src="https://user-images.githubusercontent.com/50374022/92532552-d0950300-f230-11ea-9c97-95e0ee121bde.png" width="250" >
  <img src="https://user-images.githubusercontent.com/50374022/92532558-d1c63000-f230-11ea-95ec-0209ece56ac7.png" width="250" >
  <img src="https://user-images.githubusercontent.com/50374022/92532562-d38ff380-f230-11ea-90e4-cef747644ed7.png" width="250" >
  <img src="https://user-images.githubusercontent.com/50374022/92532566-d5f24d80-f230-11ea-9e5d-cdae29991820.png" width="250" >
  <img src="https://user-images.githubusercontent.com/50374022/92532568-d7bc1100-f230-11ea-9f45-f2a65ca25a3f.png" width="250" >
  <img src="https://user-images.githubusercontent.com/50374022/92532573-d854a780-f230-11ea-9f83-c03a96b5746b.png" width="250" >
  <img src="https://user-images.githubusercontent.com/50374022/92532578-dab70180-f230-11ea-82e0-67bd99c0d8b8.png" width="250" >
  <img src="https://user-images.githubusercontent.com/50374022/92532580-db4f9800-f230-11ea-8eee-cde767cb2f6d.png" width="250" >
  <img src="https://user-images.githubusercontent.com/50374022/92532584-dbe82e80-f230-11ea-9939-45e892223c68.png" width="250" >
</p>

