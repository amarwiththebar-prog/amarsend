# AmarSend

AmarSend is a personal fork of [LocalSend](https://github.com/localsend/localsend) for sending files between friends' computers, including on campus Wi-Fi that normally blocks it.

## What's different from LocalSend

- **Works on campus Wi-Fi.** University networks usually stop devices from seeing each other, even on the same Wi-Fi. AmarSend also looks for your friends over [Tailscale](https://tailscale.com), a free private network that gets around that. If Tailscale is installed and you're both signed in to the same Tailscale network, your friend shows up in AmarSend automatically.
- **Its own app.** New name, icon and app ID, so it can sit next to LocalSend without clashing. It still talks to regular LocalSend devices on normal networks.
- **Builds itself.** GitHub builds the Windows (x64 and ARM64) and Mac apps on every change and posts them on the Releases page.

## Setup (one time)

### 1. Get the apps

Open this repository's **Releases** page and download from "AmarSend (latest build)":

| Computer | File |
| --- | --- |
| Windows on Snapdragon / ARM | `AmarSend-windows-arm64.zip` |
| Other Windows PCs | `AmarSend-windows-x64.zip` |
| Mac (Intel or Apple Silicon) | `AmarSend-macos.zip` |

**Windows:** unzip the folder somewhere permanent (like Documents) and run `AmarSend.exe`. If SmartScreen warns you, click *More info → Run anyway*. When Windows Firewall asks, allow access on **both private and public networks**.

**Mac:** unzip, drag AmarSend to Applications, then **right-click → Open** the first time (it isn't signed by Apple, so a normal double-click is blocked once). If macOS still refuses, open System Settings → Privacy & Security and click *Open Anyway*.

### 2. Set up Tailscale (both people)

1. Install Tailscale from [tailscale.com/download](https://tailscale.com/download). The Mac version from the website and the App Store both work.
2. One person signs up (free) and signs in.
3. That person invites the other: in the [admin console](https://login.tailscale.com/admin/users), click *Invite users*, or use *Share* on a single machine. Both computers must appear on the same Tailscale network.
4. Leave Tailscale connected.

### 3. Send

Open AmarSend on both computers. On the Send tab, your friend appears in Nearby Devices (tap refresh if not). Pick files and send as usual.

## Troubleshooting

- **Friend doesn't show up:** check both computers are connected in the Tailscale app and can see each other there. Then hit refresh in AmarSend.
- **Still nothing:** add your friend by hand. In the Tailscale app, copy their address (starts with `100.`). In AmarSend, open Favorites on the Send tab and add that address with port `53317`.
- **Windows can find your friend but they can't find you:** the firewall is blocking AmarSend. The Troubleshoot button at the bottom of the Send tab has a one-click fix.

## Building

GitHub Actions does this for you (see `.github/workflows/build.yml`). To build yourself, follow the [LocalSend build instructions](README.localsend.md#building).

## License and credits

AmarSend is based on LocalSend by Tien Do Nam and contributors, licensed under the [Apache License 2.0](LICENSE). See [NOTICE.md](NOTICE.md) for what was changed. AmarSend isn't affiliated with or endorsed by the LocalSend project.
