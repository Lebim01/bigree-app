import 'package:event_country/Library/loader_animation/loader.dart';
import 'package:event_country/Library/loader_animation/dot.dart';
import 'package:event_country/Screen/Login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import '../../utils/lang/lang.dart' as Lang;
import 'package:event_country/models/register_models.dart';
import 'package:event_country/services/register_service.dart';
import 'package:email_validator/email_validator.dart';
import 'dart:convert';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';


final lang = Lang.Lang();

class signUp extends StatefulWidget {
  @override
  _signUpState createState() => _signUpState();
}

class _signUpState extends State<signUp> {
  final _formKey = GlobalKey<FormState>();
  bool _isSelected = false;
  File selectedImage;
  String filename;
  File tempImage;
  bool isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var profilePicUrl;
  String _pass2;

  RegisterModel registerModel = new RegisterModel(); 
  final productoService = RegisterServices();

  ///
  /// Response file from image picker
  ///
  Future<void> retrieveLostData() async {
    final LostDataResponse response = await ImagePicker.retrieveLostData();
    if (response == null) {
      return;
    }
    if (response.file != null) {
      setState(() {
        if (response.type == RetrieveType.video) {
        } else {}
      });
    } else {}
  }

  ///
  /// Get data from gallery image
  ///
  Future selectPhoto() async {
    tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    
    if(tempImage != null){
      setState(() {
        selectedImage = tempImage;
        filename = basename(selectedImage.path);
        var image = uploadImage().toString();
        retrieveLostData();
      });
    }
  }

  ///
  /// Upload image to firebase storage
  ///
  Future uploadImage() async {
    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(filename);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(selectedImage);
    var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
    profilePicUrl = dowurl.toString();
    registerModel.image = profilePicUrl;
    return profilePicUrl;
  }

  bool _obscureTextSignup = true;
  bool _obscureTextSignupConfirm = true;

  void _toggleSignup() {
    setState(() {
      _obscureTextSignup = !_obscureTextSignup;
    });
  }

  void _toggleSignupConfirm() {
    setState(() {
      _obscureTextSignupConfirm = !_obscureTextSignupConfirm;
    });
  }

  void _radio() {
    setState(() {
      _isSelected = !_isSelected;
    });
  }

