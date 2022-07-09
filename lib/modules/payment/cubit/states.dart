abstract class PaymentStates{}

class PaymentInitalState extends PaymentStates{}

class PaymentSuccessState extends PaymentStates{}

class PaymentErrorState extends PaymentStates{
  String error;
  PaymentErrorState(this.error);
}

class PaymentOrderIDSuccessState extends PaymentStates{}

class PaymentOrderIDErrorState extends PaymentStates{
  String error;
  PaymentOrderIDErrorState(this.error);
}

class PaymentRequestTokenSuccessState extends PaymentStates{}

class PaymentRequestTokenErrorState extends PaymentStates{
  String error;
  PaymentRequestTokenErrorState(this.error);
}

class PaymentRequestWalletTokenSuccessState extends PaymentStates{}

class PaymentRequestWalletTokenErrorState extends PaymentStates{
  String error;
  PaymentRequestWalletTokenErrorState(this.error);
}