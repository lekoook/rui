import 'builtin_interfaces.dart';

class Bool {
  final bool data;

  const Bool({required this.data});

  static const zero = Bool(data: false);

  factory Bool.fromJson(Map<String, dynamic> json) {
    return Bool(data: json['data'] as bool);
  }

  Map<String, dynamic> toJson() => {'data': data};
}

class Byte {
  final int data;

  const Byte({required this.data});

  static const zero = Byte(data: 0);

  factory Byte.fromJson(Map<String, dynamic> json) {
    return Byte(data: (json['data'] as num).toInt());
  }

  Map<String, dynamic> toJson() => {'data': data};
}

class ByteMultiArray {
  final MultiArrayLayout layout;
  final List<int> data;

  const ByteMultiArray({required this.layout, required this.data});

  static const zero = ByteMultiArray(layout: MultiArrayLayout.zero, data: []);

  factory ByteMultiArray.fromJson(Map<String, dynamic> json) {
    return ByteMultiArray(
      layout: MultiArrayLayout.fromJson(json['layout'] as Map<String, dynamic>),
      data: (json['data'] as List<dynamic>).map((e) => (e as num).toInt()).toList(),
    );
  }

  Map<String, dynamic> toJson() => {'layout': layout.toJson(), 'data': data};
}

class Char {
  final int data;

  const Char({required this.data});

  static const zero = Char(data: 0);

  factory Char.fromJson(Map<String, dynamic> json) {
    return Char(data: (json['data'] as num).toInt());
  }

  Map<String, dynamic> toJson() => {'data': data};
}

class ColorRGBA {
  final double r;
  final double g;
  final double b;
  final double a;

  const ColorRGBA({required this.r, required this.g, required this.b, required this.a});

  static const zero = ColorRGBA(r: 0, g: 0, b: 0, a: 0);

