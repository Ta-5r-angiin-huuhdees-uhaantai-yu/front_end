class ResponseBase<T> {
  final bool? success;
  final String? message;
  final String? token;
  final T? data;

  ResponseBase({this.success, this.message, this.data, this.token});
}