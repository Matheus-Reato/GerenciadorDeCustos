import 'package:flutter/material.dart';

class DropdownButtonModalidade extends StatefulWidget {
  final List<String> items;

  const DropdownButtonModalidade({Key? key, required this.items}) : super(key: key);

  @override
  _DropdownButtonModalidadeState createState() => _DropdownButtonModalidadeState();
}

class _DropdownButtonModalidadeState extends State<DropdownButtonModalidade> {
  String? _selectedItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      //padding: EdgeInsets.only(left: 10),
      child: DropdownButton<String>(
        value: _selectedItem,
        onChanged: (String? newValue) {
          setState(() {
            _selectedItem = newValue;
          });
        },
        items: widget.items.isEmpty
            ? null
            : widget.items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),

          );
        }).toList(),
        hint: Text('Selecione'),
      ),
    );
  }
}
