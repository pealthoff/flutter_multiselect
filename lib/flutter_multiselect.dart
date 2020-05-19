library flutter_multiselect;

import 'package:flutter/material.dart';
import 'package:flutter_multiselect/selection_modal.dart';

class MultiSelect extends FormField<dynamic> {
  final String titleText;
  final String hintText;
  final bool required;
  final String errorText;
  final dynamic value;
  final bool filterable;
  final List dataSource;
  final String textField;
  final String valueField;
  final String unidadeField;
  final Function change;
  final Function open;
  final Function close;
  final Widget leading;
  final Widget trailing;
  final int maxLength;
  MultiSelect(
      {FormFieldSetter<dynamic> onSaved,
      FormFieldValidator<dynamic> validator,
      dynamic initialValue,
      bool autovalidate = false,
      this.titleText = 'Title',
      this.hintText = 'Clique para selecionar os produtos...',
      this.required = false,
      this.errorText = 'Por favor, selecione um ou mais produtos',
      this.value,
      this.leading,
      this.filterable = true,
      this.dataSource,
      this.textField,
      this.valueField,
      this.unidadeField,
      this.change,
      this.open,
      this.close,
      this.trailing,
      this.maxLength})
      : super(
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            autovalidate: autovalidate,
            builder: (FormFieldState<dynamic> state) {
              List<Widget> _buildSelectedOptions(dynamic values, state) {
                List<Widget> selectedOptions = [];

                if (values != null) {
                  values.forEach((item) {
                    var existingItem = dataSource.singleWhere(
                        (itm) => itm[valueField] == item,
                        orElse: () => null);
                    if (existingItem != null) {
                      selectedOptions.add(Chip(
                        label: Text(existingItem[textField],
                            overflow: TextOverflow.ellipsis),
                      ));
                    }
                  });
                }

                return selectedOptions;
              }

              return InkWell(
                  onTap: () async {
                    print("sei tudo de voce e voce nada sabe sobre mim");
                    print(state.value);
                    var produtosSelecionados = state.value ?? {
                      "values": [],
                      "quantidades": new Map<int, TextEditingController>(),
                    };
                    var results = await Navigator.push(
                        state.context,
                        MaterialPageRoute<dynamic>(
                          builder: (BuildContext context) => SelectionModal(
			                        title: titleText,
                              filterable: filterable,
                              valueField: valueField,
                              textField: textField,
                              unidadeField: unidadeField,
                              dataSource: dataSource,
                              values: produtosSelecionados["values"],
                              quantidades: produtosSelecionados["quantidades"],
                              maxLength: maxLength ?? dataSource?.length),
                          fullscreenDialog: true,
                        ));

                    if (results != null) {
                      dynamic newValue;
                      if (results.length > 0) {
                        newValue = results;
                      }
                      state.didChange(newValue);
                      if (change != null) {
                        change(newValue);
                      }
                    }
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      filled: true,
                      //TODO: usar o tema
                      fillColor: Colors.black12,
                      contentPadding:
                          EdgeInsets.only(left: 10.0, top: 0.0, right: 10.0),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: Colors.red.shade400)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: Colors.grey.shade400)),
                      errorText: state.hasError ? state.errorText : null,
                      errorMaxLines: 50,
                    ),
                    isEmpty: (state.value == null || state.value == '' || (state.value != null &&  state.value.length == 0)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                      text: titleText,
                                      style: TextStyle(
                                          fontSize: 16.0, color: Theme.of(state.context).textTheme.bodyText1.color),
                                      children: 
                                          [
                                              TextSpan(
                                                text: required ? ' *' : '',
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 16.0),
                                              ),
                                              TextSpan(
                                                text: maxLength != null ? '(max $maxLength)' : '',
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 13.0),
                                              )
                                            ]
                                          ),
                                ),
                              ),
                              // Column(
                              //   crossAxisAlignment: CrossAxisAlignment.center,
                              //   mainAxisAlignment: MainAxisAlignment.center,
                              //   mainAxisSize: MainAxisSize.max,
                              //   children: <Widget>[
                              //     Icon(
                              //       Icons.arrow_downward,
                              //       color: Theme.of(state.context).primaryColor,
                              //       size: 30.0,
                              //     )
                              //   ],
                              // )
                            ],
                          ),
                        ),
                        (state.value == null || state.value == '' || (state.value != null &&  state.value.length == 0))
                            ? new Container(
                                margin:
                                    EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 6.0),
                                child: Text(
                                  hintText,
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ):
                              Wrap(
                                spacing: 8.0, // gap between adjacent chips
                                runSpacing: 1.0, // gap between lines
                                children:
                                    _buildSelectedOptions(state.value["values"], state),
                              )
                            
                      ],
                    ),
                  ));
            });
}
