#!/bin/bash
# Firebase Setup Script for Noor Planner
# Run this from the project root: bash setup_firebase.sh

set -e

# Load nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
nvm use 20

echo "=== Step 1: Configuring FlutterFire ==="
flutterfire configure \
  --project=noor-planner-app \
  --platforms=android,ios \
  --android-package-name=com.bytse.ramadan_habit_tracker \
  --ios-bundle-id=com.bytse.ramadanHabitTracker \
  --yes

echo ""
echo "=== Step 2: Enabling Firebase Auth Providers ==="
echo "Please enable these in Firebase Console manually:"
echo "  https://console.firebase.google.com/project/noor-planner-app/authentication/providers"
echo ""
echo "  1. Phone (for OTP login)"
echo "  2. Google (for Google sign-in)"
echo "  3. Apple (for Apple sign-in on iOS)"
echo ""
echo "=== Done! Run 'flutter run' to test the app ==="
