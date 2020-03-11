class User {
  final int id;
  final String name;
  final String username;
  final String email;
  final String photo;
  final String identity_photo;
  final String phone;
  final String address;
  final String map_point;
  final String userable_type;
  final int userable_id;
  final int status;
  final String token;
  int balance;

  User(
      {
        this.id,
        this.name,
        this.username,
        this.email,
        this.photo,
        this.identity_photo,
        this.phone,
        this.address,
        this.map_point,
        this.userable_type,
        this.userable_id,
        this.status,
        this.token,
        this.balance = 0 ,
      });

  User.fromMap(Map<String, dynamic> map)
      : id              = map['id'] ,
        name            = map['name'] ,
        username        = map['username'] ,
        email           = map['email'] ,
        photo           = map['photo'] ,
        identity_photo  = map['identity_photo'] ,
        phone           = map['phone'] ,
        address         = map['address'] ,
        map_point       = map['map_point'] ,
        userable_type   = map['userable_type'] ,
        userable_id     = map['userable_id'] ,
        status          = ( map['status'] == null ) ? null: map['status'] ,
        balance         = ( map['balance'] == null ) ? 0: map['balance'] ,
        token           = map['token'] ;
}
