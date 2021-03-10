class Error {
  /*
      private String message;

    private List<Location> locations = new ArrayList<Location>();

    private List<String> path = new ArrayList<String>();

    private Extensions extensions;
   */
  String message;
  List<Location> locations;
  List<String> path;
  Extensions extensions;

  Error(this.message, this.locations, this.path, this.extensions); //
  //

  Error.fromJson(Map data) {
    this.message = data['message'];
    this.extensions = data['extensions'];

    this.locations = [];
    if (data['locations'] != null) {
      List locs = data['locations'];
      locs.forEach((element) {
        locations.add(Location.fromJson(element));
      });
    }
    this.path = [];
    if (data['path'] != null) {
      List locs = data['path'];
      locs.forEach((element) {
        this.path.add(element);
      });
    }
  }

  Map<String, dynamic> toJson() {
    List mPath = [];
    this.path.forEach((element) {
      mPath.add(element);
    });
    List locs = [];
    this.locations.forEach((element) {
      locs.add(element.toJson());
    });

    Map<String, dynamic> map = Map();
    map['message'] = message;
    map['locations'] = locs;
    map['path'] = mPath;
    map['extensions'] = extensions;

    return map;
  }
}

class Location {
  int line, column;
  Location(
    this.line,
  ); //
  //

  Location.fromJson(Map data) {
    this.line = data['line'];
    this.column = data['column'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = Map();
    map['line'] = line;
    map['column'] = column;

    return map;
  }
}

class Extensions {
  String code;

  Extensions(
    this.code,
  ); //
  //

  Extensions.fromJson(Map data) {
    this.code = data['code'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = Map();
    map['code'] = code;

    return map;
  }
}

class PaymentRequest {
  String id;
  String url;

  PaymentRequest(
    this.id,
    this.url,
  ); //
  //

  PaymentRequest.fromJson(Map data) {
    this.id = data['id'];
    this.url = data['url'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = Map();
    map['id'] = id;
    map['url'] = url;

    return map;
  }
}

class StitchResponse {
  PaymentRequest paymentRequest;
  List<Error> errors;

  StitchResponse(this.paymentRequest, this.errors); //
  //

  StitchResponse.fromJson(Map data) {
    if (data['paymentRequest'] != null) {
      this.paymentRequest = PaymentRequest.fromJson(data['paymentRequest']);
    }
    if (data['errors'] != null) {
      List list = data['errors'];
      if (list != null && list.isNotEmpty) {
        list.forEach((element) {
          this.errors.add(Error.fromJson(element));
        });
      }
    }
  }

  Map<String, dynamic> toJson() {
    List errs = [];
    if (this.errors != null) {
      if (this.errors.isNotEmpty) {
        this.errors.forEach((element) {
          errs.add(element.toJson());
        });
      }
    }
    Map<String, dynamic> map = Map();
    map['paymentRequest'] =
        paymentRequest == null ? null : paymentRequest.toJson();
    map['errors'] = errs;

    return map;
  }
}
