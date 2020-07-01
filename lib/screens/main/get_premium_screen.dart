import 'dart:async';

import 'package:Komeet/component/background_gradient.dart';
import 'package:Komeet/screens/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

Firestore _fs = Firestore.instance;
InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;
const List<String> _kProductIds = <String>[
  '1',
  '12',
  'premium',
  'premiumseason1'
];

class GetPremiumScreen extends StatefulWidget {
  static String id = "get_premium_screen";
  @override
  _GetPremiumScreenState createState() => _GetPremiumScreenState();
}

class _GetPremiumScreenState extends State<GetPremiumScreen> {
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  List<String> _consumables = [];
  StreamSubscription<List<PurchaseDetails>> _subscription;
  List<String> _notFoundIds = [];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;

  void _initialize() async {
    _isAvailable = await _iap.isAvailable();
    if (_isAvailable) {
      await _getProducts();
      await _getPastPurchases();
      print("in app is available ? = ${await _iap.isAvailable()}");
      print(_products);
      print(_purchases);
      // Verify and deliver a purchase with your own business logic
      _subscription = _iap.purchaseUpdatedStream.listen((data) => setState(() {
            print('NEW PURCHASE');
            _purchases.addAll(data);
            _verifyPurchase();
          }));
    }
  }

  void _buyProduct(ProductDetails prod) async {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: prod);
    print(purchaseParam.productDetails.id);
    await _iap.buyNonConsumable(purchaseParam: purchaseParam);
    _verifyPurchase();
  }

  Future<void> _getProducts() async {
    ProductDetailsResponse response =
        await _iap.queryProductDetails(_kProductIds.toSet());
    print(response.notFoundIDs);
    print(response.productDetails);

    setState(() {
      _products = response.productDetails;
    });
  }

  Future<void> _getPastPurchases() async {
    QueryPurchaseDetailsResponse response = await _iap.queryPastPurchases();

    for (PurchaseDetails purchase in response.pastPurchases) {
      if (Platform.isIOS) {
        InAppPurchaseConnection.instance.completePurchase(purchase);
      }
    }

    setState(() {
      _purchases = response.pastPurchases;
    });
  }

  PurchaseDetails _hasPurchased(String productID) {
    return _purchases.firstWhere((purchase) => purchase.productID == productID,
        orElse: () => null);
  }

  void _verifyPurchase() {
    PurchaseDetails purchase = _hasPurchased("premiumseason1");

    if (purchase != null && purchase.status == PurchaseStatus.purchased) {
      _fs.collection("Users").document(currentUserEmail).updateData({
        "premium": 1,
      });
      _fs
          .collection("Users")
          .document(currentUserEmail)
          .collection("Badges")
          .document("Season1")
          .updateData({
        "description": "Season 1 Premium",
        "imageLink":
            "https://firebasestorage.googleapis.com/v0/b/beyond-678bd.appspot.com/o/Reward%2Fseason_1.png?alt=media&token=e7feb7ae-b84a-46c2-8769-cb4940ab2c6f",
      });
    }
  }

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(gradient: mainColorGradientReverse),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            actionsIconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            automaticallyImplyLeading: true,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Container(
                  height: data.size.height / 1.5,
                  child: Image(
                    image: AssetImage("lib/images/getPremium.png"),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: kBackgroundColor,
                  onPressed: () async {
                    print(_products[1].title);
                    print(_products[1].description);
                    _buyProduct(_products[1]);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _isAvailable ? "Get Season 1 Premium" : "Not Available",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: kCTA,
                          fontSize: 24.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
