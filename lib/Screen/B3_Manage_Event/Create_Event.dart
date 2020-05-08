import 'dart:io';

import 'package:event_country/models/evnets_models.dart';
import 'package:event_country/services/event_service.dart';
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
  bool _guardando = false;
  final formKey = GlobalKey<FormState>();
  TextEditingController _inputfieldDateController = new TextEditingController();

  ///Model Events
  EventModel eventModel = new EventModel(); 
  final productoService = EventsServices();

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
                 _createPrice(),
                  SizedBox(height: 10.0),
                 _crearBotton()
              ],
            ),
          ),
        ),
      )
    );
  }

  Widget _createTitle(){
    return  TextFormField(
      initialValue: eventModel.title,
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
      /////get data
      onSaved: (value) => eventModel.title = value,
      validator: (value){
        if(value.length < 3){
          return 'Ingrese el titulo ';
        }else return null;
      },
    );
  }
  Widget _createDescripton(){
    return  TextFormField(
      initialValue: eventModel.description,
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
      onSaved: (value)=> eventModel.description = value,
      validator: (value){
        if(value.length < 10){
          return 'Ingrese una descripcion';
        }else return null;
      }
    );
  }
  Widget _createLocation(){
    return  TextFormField(
      initialValue: eventModel.location,
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
      onSaved: (value) => eventModel.location = value,
      validator: (value){
        if(value.length < 10){
          return 'Ingrese una direccion';
        }else return null;
      },
    );
  }

  Widget _crearFecha(BuildContext context) {
    return TextFormField(
      //initialValue: eventModel.date.toString(),
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
      onSaved: (value)=> eventModel.date = value.toString(),
      validator: (value){
        if(value.length < 10){
          return 'Ingresar fecha';
        }else return null;
      },
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
        _fecha = _fecha.substring(0, 10);
        _inputfieldDateController.text = _fecha;
         print(_fecha);

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
       initialValue: eventModel.price.toString(),
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
      onSaved: (value) => eventModel.price = double.parse(value),
      validator: (value){
        if(utils.isNumeric(value)){
          return null;
        }else{  return 'Solo numeros'; }
      },
    );
  }


  Widget _crearBotton() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)
      ),
      color: Colors.deepPurple,
      textColor: Colors.white,
      label: Text('guardar'),
      icon: Icon(Icons.save),
      onPressed: (_guardando) ? null : _submit,
    );
  }

  void _submit()async { 

    if(!formKey.currentState.validate()) return;
    formKey.currentState.save();
    
    // setState(() {
    //   _guardando = true;
    // });
    // print(eventModel.title);
    // print(eventModel.description);
    // print(eventModel.location);
    // print(eventModel.price);
     print( eventModel.date );
    if(eventModel.id == null){
       productoService.createEevnet(eventModel).then((resp){
         if(resp){
           _mostrarAlert(context, 'Success!', 'Evento creado', 'comprobado');
         }
         else{
          _mostrarAlert(context, 'Error!', 'Ha ocurrido un error', 'interfaz');
         }
       });
    }else{
      //productoProvider.actualizarProducto(producto);
    }

  }
  void _mostrarAlert(BuildContext context,String titulo, String text, String img){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context){
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Text('$titulo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('$text'),
               SizedBox(height: 10.0),
              image(img)
            ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: (){
                  Navigator.of(context).pop();
                  Navigator.pop(context);
                },
                )
            ],
        );
      }
    );
  }

  Widget image(String img){
    return Image(
      image: AssetImage('assets/image/$img.png'),
      width: 100,
      );
  }
       
}