import 'package:flutter/material.dart';
import 'package:zoro_legal/data/helpers/colors.dart';
 clipPath(context,String title,String subtitle) {
    return ClipPath(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 245,
        child: Padding(
          padding: const EdgeInsets.only(top: 100, left: 30),
          child: Text(title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold)),
              // Text(subtitle,
              //     style: TextStyle(
              //         color: Colors.white,
              //         fontSize: 20,
              //         fontWeight: FontWeight.bold)
              // )
           
        ),
        decoration: new BoxDecoration(
          color: MyColor.appcolor,
        ),
      ),
      clipper: Custompath(),
    );
 }
    class Custompath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(30, size.height, size.width / 4, size.height);
    path.lineTo(size.width, size.height - 180);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return false;
  }
}

clipimage(){
return Container(
              height: 42,
              margin: EdgeInsets.only(left: 230, top: 190),
              child: Image.asset(
                'assets/img.png',
                fit: BoxFit.fill,
              ));
}

// class BorderPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 1.0
//       ..color = Colors.blueAccent;
//     var path = Path();

//     path.lineTo(0, size.height);
//     path.quadraticBezierTo(
//         size.width / 6, size.height - 40, size.width / 2, size.height - 20);
//     path.quadraticBezierTo(
//         3 / 4 * size.width, size.height, size.width, size.height - 30);
//     path.lineTo(size.width, 0);
//     path.close();
//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => true;
// }

// class Custompath extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     Path path = Path();

//     path.lineTo(0, size.height - 30);
//     path.quadraticBezierTo(30, size.height, size.width / 4, size.height);
//     path.lineTo(size.width, size.height - 180);
//     path.lineTo(size.width, 0);
//     path.close();

//     // path.lineTo(0.0, 0.0);
//     // path.lineTo(0, size.height);
//     // path.quadraticBezierTo(
//     //     size.width / 6, size.height - 40, size.width / 2, size.height - 20);
//     // path.quadraticBezierTo(
//     //     3 / 4 * size.width, size.height, size.width, size.height - 30);
//     // path.lineTo(size.width, 0);
//     // path.close();
//     return path;
//   }

//   @override
//   bool shouldReclip(covariant CustomClipper oldClipper) {
//     return false;
//   }
// }
