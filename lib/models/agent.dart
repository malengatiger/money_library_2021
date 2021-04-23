class Agent {
  String? anchorId, agentId;
  double? latitude, longitude;
  String? dateRegistered,
      dateUpdated,
      externalAccountId,
      stellarAccountId,
      organizationId,
      fiatBalance,
      fiatLimit,
      password,
      url,
      secretSeed;
  bool? fakeImage;
  PersonalKYCFields? personalKYCFields;

  Agent(
      this.anchorId,
      this.agentId,
      this.latitude,
      this.longitude,
      this.dateRegistered,
      this.dateUpdated,
      this.externalAccountId,
      this.stellarAccountId,
      this.organizationId,
      this.fiatBalance,
      this.fiatLimit,
      this.password,
      this.secretSeed,
      this.url,
      this.personalKYCFields); //
  //

  Agent.fromJson(Map data) {
    this.anchorId = data['anchorId'];
    this.agentId = data['agentId'];
    this.latitude = data['latitude'];
    this.longitude = data['longitude'];
    this.dateRegistered = data['dateRegistered'];
    this.dateUpdated = data['dateUpdated'];
    this.externalAccountId = data['externalAccountId'];
    this.stellarAccountId = data['stellarAccountId'];
    this.organizationId = data['organizationId'];
    this.fiatBalance = data['fiatBalance'];
    this.url = data['url'];
    this.fakeImage = data['fakeImage'];

    this.password = data['password'];
    this.secretSeed = data['secretSeed'];
    if (data['personalKYCFields'] != null) {
      this.personalKYCFields =
          PersonalKYCFields.fromJson(data['personalKYCFields']);
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = Map();
    map['anchorId'] = anchorId;
    map['agentId'] = agentId;
    map['latitude'] = latitude;
    map['longitude'] = longitude;
    map['dateRegistered'] = dateRegistered;
    map['dateUpdated'] = dateUpdated;
    map['externalAccountId'] = externalAccountId;
    map['stellarAccountId'] = stellarAccountId;
    map['organizationId'] = organizationId;
    map['fiatBalance'] = fiatBalance;
    map['fakeImage'] = fakeImage;
    map['url'] = url;
    map['password'] = password;
    map['secretSeed'] = secretSeed;
    map['personalKYCFields'] =
        personalKYCFields == null ? null : personalKYCFields!.toJson();

    return map;
  }
}

class PersonalKYCFields {
  String? lastName,
      firstName,
      mobileNumber,
      emailAddress,
      birthDate,
      bankAccountNumber,
      bankNumber,
      address,
      bankPhoneNumber;

//  String id_type, id_country_code, id_issue_date, id_number, language_code, tax_id, tax_id_name;
//
  String? photo_proof_residence,
      photo_id_front,
      photo_id_back,
      notary_approval_of_photo_id,
      selfie;

  PersonalKYCFields.create();

  PersonalKYCFields.fromJson(Map data) {
    this.lastName = data['last_name'];
    this.firstName = data['first_name'];
    this.mobileNumber = data['mobile_number'];
    this.emailAddress = data['email_address'];
    this.birthDate = data['birth_date'];
    this.bankAccountNumber = data['bank_account_number'];
    this.bankNumber = data['bank_number'];
    this.address = data['address'];
    this.bankPhoneNumber = data['bank_phone_number'];

    this.photo_proof_residence = data['photo_proof_residence'];
    this.photo_id_front = data['photo_id_front'];
    this.photo_id_back = data['photo_id_back'];
    this.notary_approval_of_photo_id = data['notary_approval_of_photo_id'];
    this.selfie = data['selfie'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = Map();
    map['last_name'] = lastName;
    map['first_name'] = firstName;
    map['mobile_number'] = mobileNumber;
    map['email_address'] = emailAddress;
    map['birth_date'] = birthDate;
    map['bank_account_number'] = bankAccountNumber;
    map['bank_number'] = bankNumber;
    map['address'] = address;
    map['bank_phone_number'] = bankPhoneNumber;

    map['photo_proof_residence'] = photo_proof_residence;
    map['photo_id_front'] = photo_id_front;
    map['photo_id_back'] = photo_id_back;
    map['notary_approval_of_photo_id'] = notary_approval_of_photo_id;
    map['selfie'] = selfie;

    return map;
  }

  String getFullName() {
    return firstName! + " " + lastName!;
  }
}
