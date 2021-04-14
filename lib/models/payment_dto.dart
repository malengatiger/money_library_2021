/*
public Links _links;
    public String id;
    public String paging_token;
    public Boolean transaction_successful;
    public String source_account;
    public String type;
    public String created_at;
    public String transaction_hash;
    public String asset_type;
    public String asset_code;
    public String asset_issuer;
    public String from;
    public String to;
    public String amount;
 */
class PaymentDTO {
  // ignore: non_constant_identifier_names
  String source_account,
      id,
      // ignore: non_constant_identifier_names
      paging_token,
      // ignore: non_constant_identifier_names
      type,
      created_at,
      transaction_hash,
      asset_type,
      asset_code,
      asset_issuer,
      from,
      to,
      amount;
  // ignore: non_constant_identifier_names
  bool transaction_successful;

  PaymentDTO(
      {this.source_account,
      this.id,
      this.paging_token,
      this.type,
      this.created_at,
      this.transaction_hash,
      this.asset_type,
      this.asset_code,
      this.asset_issuer,
      this.from,
      this.to,
      this.amount,
      this.transaction_successful});

  PaymentDTO.fromJson(Map data) {
    this.source_account = data['source_account'];
    this.id = data['id'];
    this.paging_token = data['paging_token'];
    this.type = data['type'];
    this.created_at = data['created_at'];
    this.transaction_successful = data['transaction_successful'];

    this.transaction_hash = data['transaction_hash'];
    this.asset_type = data['asset_type'];
    this.asset_code = data['asset_code'];
    this.asset_issuer = data['asset_issuer'];
    this.from = data['from'];
    this.to = data['to'];
    this.amount = data['amount'];
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'source_account': source_account,
      'id': id,
      'paging_token': paging_token,
      'type': type,
      'created_at': created_at,
      'transaction_successful': transaction_successful,
      'transaction_hash': transaction_hash,
      'asset_type': asset_type,
      'asset_code': asset_code,
      'asset_issuer': asset_issuer,
      'from': from,
      'to': to,
      'amount': amount,
    };
    return map;
  }
}
