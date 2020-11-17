#!/bin/bash

flutter build apk --release
mv build/app/outputs/apk/release/app-release.apk pikobar-staging.apk
