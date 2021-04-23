import 'agent.dart';

/*
private String loanId, clientId, agentId, anchorId;
    private String date, amount, agentSeed, clientAccount, assetCode, lastDatePaid, lastPaymentRequestId;
    private int loanPeriodInMonths, loanPeriodInWeeks;
    private int startMonth, endMonth;
    private double interestRate;
    private boolean approvedByAgent, paid, approvedByClient;
    private String totalAmountPayable, weeklyPayment, monthlyPayment,
    clientApprovalDate, agentApprovalDate;
 */
class LoanApplication {
  //TODO - COMPLETE class definition ...
  String? anchorId, agentId;
  String? clientId, loanId, totalAmountPayable;
  int? loanPeriodInMonths;
  double? interestRate;
  String? date,
      agentSeed,
      clientAccount,
      assetCode,
      lastDatePaid,
      lastPaymentRequestId;
  PersonalKYCFields? personalKYCFields;

  LoanApplication(
      this.anchorId,
      this.agentId,
      this.clientId,
      this.loanId,
      this.date,
      this.agentSeed,
      this.clientAccount,
      this.assetCode,
      this.interestRate,
      this.totalAmountPayable,
      this.lastDatePaid,
      this.lastPaymentRequestId,
      this.loanPeriodInMonths,
      this.personalKYCFields); //
  //

  LoanApplication.fromJson(Map data) {
    this.anchorId = data['anchorId'];
    this.agentId = data['agentId'];
    this.clientId = data['clientId'];
    this.loanId = data['loanId'];
    this.date = data['date'];
    this.agentSeed = data['agentSeed'];
    this.clientAccount = data['clientAccount'];
    this.assetCode = data['assetCode'];
    this.interestRate = data['interestRate'];
    this.totalAmountPayable = data['totalAmountPayable'];

    this.lastPaymentRequestId = data['lastPaymentRequestId'];
    this.loanPeriodInMonths = data['loanPeriodInMonths'];
    if (data['personalKYCFields'] != null) {
      this.personalKYCFields =
          PersonalKYCFields.fromJson(data['personalKYCFields']);
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = Map();
    map['anchorId'] = anchorId;
    map['agentId'] = agentId;
    map['clientId'] = clientId;
    map['loanId'] = loanId;
    map['date'] = date;
    map['agentSeed'] = agentSeed;
    map['clientAccount'] = clientAccount;
    map['assetCode'] = assetCode;
    map['interestRate'] = interestRate;
    map['totalAmountPayable'] = totalAmountPayable;

    map['lastPaymentRequestId'] = lastPaymentRequestId;
    map['loanPeriodInMonths'] = loanPeriodInMonths;
    map['personalKYCFields'] =
        personalKYCFields == null ? null : personalKYCFields!.toJson();

    return map;
  }
}
