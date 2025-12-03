import 'dart:convert';
import 'dart:io';
import 'package:encrypt/encrypt.dart' as encrypt_pkg;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

/// Provides local AES-encrypted file storage using a key saved in SecureStorage.
class EncryptedStorageService {
  static const _keyStorageKey = 'mygf_encryption_key';
  final _secureStorage = const FlutterSecureStorage();

  /// Retrieve or create a 32-byte encryption key.
  Future<encrypt_pkg.Key> _getOrCreateKey() async {
    final existing = await _secureStorage.read(key: _keyStorageKey);
    if (existing != null) {
      return encrypt_pkg.Key(base64Decode(existing));
    }

    final newKey = encrypt_pkg.Key.fromSecureRandom(32);
    await _secureStorage.write(
      key: _keyStorageKey,
      value: base64Encode(newKey.bytes),
    );
    return newKey;
  }

  /// Save bytes to encrypted file; returns the file path.
  Future<String> saveEncryptedBytes(List<int> plainBytes, {String? filename}) async {
    final key = await _getOrCreateKey();
    final iv = encrypt_pkg.IV.fromSecureRandom(12);
    final encrypter = encrypt_pkg.Encrypter(
      encrypt_pkg.AES(key, mode: encrypt_pkg.AESMode.gcm),
    );

    final encrypted = encrypter.encryptBytes(plainBytes, iv: iv);
    final payload = {
      'iv': base64Encode(iv.bytes),
      'data': base64Encode(encrypted.bytes),
    };

    final dir = await getApplicationDocumentsDirectory();
    final id = const Uuid().v4();
    final file = File('${dir.path}/${filename ?? 'file_$id.enc'}');
    await file.writeAsString(jsonEncode(payload), flush: true);
    return file.path;
  }

  /// Read and decrypt file content.
  Future<List<int>> readEncryptedFile(String path) async {
    final file = File(path);
    if (!await file.exists()) throw Exception('File not found: $path');

    final jsonStr = await file.readAsString();
    final Map<String, dynamic> payload = jsonDecode(jsonStr);

    final iv = encrypt_pkg.IV(base64Decode(payload['iv'] as String));
    final data = base64Decode(payload['data'] as String);

    final key = await _getOrCreateKey();
    final encrypter = encrypt_pkg.Encrypter(
      encrypt_pkg.AES(key, mode: encrypt_pkg.AESMode.gcm),
    );

    final decrypted = encrypter.decryptBytes(
      encrypt_pkg.Encrypted(data),
      iv: iv,
    );
    return decrypted;
  }

  /// Deletes the encryption key (⚠️ makes all stored files unreadable)
  Future<void> destroyKey() async {
    await _secureStorage.delete(key: _keyStorageKey);
  }
}