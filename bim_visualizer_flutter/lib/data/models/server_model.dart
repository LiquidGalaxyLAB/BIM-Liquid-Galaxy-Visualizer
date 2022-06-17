import 'package:equatable/equatable.dart';

class Server extends Equatable {
  final String? hostname;
  final String? ipAddress;
  final String? password;

  const Server({this.hostname, this.ipAddress, this.password});

  @override
  List<Object?> get props => [hostname, ipAddress, password];

  factory Server.defaultValues() {
    return const Server(
      hostname: '',
      ipAddress: '',
      password: ''
    );
  }

  factory Server.fromJson(Map<String, dynamic> json) {
    return Server(
      hostname: json['hostname'],
      ipAddress: json['ipAddress'],
      password: json['password']
    );
  }

  Map<String, dynamic> toJson() => {
    'hostname': hostname,
    'ipAddress': ipAddress,
    'password': password,
  };
}