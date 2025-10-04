class ApiService {
  final String _baseUrl;
  
  ApiService(this._baseUrl);
  
  String getErrorMessage(dynamic error) {
    if (error is String) {
      return error;
    } else if (error.toString().contains('Connection refused') ||
        error.toString().contains('SocketException')) {
      return 'No internet connection. Please check your network and try again.';
    } else if (error.toString().contains('404')) {
      return 'Requested resource not found.';
    } else if (error.toString().contains('401')) {
      return 'Unauthorized access. Please login again.';
    } else if (error.toString().contains('403')) {
      return 'Access forbidden.';
    } else if (error.toString().contains('500')) {
      return 'Server error. Please try again later.';
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }
}