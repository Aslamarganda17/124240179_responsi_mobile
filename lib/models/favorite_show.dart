import 'package:hive/hive.dart';

/// Model yang disimpan di Hive.
/// Adapter ditulis manual (hasilnya sama dengan yang digenerate build_runner),
/// jadi TIDAK perlu menjalankan `dart run build_runner build`.
class FavoriteShow {
  final int id;
  final String name;
  final String? image;
  final double? rating;

  FavoriteShow({
    required this.id,
    required this.name,
    this.image,
    this.rating,
  });
}

class FavoriteShowAdapter extends TypeAdapter<FavoriteShow> {
  @override
  final int typeId = 0;

  @override
  FavoriteShow read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoriteShow(
      id: fields[0] as int,
      name: fields[1] as String,
      image: fields[2] as String?,
      rating: fields[3] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, FavoriteShow obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.image)
      ..writeByte(3)
      ..write(obj.rating);
  }
}