  factory ColorRGBA.fromJson(Map<String, dynamic> json) {
    return ColorRGBA(
      r: (json['r'] as num).toDouble(),
      g: (json['g'] as num).toDouble(),
      b: (json['b'] as num).toDouble(),
      a: (json['a'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {'r': r, 'g': g, 'b': b, 'a': a};
}

class Empty {
  const Empty();

  static const zero = Empty();

  factory Empty.fromJson(Map<String, dynamic> json) => const Empty();

  Map<String, dynamic> toJson() => {};
}

class Float32 {
  final double data;

  const Float32({required this.data});

  static const zero = Float32(data: 0);

  factory Float32.fromJson(Map<String, dynamic> json) {
    return Float32(data: (json['data'] as num).toDouble());
  }

  Map<String, dynamic> toJson() => {'data': data};
}

class Float32MultiArray {
  final MultiArrayLayout layout;
  final List<double> data;

  const Float32MultiArray({required this.layout, required this.data});

  static const zero = Float32MultiArray(layout: MultiArrayLayout.zero, data: []);

  factory Float32MultiArray.fromJson(Map<String, dynamic> json) {
    return Float32MultiArray(
      layout: MultiArrayLayout.fromJson(json['layout'] as Map<String, dynamic>),
      data: (json['data'] as List<dynamic>).map((e) => (e as num).toDouble()).toList(),
    );
  }

  Map<String, dynamic> toJson() => {'layout': layout.toJson(), 'data': data};
}

class Float64 {
  final double data;

  const Float64({required this.data});

  static const zero = Float64(data: 0);

  factory Float64.fromJson(Map<String, dynamic> json) {
    return Float64(data: (json['data'] as num).toDouble());
  }

  Map<String, dynamic> toJson() => {'data': data};
}

class Float64MultiArray {
  final MultiArrayLayout layout;
  final List<double> data;

  const Float64MultiArray({required this.layout, required this.data});

  static const zero = Float64MultiArray(layout: MultiArrayLayout.zero, data: []);

  factory Float64MultiArray.fromJson(Map<String, dynamic> json) {
    return Float64MultiArray(
      layout: MultiArrayLayout.fromJson(json['layout'] as Map<String, dynamic>),
      data: (json['data'] as List<dynamic>).map((e) => (e as num).toDouble()).toList(),
    );
  }

  Map<String, dynamic> toJson() => {'layout': layout.toJson(), 'data': data};
}

class Header {
  final BuiltinInterfacesTime stamp;
  final String frameId;

  const Header({required this.stamp, required this.frameId});

  static const zero = Header(stamp: BuiltinInterfacesTime.zero, frameId: '');

  factory Header.fromJson(Map<String, dynamic> json) {
    return Header(
      stamp: BuiltinInterfacesTime.fromJson(json['stamp'] as Map<String, dynamic>),
      frameId: json['frame_id'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'stamp': stamp.toJson(), 'frame_id': frameId};
}

class Int16 {
  final int data;

  const Int16({required this.data});

  static const zero = Int16(data: 0);

  factory Int16.fromJson(Map<String, dynamic> json) {
    return Int16(data: (json['data'] as num).toInt());
  }

  Map<String, dynamic> toJson() => {'data': data};
}

class Int16MultiArray {
  final MultiArrayLayout layout;
  final List<int> data;

  const Int16MultiArray({required this.layout, required this.data});

  static const zero = Int16MultiArray(layout: MultiArrayLayout.zero, data: []);

  factory Int16MultiArray.fromJson(Map<String, dynamic> json) {
    return Int16MultiArray(
      layout: MultiArrayLayout.fromJson(json['layout'] as Map<String, dynamic>),
      data: (json['data'] as List<dynamic>).map((e) => (e as num).toInt()).toList(),
    );
  }

  Map<String, dynamic> toJson() => {'layout': layout.toJson(), 'data': data};
}

class Int32 {
  final int data;

  const Int32({required this.data});

  static const zero = Int32(data: 0);

  factory Int32.fromJson(Map<String, dynamic> json) {
    return Int32(data: (json['data'] as num).toInt());
  }

  Map<String, dynamic> toJson() => {'data': data};
}

class Int32MultiArray {
  final MultiArrayLayout layout;
  final List<int> data;

  const Int32MultiArray({required this.layout, required this.data});

  static const zero = Int32MultiArray(layout: MultiArrayLayout.zero, data: []);

  factory Int32MultiArray.fromJson(Map<String, dynamic> json) {
    return Int32MultiArray(
      layout: MultiArrayLayout.fromJson(json['layout'] as Map<String, dynamic>),
      data: (json['data'] as List<dynamic>).map((e) => (e as num).toInt()).toList(),
    );
  }

  Map<String, dynamic> toJson() => {'layout': layout.toJson(), 'data': data};
}

class Int64 {
  final int data;

  const Int64({required this.data});

  static const zero = Int64(data: 0);

  factory Int64.fromJson(Map<String, dynamic> json) {
    return Int64(data: (json['data'] as num).toInt());
  }

  Map<String, dynamic> toJson() => {'data': data};
}

class Int64MultiArray {
  final MultiArrayLayout layout;
  final List<int> data;

  const Int64MultiArray({required this.layout, required this.data});

  static const zero = Int64MultiArray(layout: MultiArrayLayout.zero, data: []);

  factory Int64MultiArray.fromJson(Map<String, dynamic> json) {
    return Int64MultiArray(
      layout: MultiArrayLayout.fromJson(json['layout'] as Map<String, dynamic>),
      data: (json['data'] as List<dynamic>).map((e) => (e as num).toInt()).toList(),
    );
  }

  Map<String, dynamic> toJson() => {'layout': layout.toJson(), 'data': data};
}

class Int8 {
  final int data;

  const Int8({required this.data});

  static const zero = Int8(data: 0);

  factory Int8.fromJson(Map<String, dynamic> json) {
    return Int8(data: (json['data'] as num).toInt());
  }

  Map<String, dynamic> toJson() => {'data': data};
}

class Int8MultiArray {
  final MultiArrayLayout layout;
  final List<int> data;

  const Int8MultiArray({required this.layout, required this.data});

  static const zero = Int8MultiArray(layout: MultiArrayLayout.zero, data: []);

  factory Int8MultiArray.fromJson(Map<String, dynamic> json) {
    return Int8MultiArray(
      layout: MultiArrayLayout.fromJson(json['layout'] as Map<String, dynamic>),
      data: (json['data'] as List<dynamic>).map((e) => (e as num).toInt()).toList(),
    );
  }

  Map<String, dynamic> toJson() => {'layout': layout.toJson(), 'data': data};
}

class MultiArrayDimension {
  final String label;
  final int size;
  final int stride;

  const MultiArrayDimension({required this.label, required this.size, required this.stride});

  static const zero = MultiArrayDimension(label: '', size: 0, stride: 0);

  factory MultiArrayDimension.fromJson(Map<String, dynamic> json) {
    return MultiArrayDimension(
      label: json['label'] as String,
      size: (json['size'] as num).toInt(),
      stride: (json['stride'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() => {'label': label, 'size': size, 'stride': stride};
}

class MultiArrayLayout {
  final List<MultiArrayDimension> dim;
  final int dataOffset;

  const MultiArrayLayout({required this.dim, required this.dataOffset});

  static const zero = MultiArrayLayout(dim: [], dataOffset: 0);

  factory MultiArrayLayout.fromJson(Map<String, dynamic> json) {
    return MultiArrayLayout(
      dim: (json['dim'] as List<dynamic>)
          .map((e) => MultiArrayDimension.fromJson(e as Map<String, dynamic>))
          .toList(),
      dataOffset: (json['data_offset'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
        'dim': dim.map((e) => e.toJson()).toList(),
        'data_offset': dataOffset,
      };
}

// String.msg skipped: class name 'String' conflicts with Dart's built-in String type

class UInt16 {
  final int data;

  const UInt16({required this.data});

  static const zero = UInt16(data: 0);

  factory UInt16.fromJson(Map<String, dynamic> json) {
    return UInt16(data: (json['data'] as num).toInt());
  }

  Map<String, dynamic> toJson() => {'data': data};
}

class UInt16MultiArray {
  final MultiArrayLayout layout;
  final List<int> data;

  const UInt16MultiArray({required this.layout, required this.data});

  static const zero = UInt16MultiArray(layout: MultiArrayLayout.zero, data: []);

  factory UInt16MultiArray.fromJson(Map<String, dynamic> json) {
    return UInt16MultiArray(
      layout: MultiArrayLayout.fromJson(json['layout'] as Map<String, dynamic>),
      data: (json['data'] as List<dynamic>).map((e) => (e as num).toInt()).toList(),
    );
  }

  Map<String, dynamic> toJson() => {'layout': layout.toJson(), 'data': data};
}

class UInt32 {
  final int data;

  const UInt32({required this.data});

  static const zero = UInt32(data: 0);

  factory UInt32.fromJson(Map<String, dynamic> json) {
    return UInt32(data: (json['data'] as num).toInt());
  }

  Map<String, dynamic> toJson() => {'data': data};
}

class UInt32MultiArray {
  final MultiArrayLayout layout;
  final List<int> data;

  const UInt32MultiArray({required this.layout, required this.data});

  static const zero = UInt32MultiArray(layout: MultiArrayLayout.zero, data: []);

  factory UInt32MultiArray.fromJson(Map<String, dynamic> json) {
    return UInt32MultiArray(
      layout: MultiArrayLayout.fromJson(json['layout'] as Map<String, dynamic>),
      data: (json['data'] as List<dynamic>).map((e) => (e as num).toInt()).toList(),
    );
  }

  Map<String, dynamic> toJson() => {'layout': layout.toJson(), 'data': data};
}

class UInt64 {
  final int data;

  const UInt64({required this.data});

  static const zero = UInt64(data: 0);

  factory UInt64.fromJson(Map<String, dynamic> json) {
    return UInt64(data: (json['data'] as num).toInt());
  }

  Map<String, dynamic> toJson() => {'data': data};
}

class UInt64MultiArray {
  final MultiArrayLayout layout;
  final List<int> data;

  const UInt64MultiArray({required this.layout, required this.data});

  static const zero = UInt64MultiArray(layout: MultiArrayLayout.zero, data: []);

  factory UInt64MultiArray.fromJson(Map<String, dynamic> json) {
    return UInt64MultiArray(
      layout: MultiArrayLayout.fromJson(json['layout'] as Map<String, dynamic>),
      data: (json['data'] as List<dynamic>).map((e) => (e as num).toInt()).toList(),
    );
  }

  Map<String, dynamic> toJson() => {'layout': layout.toJson(), 'data': data};
}

class UInt8 {
  final int data;

  const UInt8({required this.data});

  static const zero = UInt8(data: 0);

  factory UInt8.fromJson(Map<String, dynamic> json) {
    return UInt8(data: (json['data'] as num).toInt());
  }

  Map<String, dynamic> toJson() => {'data': data};
}

class UInt8MultiArray {
  final MultiArrayLayout layout;
  final List<int> data;

  const UInt8MultiArray({required this.layout, required this.data});

  static const zero = UInt8MultiArray(layout: MultiArrayLayout.zero, data: []);

  factory UInt8MultiArray.fromJson(Map<String, dynamic> json) {
    return UInt8MultiArray(
      layout: MultiArrayLayout.fromJson(json['layout'] as Map<String, dynamic>),
      data: (json['data'] as List<dynamic>).map((e) => (e as num).toInt()).toList(),
    );
  }

  Map<String, dynamic> toJson() => {'layout': layout.toJson(), 'data': data};
}

class StdString {
  final String data;

  const StdString({required this.data});

  static const zero = StdString(data: '');

  factory StdString.fromJson(Map<String, dynamic> json) {
    return StdString(data: json['data'] as String);
  }

  Map<String, dynamic> toJson() => {'data': data};
}
