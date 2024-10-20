import 'dart:typed_data';
import 'bytes_reader.dart';
import 'bytes_writer.dart';

class WavAcid {
  final double bpm;

  WavAcid({required this.bpm});

  Uint8List asBytes() {
    final writer = BytesWriter()
      ..writeUint32(0)
      ..writeUint32(0)
      ..writeUint32(0)
      ..writeUint32(0)
      ..writeUint32(0)
      ..writeFloat32(bpm);
    return writer.takeBytes();
  }

  factory WavAcid.parse(BytesReader reader) {
    reader
      ..readUint32()
      ..readUint32()
      ..readUint32()
      ..readUint32()
      ..readUint32();

    return WavAcid(
      bpm: reader.readFloat32(),
    );
  }
}
