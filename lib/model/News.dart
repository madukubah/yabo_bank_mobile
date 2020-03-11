class News {
  final int id;
  final String title;
  final String image;
  final String preview;
  final String createdAt;

  News(
      {
        this.id ,
        this.title ,
        this.image ,
        this.preview ,
        this.createdAt ,
      });

  News.fromMap(Map<String, dynamic> map)
      : 
      id          = map['id']    , 
      title       = map['title']   ,  
      image       = map['image']   ,  
      preview     = map['preview']   ,  
      createdAt  = map['created_at']  ;
}