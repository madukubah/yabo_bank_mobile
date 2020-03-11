import 'package:url_launcher/url_launcher.dart';
import 'package:yabo_bank/activity/feed/presenter/FeedPresenter.dart';
import 'package:yabo_bank/activity/feed/view/FeedMVPView.dart';
import 'package:flutter/material.dart';
import 'package:yabo_bank/data/network/ApiEndPoint.dart';
import 'package:yabo_bank/data/network/AppApiHelper.dart';
import 'package:yabo_bank/data/preferences/AppPreferenceHelper.dart';
import 'package:yabo_bank/model/News.dart';
import 'package:yabo_bank/model/Promotion.dart';
import 'package:yabo_bank/model/RubbishSummary.dart';
import 'package:yabo_bank/model/User.dart';
import 'package:yabo_bank/util/AppConstants.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:yabo_bank/widget/RubbishWidget.dart';
import 'package:intl/intl.dart';

import 'interactor/FeedInteractor.dart';
import 'interactor/FeedMVPInteractor.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> implements FeedMVPView {
  FeedPresenter<FeedMVPView, FeedMVPInteractor> presenter;

  _FeedState() {
    FeedInteractor interactor = FeedInteractor(
        AppPreferenceHelper.getInstance(), AppApiHelper.getInstance());
    presenter = FeedPresenter<FeedMVPView, FeedMVPInteractor>(interactor);
  }
  List<RubbishSummary> rubbishSummaries = [];
  List<Promotion> promotions = [];
  List<News> news = [];
  RubbishSummary topRubbishSummaries;

  User user;
  bool _isLoading = true;
  String imageProfile = 'assets/images/as.png';

  @override
  void initState() {
    super.initState();
    presenter.onAttach(this);
    presenter.getUser();
    presenter.getRubbishSummary();
    presenter.getPromotions();
    presenter.getNews();
  }

  @override
  Widget build(BuildContext context) {
    var formatter = new NumberFormat.decimalPattern();
    var timeFormatter = new DateFormat('dd MMM yyyy');

    if (_isLoading)
      return new Scaffold(
        body: new Center(
          child: new Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: new CircularProgressIndicator(),
          ),
        ),
      );
    else
      return new Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            presenter.getUser();
            presenter.getRubbishSummary();
            presenter.getPromotions();
            presenter.getNews();
          },
          child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    new Stack(
                      alignment: AlignmentDirectional.topStart,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width * 2 / 4,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height:
                              MediaQuery.of(context).size.width * 2 / 4 - 35,
                          color: AppColor.PRIMARY,
                        ),
                        Positioned(
                          right: 10.0,
                          // bottom: 0,
                          top: 20,
                          child: Container(
                            height: 75.0,
                            width: 75.0,
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: (imageProfile ==
                                      "assets/images/as.png")
                                  ? new ExactAssetImage(imageProfile)
                                  : new NetworkImage(ApiEndPoint
                                          .USER_PROFILE_PHOTO +
                                      "/$imageProfile"), // no matter how big it is, it won't overflow
                            ),
                          ),
                        ),
                        Positioned(
                          left: 10,
                          // right: 0,
                          top: 35,
                          child: Container(
                            // color: Colors.pink,
                            height: 100.0,
                            width: MediaQuery.of(context).size.width * 5 / 6,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Hai, ${this.user.name}",
                                  style: TextStyle(
                                    inherit: true,
                                    fontSize: 22,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  "Sudah menabungkah anda hari ini ?",
                                  style: TextStyle(
                                    inherit: true,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          // bottom: ( MediaQuery.of(context).size.height / 8 ) / 2,
                          bottom: 2,
                          left: 10.0,
                          right: 10.0,
                          child: Container(
                            height:
                                70, //MediaQuery.of(context).size.height / 12,
                            decoration: BoxDecoration(
                              boxShadow: [
                                new BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 5.0,
                                ),
                              ],
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20)),
                            ),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              child: Container(
                                color: Colors.white,
                                child: Center(
                                  child: Text(
                                    "Saldo : Rp ${formatter.format(user.balance)}",
                                    style: TextStyle(
                                      inherit: true,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 8.0),
                          Text(
                            'Promo',
                            style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4.0),
                          (promotions.length < 1)
                              ? SizedBox()
                              : CarouselSlider(
                                  // onPageChanged: (index) {
                                  //   setState(() {
                                  //     // _current = index;
                                  //   });
                                  // },
                                  // autoPlay: false,
                                  // autoPlayInterval: Duration(seconds: 5),
                                  items: promotions.map((i) {
                                    return Builder(
                                        builder: (BuildContext context) {
                                      return Stack(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10.0),
                                            child: Container(
                                              decoration: new BoxDecoration(
                                                boxShadow: [
                                                  new BoxShadow(
                                                    color: Colors.grey,
                                                    blurRadius: 5.0,
                                                  ),
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                image: new DecorationImage(
                                                  image: NetworkImage(
                                                    ApiEndPoint.IKLAN_PPHOTO +
                                                        i.image,
                                                  ),
                                                  fit: BoxFit.fitWidth,
                                                ),
                                              ),
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  1 /
                                                  4,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 4),
                                            ),
                                          ),
                                        ],
                                      );
                                    });
                                  }).toList(),
                                ),
                          SizedBox(height: 8.0),
                          Text(
                            'Berita',
                            style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4.0),
                          Column(
                            children: this.news.map((i) {
                              return Builder(builder: (BuildContext context) {
                                return Container(
                                  decoration: new BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      onTap: () {
                                        print("tap");
                                        launch( ApiEndPoint.ASSETS_URL + 'berita/${i.id}'  );
                                      },
                                      leading: Image.network(
                                        ApiEndPoint.NEWS_IMAGE + i.image,
                                        height: 50,
                                        width: 75,
                                      ),
                                      title: Text("${i.title}"),
                                      subtitle: Text(
                                          "${timeFormatter.format(DateFormat('yyyy-MM-dd', 'en_US').parse(i.createdAt.split(' ')[0]))}"),
                                    ),
                                  ),
                                );
                              });
                            }).toList(),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Statistik Sampah Kamu',
                            style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4.0),
                          Center(
                            child: (topRubbishSummaries == null)
                                ? null
                                : Stack(
                                    alignment: AlignmentDirectional.center,
                                    children: <Widget>[
                                      Container(
                                        width: 220.0,
                                        height: 120.0,
                                        decoration: new BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: new DecorationImage(
                                            image: AssetImage(
                                              '${topRubbishSummaries.image}',
                                            ),
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ),
                                        child: Container(
                                          width: 250.0,
                                          height: 150.0,
                                          decoration: new BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Color.fromARGB(50, 0, 0, 0),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 8,
                                        top: 8,
                                        child:
                                            Text('${topRubbishSummaries.name}',
                                                style: TextStyle(
                                                  inherit: true,
                                                  color: Colors.white,
                                                )),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "${topRubbishSummaries.qty}",
                                            style: TextStyle(
                                              inherit: true,
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            "Kilogram",
                                            style: TextStyle(
                                              inherit: true,
                                              color: Colors.white,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                          ),
                          SizedBox(height: 4.0),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: 100.0,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 18.0, right: 18.0, top: 8, bottom: 8),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: rubbishSummaries.map((i) {
                        return Builder(builder: (BuildContext context) {
                          return RubbishWidget(rubbishSummary: i);
                        });
                      }).toList(),
                    ),
                  ),
                ),
              ),
              // SliverList(
              //     delegate: SliverChildListDelegate([
              //   Padding(
              //     padding: EdgeInsets.only(left: 18.0, right: 18.0),
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: <Widget>[
              //         SizedBox(height: 8.0),
              //         Text(
              //           'Berita',
              //           style: TextStyle(
              //               fontSize: 14.0,
              //               color: Colors.black54,
              //               fontWeight: FontWeight.bold),
              //         ),
              //         SizedBox(height: 4.0),
              //         Column(
              //           children: this.news.map((i) {
              //             return Builder(builder: (BuildContext context) {
              //               return Container(
              //                 decoration: new BoxDecoration(
              //                   color: Colors.white,
              //                 ),
              //                 child: Padding(
              //                   padding: const EdgeInsets.all(8.0),
              //                   child: ListTile(
              //                     onTap: () {
              //                       print("tap");
              //                     },
              //                     leading: Image.network(ApiEndPoint.NEWS_IMAGE +
              //                         i.image,
              //                         height: 50 ,
              //                         width: 75 ,
              //                         ),
              //                     title: Text("${i.title}"),
              //                     subtitle: Text("${ timeFormatter.format( DateFormat('yyyy-MM-dd', 'en_US').parse( i.createdAt.split(' ')[0] ) ) }"),
              //                   ),
              //                 ),
              //               );
              //             });
              //           }).toList(),
              //         )
              //       ],
              //     ),
              //   ),
              // ])),
            ],
          ),
        ),
      );
  }

  @override
  void hideProgress() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void showMessage(String message, int status) {
    // TODO: implement showMessage
  }

  @override
  void showProgress() {
    setState(() {
      _isLoading = true;
    });
  }

  @override
  void onUserLoad(User user) {
    setState(() {
      this.user = user;
      imageProfile = user.photo;
    });
  }

  @override
  void onRubbishSummaryLoad(List<RubbishSummary> rubbishSummaries) {
    setState(() {
      this.rubbishSummaries = rubbishSummaries;
      if (this.rubbishSummaries.length > 1) {
        topRubbishSummaries = this.rubbishSummaries[0];
        this.rubbishSummaries.removeAt(0);
      }
    });
    // print(this.rubbishSummaries[0].image );
  }

  @override
  void onPromotionsLoad(List<Promotion> promotions) {
    print('promotions =${promotions.length}');
    setState(() {
      this.promotions = promotions;
    });
  }

  @override
  void onNewsLoad(List<News> news) {
    setState(() {
      this.news = news;
    });
  }
}
