import 'package:flutter/material.dart';
import 'package:zoro_legal/data/datarepositories/user_app_future/account_balance_future.dart';
import 'package:zoro_legal/data/helpers/colors.dart';

class AccountBalanceDetails extends StatefulWidget {
  AccountBalanceDetails({
    @required this.walletData,
    @required this.currency
  });
  final walletData;
  final currency;
  static const routeName = '/accountBalanceDetails';
  @override
  _AccountBalanceDetailsState createState() => _AccountBalanceDetailsState();
}

class _AccountBalanceDetailsState extends State<AccountBalanceDetails> {
  Future future;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    future = accountDetails(widget.walletData.walletId);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future _refresh() async {
    setState(() {
      future = accountDetails(widget.walletData.walletId);
    });
  }

  Color _colorfromhex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    var date = widget.walletData.date.toString().split(" ");

    return Scaffold(
        appBar: AppBar(
           backgroundColor:MyColor.appcolor,
          leading: IconButton(
            icon: Icon(
              Icons.keyboard_arrow_left,
              size: 40,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Container(
            margin: EdgeInsets.only(left: size * 0.28743961352657 - 60),
            child: Text("Account Details"),
          ),
        ),
        body: RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: _refresh,
            child: Container(
              margin: EdgeInsets.only(
                  left: size * 0.0615942028985507,
                  right: size * 0.0615942028985507,
                  top: 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.walletData.paymentMethod != null
                          ? '${widget.walletData.paymentMethod} Payment'
                          : "online Payment",
                      style: TextStyle(
                          color: _colorfromhex("#474747").withOpacity(0.9),
                          fontWeight: FontWeight.bold,
                          fontSize: size * 0.045),
                    ),
                    Card(
                      margin: EdgeInsets.only(top: 20),
                      elevation: 5,
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 15, top: 10, right: 15, bottom: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.walletData.purpose}',
                              style: TextStyle(
                                  color:
                                      _colorfromhex("#474747").withOpacity(0.9),
                                  fontWeight: FontWeight.bold,
                                  fontSize: size * 0.045),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              margin: EdgeInsets.only(top: 15),
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '${widget.currency} ',
                                      style: TextStyle(fontSize: size * 0.035),
                                    ),
                                    TextSpan(
                                      text: '${widget.walletData.ammount}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: size * 0.047),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.only(top: 20),
                      elevation: 5,
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 10, top: 10, right: 10, bottom: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: size / 2 - 40,
                                    child: Text(
                                      'Paid to',
                                      style: TextStyle(
                                          color: _colorfromhex("#474747")
                                              .withOpacity(0.9),
                                          fontWeight: FontWeight.bold,
                                          fontSize: size * 0.036231884057971),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerRight,
                                    width: size / 2 - 40,
                                    child: Text(
                                      'Zorolegal.com',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          color: _colorfromhex("#474747")
                                              .withOpacity(0.9),
                                          fontWeight: FontWeight.bold,
                                          fontSize: size * 0.036231884057971),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: size / 2 - 40,
                                    child: Text(
                                      'Paid by',
                                      style: TextStyle(
                                          color: _colorfromhex("#474747")
                                              .withOpacity(0.9),
                                          fontWeight: FontWeight.bold,
                                          fontSize: size * 0.036231884057971),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerRight,
                                    width: size / 2 - 40,
                                    child: Text(
                                      '${widget.walletData.transactionType}',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          color: _colorfromhex("#474747")
                                              .withOpacity(0.9),
                                          fontWeight: FontWeight.bold,
                                          fontSize: size * 0.036231884057971),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: size / 2 - 40,
                                    child: Text(
                                      'Date and time',
                                      style: TextStyle(
                                          color: _colorfromhex("#474747")
                                              .withOpacity(0.9),
                                          fontWeight: FontWeight.bold,
                                          fontSize: size * 0.036231884057971),
                                    ),
                                  ),
                                  Expanded(
                                                                      child: Container(
                                      alignment: Alignment.centerRight,
                                      width: size / 2 - 40,
                                      child: Text(
                                        '${date[0]} ${widget.walletData.time}',
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            color: _colorfromhex("#474747")
                                                .withOpacity(0.9),
                                            fontWeight: FontWeight.bold,
                                            fontSize: size * 0.036231884057971),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: size / 2 - 40,
                                  child: Text(
                                    'Transaction ID',
                                    style: TextStyle(
                                        color: _colorfromhex("#474747")
                                            .withOpacity(0.9),
                                        fontWeight: FontWeight.bold,
                                        fontSize: size * 0.036231884057971),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  width: size / 2 - 40,
                                  child: Text(
                                    '${widget.walletData.transactionId}',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        color: _colorfromhex("#474747")
                                            .withOpacity(0.9),
                                        fontWeight: FontWeight.bold,
                                        fontSize: size * 0.036231884057971),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }

  Center retryWiget() {
    return Center(
        child: Column(
      children: <Widget>[
        Text('Something Went Wrong Try Again'),
        RaisedButton(
          child: Row(
            children: <Widget>[
              Icon(Icons.refresh),
              Text('Retry'),
            ],
          ),
          onPressed: () {
            setState(() {
              future = accountDetails(widget.walletData.walletId);
            });
          },
        )
      ],
    ));
  }
}
