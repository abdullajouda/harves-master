import 'package:flutter/material.dart';
import 'package:harvest/customer/views/Drop-Menu-Views/Profile/user_address_list_tile.dart';
import 'package:harvest/helpers/Localization/localization.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/widgets/add_new_address_dialog.dart';


class UserAddresses extends StatefulWidget {
  @override
  _UserAddressesState createState() => _UserAddressesState();
}

class _UserAddressesState extends State<UserAddresses> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 35),
      child: Column(
        children: [
          ListView.separated(
            shrinkWrap: true,
            itemCount: 2,
            separatorBuilder: (context, index) => SizedBox(height: 30),
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final bool _isSelected = _isAddressSelected(index);
              return UserAddressListTile(
                isSelected: _isSelected,
                onTap: () {
                  setState(() => _selectedIndex = index);
                },
              );
            },
          ),
          SizedBox(height: 20),
          FlatButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AddNewAddressDialog(),
              );
            },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            color: CColors.fadeBlue,
            icon: Icon(Icons.add, color: CColors.darkGreen, size: 18),
            label: Text(
              "add_new_adress".trs(context),
              style: TextStyle(
                color: CColors.darkGreen,
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isAddressSelected(int index) => _selectedIndex == index;
}
