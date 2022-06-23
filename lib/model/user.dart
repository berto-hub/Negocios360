
class User{
  final String id;
  final String image;
  final String name;
  final String email;
  final String telephone;
  final String businessName;
  final String tradename;
  final String profCategory;
  final String community;
  final String presentation;
  //
  final String CIF;
  final String address;
  final String CP;
  final String location;
  final String IVA;
  final String IBAN;
  //bills: [req.body.bills],
  final String baseReward;
  //
  //keywords: [req.body.keywords],
  final String password;
  final String cardNumber;
  final String cardType;
  final String cardMonthExpir;
  final String cardYearExpir;
  final String cvc;

  const User(this.CIF, this.CP, this.IBAN, this.IVA, this.address, this.baseReward,
  this.businessName, this.cardMonthExpir,this.cardNumber,this.cardType,
  this.cardYearExpir, this.community, this.cvc, this.email, this.id, this.image, this.location,
  this.name, this.password, this.presentation, this.profCategory, this.telephone, this.tradename
  );

  /*static final empty = User(CIF:null, CP:null, IBAN:null, this.IVA:null, this.address:null, this.baseReward:null,
  this.businessName:null, cardMonthExpir:null,this.cardNumber:null,this.cardType:null,
  this.cardYearExpir:null, this.community:null, this.cvc:null, this.email:'', this.id:'', this.image:null, this.location:null,
  this.name:null, this.password:'', this.presentation:null, this.profCategory:null, this.telephone:null, this.tradename:null);*/

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}