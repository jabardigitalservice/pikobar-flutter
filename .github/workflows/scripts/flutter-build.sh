#!/bin/bash

flutter build apk --debug
flutter build apk --profile
flutter build apk --release
mv build/app/outputs/apk/release/app-release.apk pikobar-staging.apk
