import 'dart:convert';

abstract class SignatureModel {
  Map<String, dynamic> toJson();

  String toPrettyJson() => JsonEncoder.withIndent('  ').convert(toJson());
}