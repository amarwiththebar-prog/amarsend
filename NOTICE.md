# Notice of changes

AmarSend is a modified version of LocalSend (https://github.com/localsend/localsend), imported from upstream commit 6e37efd5fe750299758b6778d2b150b31af3b95d. LocalSend is Copyright Tien Do Nam and contributors, licensed under the Apache License 2.0 (see LICENSE).

Changes made for AmarSend:

- Device discovery also probes peers on the user's Tailscale network (`app/lib/util/native/tailscale_helper.dart`, `app/lib/provider/network/scan_facade.dart`, `app/lib/provider/network/nearby_devices_provider.dart`).
- Renamed the app to AmarSend in UI text, translations, window titles, and the Windows/macOS app metadata; new bundle identifier `com.amarsend.app`.
- Replaced the LocalSend logo and icons with original AmarSend artwork.
- macOS project set to ad-hoc signing without App Sandbox (`app/macos/Runner/AmarSend.entitlements`).
- Replaced LocalSend's CI with `.github/workflows/build.yml`, which builds unsigned Windows x64, Windows ARM64 and macOS apps.
- New README; the original is kept as README.localsend.md.
