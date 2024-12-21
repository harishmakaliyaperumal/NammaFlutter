// network_utils.dart
import 'dart:io';

class NetworkUtils {
  static Future<bool> checkConnection() async {
    try {
      // Try multiple DNS servers
      final servers = [
        '8.8.8.8',    // Google DNS
        '1.1.1.1',    // Cloudflare DNS
        '208.67.222.222'  // OpenDNS
      ];

      for (final server in servers) {
        try {
          final result = await InternetAddress.lookup(
            'generativelanguage.googleapis.com',
            type: InternetAddressType.any,
          );
          if (result.isNotEmpty) {
            print('Successfully resolved using DNS server: $server');
            return true;
          }
        } catch (e) {
          print('Failed with DNS server $server: $e');
          continue;
        }
      }
      return false;
    } catch (e) {
      print('Network check failed: $e');
      return false;
    }
  }
}