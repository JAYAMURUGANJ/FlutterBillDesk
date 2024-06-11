class ErrorResponse {
  int? status;
  String? errorType;
  String? errorCode;
  String? message;
  String? description;

  ErrorResponse(
      {this.status,
      this.errorType,
      this.errorCode,
      this.message,
      this.description});

  ErrorResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errorType = json['error_type'];
    errorCode = json['error_code'];
    message = json['message'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['error_type'] = errorType;
    data['error_code'] = errorCode;
    data['message'] = message;
    data['description'] = description;
    return data;
  }

  // Function to get error response based on HTTP status code
  ErrorResponse getErrorResponse(int statusCode) {
    switch (statusCode) {
      case 400:
        return ErrorResponse(
          status: 400,
          errorType: 'invalid_request_error',
          errorCode: 'TRIDE0001',
          message: 'Bad request',
          description: 'The request was invalid or cannot be otherwise served.',
        );
      case 401:
        return ErrorResponse(
          status: 401,
          errorType: 'authentication_error',
          errorCode: 'TRIDE0002',
          message: 'Unauthorized',
          description: 'Authentication credentials were missing or incorrect.',
        );
      case 403:
        return ErrorResponse(
          status: 403,
          errorType: 'inaccessible_resource_error',
          errorCode: 'TRIDE0003',
          message: 'Forbidden',
          description:
              'The request is understood, but it has been refused or access is not allowed.',
        );
      case 404:
        return ErrorResponse(
          status: 404,
          errorType: 'not_found_error',
          errorCode: 'TRIDE0004',
          message: 'Not Found',
          description:
              'The URL requested is invalid or the resource requested does not exist.',
        );
      case 405:
        return ErrorResponse(
          status: 405,
          errorType: 'invalid_method_error',
          errorCode: 'TRIDE0005',
          message: 'Method Not Allowed',
          description: 'The resource doesn\'t support the specified HTTP verb.',
        );
      case 406:
        return ErrorResponse(
          status: 406,
          errorType: 'invalid_request_error',
          errorCode: 'TRIDE0006',
          message: 'Not Acceptable',
          description:
              'Returned when an invalid format is specified in the request.',
        );
      case 409:
        return ErrorResponse(
          status: 409,
          errorType: 'duplicate_request_error',
          errorCode: 'TRIDE0007',
          message: 'Conflict',
          description:
              'Duplicate request. Traceid is duplicate or biller account already exists.',
        );
      case 415:
        return ErrorResponse(
          status: 415,
          errorType: 'invalid_media_type_error',
          errorCode: 'TRIDE0008',
          message: 'Unsupported Media Type',
          description:
              'The server is refusing to service the request because the entity of the request is in a format not supported.',
        );
      case 422:
        return ErrorResponse(
          status: 422,
          errorType: 'invalid_data_error',
          errorCode: 'TRIDE0011',
          message: 'Validation Error',
          description:
              'The request could not be processed due to incorrect/inconsistent parameter values.',
        );
      case 500:
        return ErrorResponse(
          status: 500,
          errorType: 'api_processing_error',
          errorCode: 'TRIDE0009',
          message: 'Internal Server Error',
          description:
              'Some internal error occurred while processing the request.',
        );
      case 502:
        return ErrorResponse(
          status: 502,
          errorType: 'api_connection_error',
          errorCode: 'TRIDE0010',
          message: 'Bad Gateway',
          description: 'Application down.',
        );
      case 504:
        return ErrorResponse(
          status: 504,
          errorType: 'api_connection_error',
          errorCode: 'TRIDE0012',
          message: 'Gateway Timeout',
          description: 'Timeout in the application processing.',
        );
      //user cancellation
      case 0303:
        return ErrorResponse(
          status: 0303,
          errorType: 'user_canceled',
          errorCode: 'USERCANCELLED',
          message: 'User Canceled',
          description: 'user aborted payment the transaction.',
        );
      default:
        return ErrorResponse(
          status: statusCode,
          errorType: 'unknown_error',
          errorCode: 'TRIDE9999',
          message: 'Unknown Error',
          description: 'An unknown error occurred.',
        );
    }
  }
}



//sample
// {
// "status":422,
// "error_type":"invalid_data_error",
// "error_code":"TRIDE0011",
// "message":"Invalid orderid"
// }
