import 'package:crypto_coin/models/Coin.dart';
import 'package:hive_flutter/adapters.dart';

class CoinHiveAdapter extends TypeAdapter<Coin> {
  @override
  final typeId = 0;

  @override
  Coin read(BinaryReader reader) {
    return Coin(
      icon: reader.readString(),
      name: reader.readString(),
      initials: reader.readString(),
      price: reader.readDouble(),
    );
  }

  @override
  void write(BinaryWriter write, Coin obj) {
    write.writeString(obj.icon);
    write.writeString(obj.name);
    write.writeString(obj.initials);
    write.writeDouble(obj.price);
  }
}
