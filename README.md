
# Pikobar Android (Flutter)
[![Codemagic build status](https://api.codemagic.io/apps/5f3b5884dd10566f84fcfcdc/5f3b5884dd10566f84fcfcdb/status_badge.svg)](https://codemagic.io/apps/5f3b5884dd10566f84fcfcdc/5f3b5884dd10566f84fcfcdb/latest_build)

> Pikobar Mobile App menggunakan Flutter saat ini sudah [dirilis untuk Android.](https://play.google.com/store/apps/details?id=id.go.jabarprov.pikobar "dirilis untuk Android.")

## Index

- [Firebase Setup](#firebase-setup)
	- [Firebase SDK](#firebase-sdk)
	- [Cloud Firestore Setup](#cloud-firestore-setup)
	- [Firebase Service Account](#firebase-service-account)
	- [Migrasi data](#migrasi-data)
- [Build Setup](#build-setup)
- [Pedoman Kontributor](#pedoman-kontributor)

  
## Firebase Setup

Pikobar menggunakan [Firebase](https://firebase.google.com/) sebagai _backend_.

  
#### Firebase SDK

1. [Buat project baru pada console firebase](https://firebase.google.com/docs/flutter/setup#create_firebase_project)

2. [Konfigurasi aplikasi android untuk menggunakan Firebase](https://firebase.google.com/docs/flutter/setup#configure_an_android_app)

  

#### Cloud Firestore Setup

1. Di firebase console, pada _sidebar_, lihat grup `Develop`. Pilih `Database`.
2. Klik `Create database`.
3. Pilih `Start in production mode`,
4. lalu pilih _location_ yang diinginkan untuk Cloud Firestore.
![Create Database](https://user-images.githubusercontent.com/4391973/77878823-69d3ec80-7283-11ea-8a83-62857b58f229.png)

  
#### Firebase Service Account

1. Pada _sidebar_, klik ikon menu :gear:.
2. Pilih `Project settings`.
3. Pilih tab `Service accounts`.
4. Klik `Generate new private key`.
5. Klik `Generate Key` pada bagian popup. Sebuah file JSON akan diunduh ke komputer Anda.
![Generate service account private key](https://user-images.githubusercontent.com/4391973/77879531-d7344d00-7284-11ea-880c-bedab6e508bd.png)

#### Migrasi data

1. Ubah nama _file_ JSON yang tadi diunduh menjadi `serviceAccount.json`.
2. Pindahkan _file_ `serviceAccount.json` ke dalam `<folder project pikobar>/migration`.
3. Buka _file_ [`config.js`](https://github.com/jabardigitalservice/pikobar-flutter/blob/setup-environment/migration/config.js) dan ubah nilai `databaseURL` sesuaikan dengan nilai `databaseURL` yang ada di `Service accounts` pada halaman `Project settings` console firebase (lihat pada gambar [Firebase Service Account](#firebase-service-account)).
4. Buka teminal, arahkan ke `<folder project pikobar>/migration`.
5. Jalankan perintah berikut
```bash 
# install dependencies
$ npm install

# migrasi data ke firestore
$ npm run migrate
```

  

## Build Setup
``` bash

# install dependencies
$ flutter pub get

# run debug mode
$ flutter run

# run release mode
$ flutter run --release

# build app bundle
$ flutter build appbundle

# build apk
$ flutter build apk

```

  

For detailed explanation on how things work, check out [Flutter docs](https://flutter.dev/docs).

  

## Pedoman Kontributor

Jabar Digital Service mengucapkan terima kasih kepada publik yang ingin berkontribusi untuk Pikobar :pray:.

Sebagai panduan, kami mempunyai [panduan umum untuk kontributor](https://github.com/jabardigitalservice/pikobar-relawan-readme/blob/master/README.md) dan [panduan kontributor untuk repositori ini](CONTRIBUTING.md).
