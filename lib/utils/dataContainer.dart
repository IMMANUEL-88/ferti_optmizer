import 'package:flutter/material.dart';

class dataContainer extends StatelessWidget {
  final String name;
  // final page;
  // final icon;
  // final iconcolor;
  final ValueChanged<String>? onChanged;
  final TextInputType keyboardType;

  const dataContainer({
    super.key,
    required this.name,
    // required this.page,
    // required this.icon,
    // required this.iconcolor,
    this.onChanged,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        // child: GestureDetector(
        //   onTap: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => page,
        //       ),
        //     );
        //   },
        //   child: Container(
        //     height: MediaQuery.of(context).size.height * 0.15,
        //     decoration: BoxDecoration(
        //       color: Colors.white,
        //       borderRadius: BorderRadius.circular(10),
        //     ),
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         const SizedBox(
        //           height: 5,
        //         ),
        //         LayoutBuilder(
        //           builder: (context, constraints) {
        //             final screenWidth = constraints.maxWidth;
        //             final iconSize = screenWidth * 0.3;
        //
        //             return Icon(
        //               icon,
        //               size: iconSize,
        //               color: iconcolor,
        //             );
        //           },
        //         ),
        //         const SizedBox(height: 10),
        //         LayoutBuilder(
        //           builder: (context, constraints) {
        //             final screenWidth = constraints.maxWidth;
        //             final fontSize = screenWidth * 0.09;
        //             return Center(
        //               child: Text(name,
        //                   style: TextStyle(
        //                       fontFamily: GoogleFonts.lato().fontFamily,
        //                       fontWeight: FontWeight.bold,
        //                       fontSize: 15)),
        //             );
        //           },
        //         ),
        //         const SizedBox(
        //           height: 15,
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
