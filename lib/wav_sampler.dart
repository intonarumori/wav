import 'dart:typed_data';
import 'bytes_reader.dart';
import 'bytes_writer.dart';

class WavSampler {
  final int manufacturer;
  final int product;
  final int samplePeriod;
  final int rootNote;
  final int pitchFraction;
  final int smpteFormat;
  final int smpteOffset;
  final int numberOfSampleLoops;
  final int sampleData;

  WavSampler({
    this.manufacturer = 0,
    this.product = 0,
    this.samplePeriod = 0,
    this.rootNote = 0,
    this.pitchFraction = 0,
    this.smpteFormat = 0,
    this.smpteOffset = 0,
    this.numberOfSampleLoops = 0,
    this.sampleData = 0,
  });

  Uint8List asBytes() {
    final writer = BytesWriter()
          ..writeUint32(manufacturer) // manufacturer
          ..writeUint32(product) // product
          ..writeUint32(samplePeriod) // sample period
          ..writeUint32(rootNote) // MIDI unity note
          ..writeUint32(pitchFraction) // MIDI pitch fraction
          ..writeUint32(smpteFormat) // SMPTE format
          ..writeUint32(smpteOffset) // SMPTE offset
          ..writeUint32(numberOfSampleLoops) // number of sample loops
          ..writeUint32(sampleData) // sample data
        ;
    return writer.takeBytes();
  }

  factory WavSampler.parse(BytesReader reader) {
    return WavSampler(
      manufacturer: reader.readUint32(),
      product: reader.readUint32(),
      samplePeriod: reader.readUint32(),
      rootNote: reader.readUint32(),
      pitchFraction: reader.readUint32(),
      smpteFormat: reader.readUint32(),
      smpteOffset: reader.readUint32(),
      numberOfSampleLoops: reader.readUint32(),
      sampleData: reader.readUint32(),
    );
  }
}
