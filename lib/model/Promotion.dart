class Promotion {
  final String image;

  Promotion(
      {
        this.image ,
      });

  Promotion.fromMap(Map<String, dynamic> map)
      : image       = map['image']     
         ;
}