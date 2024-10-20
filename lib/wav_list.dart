import 'dart:typed_data';

import 'bytes_reader.dart';
import 'bytes_writer.dart';
import 'wav_file.dart';

class WavList {
  final List<WavListChunk> chunks;

  const WavList({required this.chunks});

  Uint8List asBytes() {
    final dataList = chunks.map((e) => e.asBytes());
    final size = dataList.fold<int>(0, (a, b) => a + b.length);

    final writer = BytesWriter()
      ..writeString(Wav.listHeader)
      ..writeUint32(size + 4) // account for `INFO`
      ..writeString(Wav.infoHeader);

    for (final data in dataList) {
      writer.writeBytes(data);
    }
    return writer.takeBytes();
  }

  factory WavList.parse(Uint8List bytes) {
    final reader = BytesReader(bytes);
    List<WavListChunk> chunks = [];
    while (reader.hasData) {
      final chunkType = reader.readString(4);
      final size = reader.readUint32();
      final data = reader.readBytes(size);
      chunks.add(WavListChunk(tag: chunkType, data: data));
    }
    return WavList(chunks: chunks);
  }

  @override
  String toString() {
    return '[WavList chunks:$chunks]';
  }
}

class WavListChunk {
  final String tag;
  final Uint8List data;

  const WavListChunk({required this.tag, required this.data});

  Uint8List asBytes() {
    final remainder = data.length % 4;
    final paddingLength = remainder > 0 ? 4 - remainder : 4;
    final size = data.length + paddingLength;

    final writer = BytesWriter()
      ..writeString(tag)
      ..writeUint32(size)
      ..writeBytes(data);
    for (var i = 0; i < paddingLength; i++) {
      writer.writeUint8(0);
    }
    return writer.takeBytes();
  }

  @override
  String toString() {
    return '[WavListCustomData tag:$tag data:${data.length}]';
  }
}
