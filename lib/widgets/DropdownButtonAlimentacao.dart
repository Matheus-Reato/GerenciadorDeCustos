import 'package:flutter/material.dart';

class DropdownButtonAlimentacao extends StatefulWidget {
  final List<String> items;
  final void Function(String?)? onChanged;
  final String? value; // Adicione este campo

  const DropdownButtonAlimentacao({Key? key, required this.items, this.onChanged, this.value}) : super(key: key);

  @override
  _DropdownButtonAlimentacaoState createState() => _DropdownButtonAlimentacaoState();
}

class _DropdownButtonAlimentacaoState extends State<DropdownButtonAlimentacao> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey, width: 1),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: widget.value, // Use o valor inicial aqui
            onChanged: (String? newValue) {
              if (widget.onChanged != null) {
                widget.onChanged!(newValue);
              }
            },
            items: widget.items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            hint: Text('Mês'),
          ),
        ),
      ),
    );
  }
}
