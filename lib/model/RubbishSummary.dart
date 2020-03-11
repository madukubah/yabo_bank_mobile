class RubbishSummary {
  final int qty;
  final String name;
  final String image;

  RubbishSummary(
      {
        this.qty ,
        this.name ,
        this.image ,
      });

  RubbishSummary.fromMap(Map<String, dynamic> map)
      : qty          = map['qty'] ,
        name        = map['name'] ,
        image       = map['image']     
         ;
}