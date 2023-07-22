abstract class DataState<T> {
  final T? data;
  final String? message;

  DataState({this.data, this.message});
}

class DataSuccess<T> extends DataState<T> {
  DataSuccess(T data) : super(data: data);
}

class DataError<T> extends DataState<T> {
  DataError(String message) : super(message: message);
}
