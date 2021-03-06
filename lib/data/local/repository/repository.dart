
typedef SuccessCallback<T> = Function(T);
typedef FailCallback = Function(String);

abstract class Repository<T> {

  Future<List<T>> findAllDataWith(int id);
  void upsert(T data);
  void remove(T data);

}