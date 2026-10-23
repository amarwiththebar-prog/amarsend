import 'package:localsend_app/util/native/tailscale_helper.dart';
import 'package:test/test.dart';

void main() {
  group('parseTailscalePeerIps', () {
    test('returns the IPv4 address of each online peer', () {
      const json = '''
{
  "Self": {"HostName": "my-laptop", "TailscaleIPs": ["100.64.0.1"]},
  "Peer": {
    "nodekey:a": {"HostName": "friend-mac", "Online": true, "TailscaleIPs": ["fd7a:115c:a1e0::2", "100.101.2.3"]},
    "nodekey:b": {"HostName": "old-phone", "Online": false, "TailscaleIPs": ["100.99.9.9"]},
    "nodekey:c": {"HostName": "no-ips", "Online": true}
  }
}
''';
      expect(parseTailscalePeerIps(json), ['100.101.2.3']);
    });

    test('returns nothing for invalid or empty output', () {
      expect(parseTailscalePeerIps(''), isEmpty);
      expect(parseTailscalePeerIps('not json'), isEmpty);
      expect(parseTailscalePeerIps('{"Peer": null}'), isEmpty);
      expect(parseTailscalePeerIps('[]'), isEmpty);
    });
  });
}
