import 'package:flutter/material.dart';

class MinimumChargeDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 38),
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.0),
              color: const Color(0xffffffff),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x1c000000),
                  offset: Offset(0, 4),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(alignment: Alignment.topRight,child: IconButton(onPressed: () => Navigator.pop(context),icon: Icon(Icons.clear))),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Image.asset('assets/minimum-charge.png'),
                ),
                Text(
                  'Minimum Charge Price',
                  style: TextStyle(
                    fontSize: 18,
                    color: const Color(0xff3c4959),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Text(
                    'You Have to Buy At least 100\$  \n,You Can Back to Home to select Extra Items',
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color(0xff888a8d),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Container(
                    height: 28,
                    width: 117,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: const Color(0xffe4f0e6),
                    ),
                    child: Center(
                      child: Text(
                        'Home',
                        style: TextStyle(
                          fontSize: 12,
                          color: const Color(0xff3c984f),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
