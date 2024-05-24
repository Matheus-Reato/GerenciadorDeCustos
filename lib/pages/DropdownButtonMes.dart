import 'package:flutter/material.dart';

class DropdownButtonMes extends StatefulWidget {
  final List<String> items;
  final void Function(String?)? onChanged; // Função de retorno de chamada para notificar sobre a mudança

  const DropdownButtonMes({Key? key, required this.items, this.onChanged}) : super(key: key);

  @override
  _DropdownButtonMesState createState() => _DropdownButtonMesState();
}

class _DropdownButtonMesState extends State<DropdownButtonMes> {
  String? _selectedItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      child: DropdownButton<String>(
        value: _selectedItem,
        onChanged: (String? newValue) {
          setState(() {
            _selectedItem = newValue;
          });
          // Notifica a função onChanged (se existir) sobre a mudança no valor selecionado
          if (widget.onChanged != null) {
            widget.onChanged!(_selectedItem);
          }
        },
        items: widget.items.map<DropdownMenuItem<String>>((String value) {
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
