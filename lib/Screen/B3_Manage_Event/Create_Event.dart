import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:event_country/models/categories.models.dart';
import 'package:event_country/models/evnets_models.dart';
import 'package:event_country/services/categories_services.dart';
import 'package:event_country/services/event_service.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/lang/lang.dart' as Lang;
import '../../utils/lang/utils.dart' as utils;
import 'package:http/http.dart' as http;


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
  String token = '';
  final formKey = GlobalKey<FormState>();
  TextEditingController _inputfieldDateController = new TextEditingController();
  TextEditingController _inputfieldStartTime = new TextEditingController();
  TextEditingController _inputfieldEndTime = new TextEditingController();
  bool privacity = false;
  String privacityDB = '';
    String _opcionseleccionada = 'volar';

    TimeOfDay _timeOfDay = TimeOfDay.now();
    

    List<dynamic> lista;
    final String _url = 'http://datatecblocks.xyz:4004/graphql';

    final _getcategories = '{categories{id,name}}';
    String _valProvince ;
    List<dynamic> _dataProvince = List();
    void getProvince() async {
    final url = '$_url?query=$_getcategories';
    final resp = await http.get(url);
    var listData = jsonDecode(resp.body); 
    setState(() {
      _dataProvince = listData['data']['categories']; 
    });
    print("data : $_dataProvince");
  }

  ///Model Events
  ///
  ///
  ///
  EventModel eventModel = new EventModel(); 
  final productoService = EventsServices();
  final categoriesServices =  CategoriesServices();

  @override
  void initState() { 
    super.initState();
    cargarPref(); 
    getProvince();  
  }
  cargarPref()async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString('token');
    print( token );
    setState(() {});
  }

  Widget build(BuildContext context) {
    final EventModel eventData = ModalRoute.of(context).settings.arguments;
    if(eventData !=null){
      eventModel = eventData;
      //_timeOfDay = TimeOfDay(hour: null, minute: null);
      print( eventModel.timeStart );
        setState(() {
          _inputfieldDateController.text = eventModel.date;
          _inputfieldStartTime.text = eventModel.timeStart;
          _inputfieldEndTime.text = eventModel.timeEnd;
           if(eventModel.publicType == "public") privacity = false; else privacity = true;
          
        });
    }

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
                _createTimeStart(context),
                SizedBox(height: 10.0),
                _createTimeEnd(context),
                SizedBox(height: 10.0),
                _createCapacidad(),
                SizedBox(height: 10.0),
                _crearDropDown(),
                SizedBox(height: 10.0),
                _crearDisponible(),
                 SizedBox(height: 10.0),
                _createPrice(),
                 SizedBox(height: 10.0),
                _crearBotton(),
               
                 
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
        hintText: 
        lang.title,
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
        hintText: lang.description,
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
        hintText: lang.location,
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
        hintText: lang.date,
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
      });
    }
  }
  Widget _createTimeStart(BuildContext context) {
    return TextFormField(
      //initialValue: eventModel.date.toString(),
      enableInteractiveSelection: false,
      controller: _inputfieldStartTime,
      style: TextStyle(
          fontFamily: "WorkSofiaSemiBold",
          fontSize: 18.0,
          color: Colors.black),
      decoration: InputDecoration(
        border: InputBorder.none,
        icon: Icon(
          FontAwesomeIcons.clock,
          size: 29.0,
          color: Colors.black45,
        ),
        hintText: ('hora inicio'),
        hintStyle: TextStyle(
            fontFamily: "Sofia",
            fontSize: 15.0),
      ),
      onSaved: (value)=> eventModel.timeStart = '${value.toString()}:00',
      validator: (value){
        if(value.length < 5){
          return 'Ingresar hora inicio';
        }else return null;
      },
      onTap: (){
        FocusScope.of(context).requestFocus(new FocusNode());
        _selectTime(context, 1);
      },
    );
  }
  Widget _createTimeEnd(BuildContext context) {
    return TextFormField(
      //initialValue: eventModel.date.toString(),
      enableInteractiveSelection: false,
      controller: _inputfieldEndTime,
      style: TextStyle(
          fontFamily: "WorkSofiaSemiBold",
          fontSize: 18.0,
          color: Colors.black),
      decoration: InputDecoration(
        border: InputBorder.none,
        icon: Icon(
          FontAwesomeIcons.clock,
          size: 29.0,
          color: Colors.black45,
        ),
        hintText: ('hora final'),
        hintStyle: TextStyle(
            fontFamily: "Sofia",
            fontSize: 15.0),
      ),
      onSaved: (value)=> eventModel.timeEnd = '${value.toString()}:00',
      validator: (value){
        if(value.length < 5){
          return 'Ingresar hora final';
        }else return null;
      },
      onTap: (){
        FocusScope.of(context).requestFocus(new FocusNode());
        _selectTime(context, 0);
      },
    );
  }
  _selectTime(BuildContext context, int time) async{
    TimeOfDay picket = await showTimePicker(
      context: context, 
      initialTime: _timeOfDay
      );
      if(picket != null){
        if(time == 1){
            setState(() {
            var pick = picket.toString();
              pick = pick.substring(10,15);
              print(pick);
            _inputfieldStartTime.text = pick.toString();
          });
        }
        if(time == 0){
            setState(() {
            var pick = picket.toString();
              pick = pick.substring(10,15);
              print(pick);
            _inputfieldEndTime.text = pick.toString();
          });
        }
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
        hintText: lang.price,
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
    //
    // print( '${eventModel.timeStart} ${eventModel.timeEnd} ${eventModel.publicType}' );
    eventModel.categoryId = int.parse(_valProvince);
    
    if(eventModel.id == null){
      //print(_valProvince != null);
       if(_valProvince != null){
         if(eventModel.publicType == null) eventModel.publicType = "public";
         //print(eventModel.publicType);
          productoService.createEevnet(eventModel, token).then((resp){
            if(resp){
              _mostrarAlert(context, 'Success!', 'Evento creado', 'comprobado', 'si');
            }
              else { _mostrarAlert(context, 'Error!', 'Ha ocurrido un error', 'interfaz', 'no');
            }
         
        });
        //print('categoria es ${eventModel.categoryId}'  ); 
       }else{
          _mostrarAlert(context, 'Error!', 'Seleccione una categoria', 'interfaz', 'no');
       }
    }else{
      //productoProvider.actualizarProducto(producto);
      
    }

  }
  void _mostrarAlert(BuildContext context,String titulo, String text, String img, String back){
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
                  if(back == 'no'){
                    Navigator.of(context).pop();
                  }else{
                    Navigator.of(context).pop();
                    Navigator.pop(context);
                  }
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

  _createCapacidad() {
    return TextFormField(
        initialValue: eventModel.capacity.toString(),
       keyboardType: TextInputType.numberWithOptions(decimal: true),
       style: TextStyle(
          fontFamily: "WorkSofiaSemiBold",
          fontSize: 18.0,
          color: Colors.black),
      decoration: InputDecoration(
        border: InputBorder.none,
        icon: Icon(
          FontAwesomeIcons.personBooth,
          size: 29.0,
          color: Colors.black45,
        ),
        hintText: 'Capacity',
        hintStyle: TextStyle(
            fontFamily: "Sofia",
            fontSize: 15.0),
      ),
      onSaved: (value) => eventModel.capacity = int.parse(value),
      validator: (value){
        if(utils.isNumeric(value)){
          return null;
        }else{  return 'Solo numeros'; }
      },
    );
  }
 
   Widget _crearDropDown() {

     return Row(
       children: <Widget>[
         Icon(Icons.select_all, size: 39.0, color: Colors.black45),
         SizedBox(width: 10.0),
         Expanded(
           child: DropdownButton(
              hint: Text("Select category"),
              value: _valProvince,
              items: _dataProvince.map((item) {
                return DropdownMenuItem(
                  child: Text(item['name']),
                  value: item['id'].toString(),
                );
              }).toList(),
              onChanged: (value) {
               setState(() {
                //eventModel.categoryId = value;
                _valProvince = value.toString();
               });
              print(value);
              },
              
            ),
         )
       ],
      );
    
  }
  Widget _crearDisponible() {
    return Row(
       children: <Widget>[
         Icon(Icons.event_note, size: 39.0, color: Colors.black45),
         SizedBox(width: 0.0),
         Expanded(
           child:SwitchListTile(
              value: privacity,
              title: Text('Evento Privado', 
              style: TextStyle(
                fontFamily: "Sofia",
                fontSize: 15.0
              ),
              ),
              activeColor: Colors.deepPurple,
              onChanged: (bool value) {
                //print(value);
                value ? eventModel.publicType = "private" : eventModel.publicType = "public";   
                setState(() {
                  privacity =  value;
                });
              }
            ),
         )
       ],
      );
  }
    
}