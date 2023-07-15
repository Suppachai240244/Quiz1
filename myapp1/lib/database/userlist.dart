class User {
  late String name;
  late int age;
  late String email;
  late String province;
  late int idcard;

  static const tableName = 'users';
  static const colName = 'name';
  static const colage = 'age';
  static const colemail = 'email';
  static const colprovince = 'province'; 
  static const colidcard = 'idcard';


  User(
      {required this.name,
      required this.age,
      required this.email,
      required this.province,
      required this.idcard});

  Map<String, dynamic> toMap(){
    var mapData = <String, dynamic>{
      colName:name,
      colage:age,
      colemail:email,
      colprovince:province,
      colidcard:idcard
    };
    return mapData;
  }
}