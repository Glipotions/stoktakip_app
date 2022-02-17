import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class IpHost {
  IpHost({
    required this.hostAdi,
    required this.ip,
  });

  String hostAdi;
  String ip;

  factory IpHost.fromJson(Map<String, dynamic> json) => IpHost(
        hostAdi: json["hostAdi"],
        ip: json["ip"],
      );

  static Map<String, dynamic> toMap(IpHost ipHost) => {
        "hostAdi": ipHost.hostAdi,
        "ip": ipHost.ip,
      };

  static String encode(List<IpHost> ipHosts) => json.encode(
        ipHosts
            .map<Map<String, dynamic>>((ipHosts) => IpHost.toMap(ipHosts))
            .toList(),
      );

  static List<IpHost> decode(String ipHosts) =>
      (json.decode(ipHosts) as List<dynamic>)
          .map<IpHost>((item) => IpHost.fromJson(item))
          .toList();
}
