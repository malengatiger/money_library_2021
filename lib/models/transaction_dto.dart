/*
@JsonProperty("ledger")
    public Integer ledger;
    @JsonProperty("fee_charged")
    public String fee_charged;
    @JsonProperty("memo_type")
    public String memo_type;
    @JsonProperty("_links")
    public Links _links;
    @JsonProperty("source_account_sequence")
    public String source_account_sequence;
    @JsonProperty("memo")
    public String memo;
    @JsonProperty("created_at")
    public String created_at;
    @JsonProperty("fee_meta_xdr")
    public String fee_meta_xdr;
    @JsonProperty("source_account")
    public String source_account;
    @JsonProperty("result_xdr")
    public String result_xdr;
    @JsonProperty("signatures")
    public List<String> signatures = new ArrayList<String>();
    @JsonProperty("fee_account")
    public String fee_account;
    @JsonProperty("paging_token")
    public String paging_token;
    @JsonProperty("valid_after")
    public String valid_after;
    @JsonProperty("memo_bytes")
    public String memo_bytes;
    @JsonProperty("valid_before")
    public String valid_before;
    @JsonProperty("envelope_xdr")
    public String envelope_xdr;
    @JsonProperty("id")
    public String id;
    @JsonProperty("operation_count")
    public Integer operation_count;
    @JsonProperty("result_meta_xdr")
    public String result_meta_xdr;
    @JsonProperty("hash")
    public String hash;
    @JsonProperty("max_fee")
    public String max_fee;
    @JsonProperty("successful")
    public Boolean successful;
 */
class TransactionDTO {
  // ignore: non_constant_identifier_names
  String fee_charged,
      id,
      memo,
      fee_account,
      paging_token,
      source_account,
      hash,
      created_at;
  bool successful;
  int operation_count;

  TransactionDTO(
      {this.fee_charged,
      this.id,
      this.memo,
      this.fee_account,
      this.paging_token,
      this.source_account,
      this.hash,
      this.created_at,
      this.successful,
      this.operation_count});

  TransactionDTO.fromJson(Map data) {
    this.fee_charged = data['fee_charged'];
    this.id = data['id'];
    this.memo = data['memo'];
    this.fee_account = data['fee_account'];
    this.paging_token = data['paging_token'];
    this.source_account = data['source_account'];
    this.hash = data['hash'];
    this.successful = data['successful'];
    this.created_at = data['created_at'];
    this.operation_count = data['operation_count'];
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'fee_charged': fee_charged,
      'id': id,
      'memo': memo,
      'fee_account': fee_account,
      'source_account': source_account,
      'successful': successful,
      'paging_token': paging_token,
      'created_at': created_at,
      'operation_count': operation_count,
      'hash': hash,
    };
    return map;
  }
}
