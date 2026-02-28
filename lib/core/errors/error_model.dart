class ErrorModel {
  ErrorModel({required this.message, this.messageAr, required this.errors});

  final String? message;
  final String? messageAr;
  final Errors? errors;

  ErrorModel copyWith({String? message, String? messageAr, Errors? errors}) {
    return ErrorModel(
      message: message ?? this.message,
      messageAr: messageAr ?? this.messageAr,
      errors: errors ?? this.errors,
    );
  }

  factory ErrorModel.fromJson(Map<String, dynamic> json) {
    return ErrorModel(
      message: json["message"],
      messageAr: json["messageAr"],
      errors: json["errors"] == null ? null : Errors.fromJson(json["errors"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "message": message,
    "messageAr": messageAr,
    "errors": errors?.toJson(),
  };
}

class Errors {
  Errors({required this.email, required this.phone});

  final List<String> email;
  final List<String> phone;

  Errors copyWith({List<String>? email, List<String>? phone}) {
    return Errors(email: email ?? this.email, phone: phone ?? this.phone);
  }

  factory Errors.fromJson(Map<String, dynamic> json) {
    return Errors(
      email: json["email"] == null
          ? []
          : List<String>.from(json["email"]!.map((x) => x)),
      phone: json["phone"] == null
          ? []
          : List<String>.from(json["phone"]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
    "email": email.map((x) => x).toList(),
    "phone": phone.map((x) => x).toList(),
  };
}
