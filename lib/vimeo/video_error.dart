/// Error on getting vimeo meta data from vimeo server.
class VideoError extends Error {
  final String? error;
  final String? link;
  final String? developerMessage;
  final int? errorCode;

  VideoError({this.error, this.link, this.developerMessage, this.errorCode});

  String toString() {
    if (error != null) {
      return "getting vimeo information failed: ${Error.safeToString(error)}";
    }
    return "getting vimeo information failed";
  }

  factory VideoError.fromJsonAuth(Map<String, dynamic> json) {
    return VideoError(
      error: json['error'],
      link: json['link'],
      developerMessage: json['developer_message'],
      errorCode: json['error_code'],
    );
  }

  factory VideoError.fromJsonNoneAuth(Map<String, dynamic> json) {
    return VideoError(
      error: json['message'],
      link: null,
      developerMessage: json['title'],
      errorCode: null,
    );
  }
}
