enum Status {
  ok,
  created,
  badRequest,
  unauthorized,
  forbidden,
  notFound,
  ratelimit
}

class HttpException implements Exception {
  Status? status;

  HttpException(int s) {
    status = _statusFromInt(s);
  }

  static Status? _statusFromInt(int status) {
    switch (status) {
      case 200:
        return Status.ok;
      case 201:
        return Status.created;
      case 400:
        return Status.badRequest;
      case 401:
        return Status.unauthorized;
      case 403:
        return Status.forbidden;
      case 404:
        return Status.notFound;
      case 429:
        return Status.ratelimit;
    }
  }

  @override
  String toString() {
    return 'HttpException: $status';
  }

}