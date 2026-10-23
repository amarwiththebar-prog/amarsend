import 'dart:convert';
import 'dart:io';

import 'package:logging/logging.dart';

final _logger = Logger('TailscaleHelper');

/// AmarSend: finds the other computers on the user's Tailscale network.
///
/// Campus and other managed Wi-Fi networks often isolate devices from each
/// other, so multicast discovery and direct connections fail even when both
/// devices are on the same network. Tailscale gives each device an address
/// (100.x.y.z) that works anyway. This helper reads the list of online peers
/// from the Tailscale command line tool so they can be probed like favorites.
///
/// Returns an empty list when Tailscale is not installed or not running.
Future<List<String>> getTailscalePeerIps() async {
  final cached = _cache;
  if (cached != null && DateTime.now().difference(cached.time) < _cacheDuration) {
    return cached.ips;
  }

  final ips = await _readPeerIps();
  _cache = (time: DateTime.now(), ips: ips);
  return ips;
}

const _cacheDuration = Duration(seconds: 20);
({DateTime time, List<String> ips})? _cache;

/// Where the Tailscale command line tool usually lives on each platform.
List<String> _candidateExecutables() {
  if (Platform.isWindows) {
    return [
      'tailscale',
      r'C:\Program Files\Tailscale\tailscale.exe',
    ];
  }
  if (Platform.isMacOS) {
    return [
      '/Applications/Tailscale.app/Contents/MacOS/Tailscale',
      '/usr/local/bin/tailscale',
      '/opt/homebrew/bin/tailscale',
    ];
  }
  if (Platform.isLinux) {
    return ['tailscale', '/usr/bin/tailscale', '/usr/local/bin/tailscale'];
  }
  return const [];
}

Future<List<String>> _readPeerIps() async {
  for (final executable in _candidateExecutables()) {
    try {
      final result = await Process.run(
        executable,
        ['status', '--json'],
        stdoutEncoding: utf8,
      ).timeout(const Duration(seconds: 4));

      if (result.exitCode != 0) {
        // Installed but not logged in or not running.
        _logger.fine('tailscale status exited with ${result.exitCode}: ${result.stderr}');
        return const [];
      }

      final ips = parseTailscalePeerIps(result.stdout as String);
      _logger.info('Found ${ips.length} online Tailscale peer(s)');
      return ips;
    } catch (e) {
      // Not found at this location, try the next one.
      _logger.fine('Could not run $executable', e);
    }
  }
  return const [];
}

/// Extracts the IPv4 addresses of online peers from `tailscale status --json`.
List<String> parseTailscalePeerIps(String json) {
  Object? decoded;
  try {
    decoded = jsonDecode(json);
  } catch (_) {
    return const [];
  }
  if (decoded is! Map<String, dynamic>) {
    return const [];
  }

  final peers = decoded['Peer'];
  if (peers is! Map<String, dynamic>) {
    return const [];
  }

  final ips = <String>[];
  for (final peer in peers.values) {
    if (peer is! Map<String, dynamic>) {
      continue;
    }
    if (peer['Online'] == false) {
      continue;
    }
    final addresses = peer['TailscaleIPs'];
    if (addresses is! List) {
      continue;
    }
    for (final address in addresses) {
      // LocalSend's discovery probes IPv4 addresses.
      if (address is String && InternetAddress.tryParse(address)?.type == InternetAddressType.IPv4) {
        ips.add(address);
        break;
      }
    }
  }
  return ips;
}
