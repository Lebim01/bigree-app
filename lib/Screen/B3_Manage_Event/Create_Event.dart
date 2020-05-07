import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../../utils/lang/lang.dart' as Lang;
import '../../utils/lang/utils.dart' as utils;

final lang = Lang.Lang();

class createEvent extends StatefulWidget {
  const createEvent({Key key}) : super(key: key);

  @override
  _createEventState createState() => _createEventState();
}

class _createEventState extends State<createEvent> {
  String title, fotoUrl;
  String _fecha = ''; 
  double valor = 0.0;
  File foto;
  final formKey = GlobalKey<FormState>();
  TextEditingController _inputfieldDateController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0.0,
        title: Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Text(
            lang.createdEvent,
            style: TextStyle(
              fontFamily: "Popins",
              letterSpacing: 1.5,
              fontWeight: FontWeight.w700,
              fontSize: 24.0,
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: ()=>{ _procesarImagen(ImageSource.gallery)},
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                 _mostrarFoto(),
                 SizedBox(height: 10.0),
                _createTitle(),
                SizedBox(height: 10.0),
                _createDescripton(),
                SizedBox(height: 10.0),
                _createLocation(),
                 SizedBox(height: 10.0),
                 _crearFecha(context),
                 SizedBox(height: 10.0),
                 _createPrice()
              ],
            ),
          ),
        ),
      )
    );
  }

  Widget _createTitle(){
    return  TextFormField(
      keyboardType: TextInputType.text,
      textCapitalization:
      TextCapitalization.words,
      style: TextStyle(
          fontFamily: "WorkSofiaSemiBold",
          fontSize: 18.0,
          color: Colors.black),
      decoration: InputDecoration(
        border: InputBorder.none,
        icon: Icon(
          FontAwesomeIcons.tablet,
          size: 29.0,
          color: Colors.black45,
        ),
        hintText: "Title event",
        hintStyle: TextStyle(
            fontFamily: "Sofia",
            fontSize: 15.0),
      ),
    );
  }
  Widget _createDescripton(){
    return  TextFormField(
      keyboardType: TextInputType.text,
      textCapitalization:
      TextCapitalization.words,
      style: TextStyle(
          fontFamily: "WorkSofiaSemiBold",
          fontSize: 18.0,
          color: Colors.black),
      decoration: InputDecoration(
        border: InputBorder.none,
        icon: Icon(
          FontAwesomeIcons.listAlt,
          size: 29.0,
          color: Colors.black45,
        ),
        hintText: "Description event",
        hintStyle: TextStyle(
            fontFamily: "Sofia",
            fontSize: 15.0),
      ),
    );
  }
  Widget _createLocation(){
    return  TextFormField(
      keyboardType: TextInputType.text,
      textCapitalization:
      TextCapitalization.words,
      style: TextStyle(
          fontFamily: "WorkSofiaSemiBold",
          fontSize: 18.0,
          color: Colors.black),
      decoration: InputDecoration(
        border: InputBorder.none,
        icon: Icon(
          FontAwesomeIcons.mapMarkedAlt,
          size: 29.0,
          color: Colors.black45,
        ),
        hintText: "Location event",
        hintStyle: TextStyle(
            fontFamily: "Sofia",
            fontSize: 15.0),
      ),
    );
  }

  Widget _crearFecha(BuildContext context) {
    return TextFormField(
      enableInteractiveSelection: false,
      controller: _inputfieldDateController,
      style: TextStyle(
          fontFamily: "WorkSofiaSemiBold",
          fontSize: 18.0,
          color: Colors.black),
      decoration: InputDecoration(
        border: InputBorder.none,
        icon: Icon(
          FontAwesomeIcons.calendar,
          size: 29.0,
          color: Colors.black45,
        ),
        hintText: "Date event",
        hintStyle: TextStyle(
            fontFamily: "Sofia",
            fontSize: 15.0),
      ),
      onTap: (){
        FocusScope.of(context).requestFocus(new FocusNode());
        _selectDate(context);
      },
    );
  }

  _selectDate(BuildContext context) async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(2018),
      lastDate: new DateTime(2025),
      //locale: Locale('es')
    ); 
    if(picked != null){
      setState(() {
        _fecha = picked.toString();
        _inputfieldDateController.text = _fecha;
      });
    }
  }



  _mostrarFoto() {
    if (fotoUrl != null) {
 
      return FadeInImage(
        image: NetworkImage(fotoUrl),
        placeholder: AssetImage('assets/loading.gif'),
        height: 300.0,
        fit: BoxFit.contain,
      );
 
    } else {
 
      if( foto != null ){
        return Image.file(
          foto,
          fit: BoxFit.cover,
          height: 300.0,
        );
      }
      return Image.asset('assets/image/original.png');
    }
  }
  _procesarImagen(ImageSource origen) async {
    foto = await ImagePicker.pickImage(
      source: origen
      );
      if(foto != null){
        //limpieza
        fotoUrl = null;
      }

      setState(() {
        
      });
  }

  Widget _createPrice() {
     return TextFormField(
       initialValue: valor.toString(),
       keyboardType: TextInputType.numberWithOptions(decimal: true),
       style: TextStyle(
          fontFamily: "WorkSofiaSemiBold",
          fontSize: 18.0,
          color: Colors.black),
      decoration: InputDecoration(
        border: InputBorder.none,
        icon: Icon(
          FontAwesomeIcons.dollarSign,
          size: 29.0,
          color: Colors.black45,
        ),
        hintText: "Location event",
        hintStyle: TextStyle(
            fontFamily: "Sofia",
            fontSize: 15.0),
      ),
      onSaved: (value) => valor = double.parse(value),
      validator: (value){
        if(utils.isNumeric(value)){
          return null;
        }else{  return 'Solo numeros'; }
      },
    );
  }


       
}