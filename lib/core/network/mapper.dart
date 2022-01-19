abstract class Mapper {
  fromJson(String jsonString);
  String toJson<T>(T object);
}