  Widget radioButton(bool isSelected) => Container(
        width: 16.0,
        height: 16.0,
        padding: EdgeInsets.all(2.0),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 2.0, color: Colors.black)),
        child: isSelected
            ? Container(
                width: double.infinity,
                height: double.infinity,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.black),
              )
            : Container(),
      );

  Widget horizontalLine() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        child: Container(
          width: ScreenUtil.getInstance().setWidth(120),
          height: 1.0,
          color: Colors.black26.withOpacity(.2),
        ),
      );

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true);

    return new Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: true,
      body: isLoading
          ?

          ///
          /// Loading layout login
          ///
          Center(
              child: ColorLoader5(
              dotOneColor: Colors.red,
              dotTwoColor: Colors.blueAccent,
              dotThreeColor: Colors.green,
              dotType: DotType.circle,
              dotIcon: Icon(Icons.adjust),
              duration: Duration(seconds: 1),
            ))
          : Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Image.asset(
                        "assets/image/image_01.png",
                        height: 250.0,
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Image.asset("assets/image/image_02.png")
                  ],
                ),
                SingleChildScrollView(
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: 28.0, right: 28.0, top: 100.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            SizedBox(height: 20.0),
                            Text(
                                lang.signUp,
                                style: TextStyle(
                                    fontFamily: "Sofia",
                                    fontSize:
                                        ScreenUtil.getInstance().setSp(60),
                                    letterSpacing: 1.2,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold))
                          ],
                        ),
                        SizedBox(
                          height: ScreenUtil.getInstance().setHeight(180),
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black12.withOpacity(0.08),
                                    offset: Offset(0.0, 15.0),
                                    blurRadius: 15.0),
                                BoxShadow(
                                    color: Colors.black12.withOpacity(0.01),
                                    offset: Offset(0.0, -10.0),
                                    blurRadius: 10.0),
                              ]),
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 0.0, right: 0.0, top: 0.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: 200.0,
                                    height: 60.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(80.0)),
                                      color: Color(0xFFD898F8),
                                    ),
                                    child: Center(
                                      child: Text(
                                          lang.signUp,
                                          style: TextStyle(
                                              fontSize: ScreenUtil.getInstance()
                                                  .setSp(50),
                                              fontFamily: "Sofia",
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                              letterSpacing: .80)),
                                    ),
                                  ),
                                  SizedBox(
                                    height:
                                        ScreenUtil.getInstance().setHeight(30),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, right: 20.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                height: 100.0,
                                                width: 100.0,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                50.0)),
                                                    color: Colors.blueAccent,
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Colors.black12
                                                              .withOpacity(0.1),
                                                          blurRadius: 10.0,
                                                          spreadRadius: 4.0)
                                                    ]),
                                                child: selectedImage == null
                                                    ? new Stack(
                                                        children: <Widget>[
                                                          CircleAvatar(
                                                            backgroundColor:
                                                                Colors
                                                                    .blueAccent,
                                                            radius: 400.0,
                                                            backgroundImage:
                                                                AssetImage(
                                                              "assets/image/emptyProfilePicture.png",
                                                            ),
                                                          ),
                                                          Align(
                                                            alignment: Alignment
                                                                .bottomRight,
                                                            child: InkWell(
                                                              onTap: () {
                                                                selectPhoto();
                                                              },
                                                              child: Container(
                                                                height: 30.0,
                                                                width: 30.0,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              50.0)),
                                                                  color: Colors
                                                                      .blueAccent,
                                                                ),
                                                                child: Center(
                                                                  child: Icon(
                                                                    Icons.add,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 18.0,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : new CircleAvatar(
                                                        backgroundImage:
                                                            new FileImage(
                                                                selectedImage),
                                                        radius: 220.0,
                                                      ),
                                              ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              Text(
                                                lang.photoProfile,
                                                style: TextStyle(
                                                    fontFamily: "Sofia",
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Text(
                                            lang.name,
                                            style: TextStyle(
                                                fontFamily: "Sofia",
                                                fontSize:
                                                    ScreenUtil.getInstance()
                                                        .setSp(30),
                                                letterSpacing: .9,
                                                fontWeight: FontWeight.w600)),
                                        TextFormField(
                                          initialValue: registerModel.name,
                                          validator: (input) { return _inputValidate(input , lang.name, false); },
                                          onSaved: (value) => registerModel.name = value,
                                          keyboardType: TextInputType.text,
                                          textCapitalization:
                                              TextCapitalization.words,
                                          style: TextStyle(
                                              fontFamily: "WorkSofiaSemiBold",
                                              fontSize: 16.0,
                                              color: Colors.black),
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            icon: Icon(
                                              FontAwesomeIcons.user,
                                              size: 19.0,
                                              color: Colors.black45,
                                            ),
                                            hintText: lang.name,
                                            hintStyle: TextStyle(
                                                fontFamily: "Sofia",
                                                fontSize: 15.0),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Text(
                                            lang.country,
                                            style: TextStyle(
                                                fontFamily: "Sofia",
                                                fontSize:
                                                    ScreenUtil.getInstance()
                                                        .setSp(30),
                                                letterSpacing: .9,
                                                fontWeight: FontWeight.w600)),
                                        TextFormField(
                                          validator: (input) {
                                            if (input.isEmpty) {
                                              return lang.inputYour + lang.country.toLowerCase();
                                            }
                                          },
                                          onSaved: (value) => registerModel.country = value,
                                          keyboardType: TextInputType.text,
                                          textCapitalization:
                                              TextCapitalization.words,
                                          style: TextStyle(
                                              fontFamily: "WorkSofiaSemiBold",
                                              fontSize: 16.0,
                                              color: Colors.black),
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            icon: Icon(
                                              FontAwesomeIcons.university,
                                              size: 19.0,
                                              color: Colors.black45,
                                            ),
                                            hintText: lang.country,
                                            hintStyle: TextStyle(
                                                fontFamily: "Sofia",
                                                fontSize: 15.0),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Text(
                                            lang.city,
                                            style: TextStyle(
                                                fontFamily: "Sofia",
                                                fontSize:
                                                    ScreenUtil.getInstance()
                                                        .setSp(30),
                                                letterSpacing: .9,
                                                fontWeight: FontWeight.w600)),
                                        TextFormField(
                                          validator: (input) { return _inputValidate(input , lang.city, false); },
                                          onSaved: (value) => registerModel.city = value,
                                          keyboardType: TextInputType.text,
                                          textCapitalization:
                                              TextCapitalization.words,
                                          style: TextStyle(
                                              fontFamily: "WorkSofiaSemiBold",
                                              fontSize: 16.0,
                                              color: Colors.black),
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            icon: Icon(
                                              Icons.location_city,
                                              size: 22.0,
                                              color: Colors.black45,
                                            ),
                                            hintText: lang.city,
                                            hintStyle: TextStyle(
                                                fontFamily: "Sofia",
                                                fontSize: 15.0),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Text(
                                            lang.email,
                                            style: TextStyle(
                                                fontFamily: "Sofia",
                                                fontSize:
                                                    ScreenUtil.getInstance()
                                                        .setSp(30),
                                                letterSpacing: .9,
                                                fontWeight: FontWeight.w600)),
                                        TextFormField(
                                          initialValue: registerModel.username,
                                          validator: (input) {
                                            if (input.isEmpty) {
                                              return lang.inputYour + lang.email.toLowerCase();
                                            }
                                            if (!EmailValidator.validate(input.toString())) {
                                              return lang.inputInvalid;
                                            }
                                          },
                                          onSaved: (value) => registerModel.username = value,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          style: TextStyle(
                                              fontFamily: "WorkSofiaSemiBold",
                                              fontSize: 16.0,
                                              color: Colors.black),
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            icon: Icon(
                                              FontAwesomeIcons.envelope,
                                              color: Colors.black45,
                                              size: 18.0,
                                            ),
                                            hintText: lang.emailAddress,
                                            hintStyle: TextStyle(
                                                fontFamily: "Sofia",
                                                fontSize: 16.0),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Text(
                                            lang.password,
                                            style: TextStyle(
                                                fontFamily: "Sofia",
                                                fontSize:
                                                    ScreenUtil.getInstance()
                                                        .setSp(30),
                                                letterSpacing: .9,
                                                fontWeight: FontWeight.w600)),
                                        TextFormField(
                                          initialValue: registerModel.password,
                                          obscureText: _obscureTextSignup,
                                          validator: (input) { return _inputValidate(input , lang.password, true); },
                                          onSaved: (value) => registerModel.password = value,
                                          style: TextStyle(
                                              fontFamily: "WorkSofiaSemiBold",
                                              fontSize: 16.0,
                                              color: Colors.black45),
                                          decoration: InputDecoration (
                                            border: InputBorder.none,
                                            icon: Icon(
                                              FontAwesomeIcons.lock,
                                              color: Colors.black45,
                                              size: 18.0,
                                            ),
                                            hintText: lang.password,
                                            hintStyle: TextStyle(
                                                fontFamily: "Sofia",
                                                fontSize: 16.0),
                                            suffixIcon: IconButton (
                                                onPressed: () { 
                                                    _toggleSignup();
                                                },
                                                color : Colors.white,
                                                icon : Icon( FontAwesomeIcons.eye, size: 18.0, color: Colors.black)),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Text(
                                            lang.repeatPassword,
                                            style: TextStyle(
                                                fontFamily: "Sofia",
                                                fontSize:
                                                    ScreenUtil.getInstance()
                                                        .setSp(30),
                                                letterSpacing: .9,
                                                fontWeight: FontWeight.w600)),
                                        TextFormField(obscureText:
                                              _obscureTextSignupConfirm,
                                          validator: (input) { return _inputValidate(input , lang.password, true); },
                                          onSaved: (input) => _pass2 = input,
                                          style: TextStyle(
                                              fontFamily: "WorkSofiaSemiBold",
                                              fontSize: 16.0,
                                              color: Colors.black45),
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            icon: Icon(
                                              FontAwesomeIcons.lock,
                                              color: Colors.black45,
                                              size: 18.0,
                                            ),
                                            hintText: lang.repeatPassword,
                                            hintStyle: TextStyle(
                                                fontFamily: "Sofia",
                                                fontSize: 16.0),
                                            suffixIcon: IconButton (
                                                onPressed: () { 
                                                    _toggleSignupConfirm();
                                                },
                                                color : Colors.white,
                                                icon : Icon( FontAwesomeIcons.eye, size: 18.0, color: Colors.black)),
                                          ),
                                        ),
                                        SizedBox(
                                          height: ScreenUtil.getInstance()
                                              .setHeight(35),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: ScreenUtil.getInstance().setHeight(40)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            InkWell(
                              child: Container(
                                width: ScreenUtil.getInstance().setWidth(600),
                                height: ScreenUtil.getInstance().setHeight(90),
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                      Color(0xFFD898F8),
                                      Color(0xFF8189EC)
                                    ]),
                                    borderRadius: BorderRadius.circular(6.0),
                                    boxShadow: [
                                      BoxShadow(
                                          color:
                                              Color(0xFF6078ea).withOpacity(.3),
                                          offset: Offset(0.0, 8.0),
                                          blurRadius: 8.0)
                                    ]),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () async {
                                      
                                      SharedPreferences prefs;
                                      prefs = await SharedPreferences.getInstance();
                                      final formState = _formKey.currentState;
                                      
                                      if (formState.validate()) {
                                        try {
                                          formState.save();                                          
                                          if(registerModel.password != _pass2.toString().trim()){
                                            showDialogAlert(context, lang.passwordNotMatch, 'alert');
                                          } else {
                                            setState((){
                                              isLoading = true;
                                            });

                                            _savedData(context, 'email');
                                          }
                                        } catch (e) {
                                            showDialogAlert(context, e.message, 'interfaz');
                                        } finally {
                                            setState(() {
                                              isLoading = false;
                                            });
                                        }
                                      } else {
                                        showDialogAlert(context, lang.inputAll, 'alert');
                                      }
                                    },
                                    child: Center(
                                      child: 
                                        Text(
                                          lang.signUp.toUpperCase(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: "Poppins-Bold",
                                              fontSize: 25,
                                              letterSpacing: 4.0)),
                                          
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: ScreenUtil.getInstance().setHeight(40)),
                        Row (
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(right: 30.0),
                            child : RaisedButton (
                              onPressed: () { _loginWithFacebook(context); },
                              textColor: Colors.white,
                              padding: EdgeInsets.all(0.0),
                              child: Container(
                                width: ScreenUtil.getInstance().setWidth(80),
                                height: ScreenUtil.getInstance().setHeight(90),
                                decoration: BoxDecoration (
                                  borderRadius: BorderRadius.circular(6.0),
                                  gradient: LinearGradient(
                                    colors: <Color>[
                                      Color(0xFF0D47A1),
                                      Color(0xFF1976D2),
                                      Color(0xFF42A5F5)])),
                                padding: EdgeInsets.all(10.0),
                                child: Icon(FontAwesomeIcons.facebook, size : 50)))),
                          Container(
                            margin: EdgeInsets.only(right: 0.0),
                            child : RaisedButton (
                              onPressed: () { _loginWithGoogle(); },
                              textColor: Colors.white,
                              padding: EdgeInsets.all(0.0),
                              child: Container(
                                width: ScreenUtil.getInstance().setWidth(80),
                                height: ScreenUtil.getInstance().setHeight(90),
                                decoration: BoxDecoration (
                                  borderRadius: BorderRadius.circular(5.0),
                                  gradient: LinearGradient(
                                    colors: <Color>[
                                      Color(0xFF8C0404),
                                      Color(0xFFFC2424),
                                      Color(0xFFFC2424)])),
                                padding: EdgeInsets.all(10.0),
                                child: Icon(FontAwesomeIcons.googlePlus, size : 50))))],
                        ),
                        SizedBox(height: ScreenUtil.getInstance().setHeight(40)),
                        Row (
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[horizontalLine(), Text(lang.haveAccount, style: TextStyle(fontSize: 13.0, fontFamily: "Sofia")), horizontalLine()],
                        ),
                        SizedBox(height: ScreenUtil.getInstance().setHeight(30)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[],
                        ),
                        SizedBox(height: ScreenUtil.getInstance().setHeight(0)),
                        Row (
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            InkWell(
                              onTap: () { Navigator.of(context).pushReplacement(PageRouteBuilder(pageBuilder: (_, __, ___) => login())); },
                              child: Container(
                                height: 50.0,
                                width: 300.0,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40.0)),
                                  border: Border.all(
                                      color: Color(0xFFD898F8), width: 1.0)),
                                child: Center(
                                  child: Text(
                                      lang.login,
                                      style: TextStyle(
                                          color: Color(0xFFD898F8),
                                          fontWeight: FontWeight.w300,
                                          letterSpacing: 1.4,
                                          fontSize:20.0,
                                          fontFamily: "Sofia")))))],
                        ),
                        SizedBox(height: 40.0),
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }


  void _savedData(context, String type){

    switch(type){
      case 'email' :
        
        if(!_formKey.currentState.validate()) return;
        _formKey.currentState.save();
      
      break;
      case 'facebook' : 
        print("registrando por fb");
      break;
      case 'google' : 
        print("registrando por google");
      break;
    }
    
    if(registerModel.username != null && registerModel.password != null){
        productoService.createRegister(registerModel).then((resp){
          Map<String, dynamic> data = jsonDecode(resp);                                                  
          
          if(data["data"]["register"] != null){
            _mostrarAlert(context, lang.ocurredSuccess, lang.verifyEmail, 'comprobado', true);
          } else { 
            _mostrarAlert(context, lang.ocurredProblem, data["errors"][0]["message"].toString() , 'interfaz', false);
          }
      });
    }
  }

  Future<FirebaseUser> _loginWithFacebook(context) async {
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(['email']);

    if(result.status != FacebookLoginStatus.loggedIn){
      return null;
    }

    final AuthCredential credential = FacebookAuthProvider.getCredential(
      accessToken: result.accessToken.token,
    );

    final FirebaseUser user = await _auth.signInWithCredential(credential);
    
    registerModel.username = user.email;
    registerModel.image = user.photoUrl;
    registerModel.name = user.displayName;
    registerModel.password = user.uid;
    
    _savedData(context, 'facebook');
    return user;
  }

  String _loginWithGoogle() {
    print("hola2");

    return 'hola2';
  }

  String _inputValidate(String value, String name, bool isPassword){
    if(value.isEmpty) {
      return lang.inputYour + name.toLowerCase();
    }

    if(value.trim().isEmpty) {
      return lang.inputInvalid;
    }

    if(isPassword){
      if(value.length < 8){
        return lang.passwordShort;
      }
    }
  }

  void showDialogAlert(context, String text, String img){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Text(lang.ocurredProblem, textAlign: TextAlign.center),
          content: Column( mainAxisSize: MainAxisSize.min, children: <Widget> [Text(text, textAlign: TextAlign.center), SizedBox(height: 20.0), image(img)]),
          actions: <Widget>[
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      }
    );
  }


  void _mostrarAlert(context, String titulo, String text, String img, bool success){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context){
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Text(titulo, textAlign: TextAlign.center),
          content: Column (
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[ Text(text, textAlign: TextAlign.center), SizedBox(height: 20.0), image(img)]),
            actions: <Widget>[
              FlatButton(
                  child: Text('OK'),
                  onPressed: (){ 
                    Navigator.of(context).pop(); 
                    success ? _redirect(context) : null;
                  })],
        );
      }
    );
  } 

  void _redirect(context) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(pageBuilder: (_, __, ___) => new login())
    );
  }

  Widget image(String img){
    return Image(
      image: AssetImage('assets/image/$img.png'),
      width: 100,
      );
  }
}
