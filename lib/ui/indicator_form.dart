import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:peso_y_masa_muscular/bloc/indicators_bloc.dart';
import 'package:peso_y_masa_muscular/model/indicator.dart';
import 'package:peso_y_masa_muscular/ui/custom_icons.dart';

class IndicatorForm extends StatefulWidget {
  final BuildContext context;
  final double height;

  IndicatorForm({this.context, this.height});

  @override
  State<StatefulWidget> createState() => _IndicatorFormState(context: context, height: height);
}

class _IndicatorFormState extends State<IndicatorForm> {
  BuildContext context;
  double height;
  final _formKey = GlobalKey<FormState>();
  FocusNode _focusNodeHeight;
  FocusNode _focusNodeWeight;
  FocusNode _focusNodeMuscle;
  FocusNode _focusNodeFat;
  Expanded _textFormHeight;
  Expanded _textFormWeight;
  Expanded _textFormMuscle;
  Expanded _textFormFat;
  TextEditingController _heightController;
  TextEditingController _weightController;
  TextEditingController _muscleController;
  TextEditingController _fatController;
  Visibility _heightFieldVisibility;

  _IndicatorFormState({this.context, this.height});

  @override
  void initState() {
    super.initState();
    _focusNodeHeight = FocusNode();
    _focusNodeWeight = FocusNode();
    _focusNodeMuscle = FocusNode();
    _focusNodeFat = FocusNode();
    _heightController = TextEditingController();
    _weightController = TextEditingController();
    _muscleController = TextEditingController();
    _fatController = TextEditingController();
    _textFormHeight = _getTextField('Estatura (m)', _focusNodeHeight, _focusNodeWeight, _heightController, _weightController);
    _textFormWeight = _getTextField('Peso (kg)', _focusNodeWeight, _focusNodeMuscle, _weightController, _muscleController);
    _textFormMuscle = _getTextField('% de músculo', _focusNodeMuscle, _focusNodeFat, _muscleController, _fatController);
    _textFormFat = _getTextField('% de grasa', _focusNodeFat, _focusNodeHeight, _fatController, _heightController);
    _setupHeightTextField();
  }

  @override
  void dispose() {
    _focusNodeHeight.dispose();
    _focusNodeWeight.dispose();
    _focusNodeMuscle.dispose();
    _focusNodeFat.dispose();
    super.dispose();
  }

  _setupHeightTextField() {
    if(height>0) {
      _heightFieldVisibility = Visibility(child: _textFormHeight, visible: false,);
    } else {
      _heightFieldVisibility = Visibility(child: _textFormHeight, visible: true,);
    }
  }

  void showHeightTextField() {
    if(!_heightFieldVisibility.visible) {
      _heightFieldVisibility = Visibility(child: _textFormHeight, visible: true,);
    } else {
      _heightFieldVisibility = Visibility(child: _textFormHeight, visible: false,);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nueva medición'),
        actions: <Widget>[
        IconButton(
          icon: Icon(CustomIcons.edit_height),
          onPressed: () {
            showHeightTextField();
          },
        ),
      ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  _heightFieldVisibility,
                  _textFormWeight,
                ],
              ),
              Row(
                children: <Widget>[
                  _textFormMuscle,
                  _textFormFat
                ],
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: RaisedButton(
                    child: Text('Guardar medición'),
                    onPressed: () {
                      _submitForm();
                    },
                  ),
                ),
              )
            ],

          ),
        ),
      ),
    );
  }

  Widget _getTextField(String label, FocusNode currentFocusNode, FocusNode nextFocusNode, TextEditingController currentController, TextEditingController nextController) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: TextFormField(
          decoration: InputDecoration(
              labelText: label
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value.isEmpty) {
              return 'Campo necesario';
            }
            return null;
          },
          focusNode: currentFocusNode,
          controller: currentController,
          onFieldSubmitted: (term) {
            if(nextController.text.isEmpty){
              _fieldFocusChange(context, currentFocusNode, nextFocusNode);
            }
          },
        ),
      ),
    );
  }

  _fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  _submitForm() async {
    if (_formKey.currentState.validate()) {
      if(_heightFieldVisibility.visible) {
        height = double.parse(this._heightController.text);
      }
      Indicator indicator = Indicator(
        weight: double.parse(this._weightController.text),
        imc: double.parse(this._weightController.text)/(height*height),
        muscle: double.parse(this._muscleController.text),
        fat: double.parse(this._fatController.text),
        dateTime: DateTime.now().toIso8601String()
      );
      bloc.saveIndicator(indicator);
      Navigator.pop(context, height);
    }
  }
}