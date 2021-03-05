import 'package:flutter/material.dart';
import 'package:zoro_legal/data/helpers/colors.dart';
class ViewDocumentVault extends StatefulWidget {
 ViewDocumentVault({ this.image,this.name});
  final String image;
  final String name;
   static const routeName = '/viewDocuments';
  @override
  _ViewDocumentVaultState createState() => _ViewDocumentVaultState();
}

class _ViewDocumentVaultState extends State<ViewDocumentVault> {
   @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size.width;
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
          
            
            margin: EdgeInsets.only(left: size * 0.28743961352657 - 35),
            child: Text(widget.name))),
          body: Center(
                      child: Container(
                         decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black,
                                      ),
                                    ),
                        width: MediaQuery.of(context).size.width/1.3,
                        height: MediaQuery.of(context).size.width/1.3 ,
        child:Image.network(widget.image,fit: BoxFit.fill,)
      ),
          ),
    );
  }
}