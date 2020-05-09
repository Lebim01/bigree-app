import './es.dart' as Es;

class Language {
  String logout;
  String loading;
  String login;
  //on boarding
  String skip;
  String done;
  // event
  String allEvents;
  String event;
  String popularEvents;
  String viewAll;
  String findEvent;
  String about;
  String join;
  String joined;
  String createdEvent;
  String title;
  String description;
  String date;
  String price;
  // profile
  String profile;
  String editProfile;
  // search
  String search;
  String whatWouldSearch;
  // category
  String category;
  // Manage event
  String manageEvent;
  String location;
  //SignUp
  String signUp;
  String photoProfile;
  String name;
  String country;
  String city;
  String email;
  String emailAddress;
  String password;
  String repeatPassword; 
  String rememberMe;
  String signIn;
}

class Lang implements Language {
  Lang(){
    final es = Es.Es();
    this.setLang(es);
  }

  void setLang(Language lang){
    this.event = lang.event;
    this.findEvent = lang.findEvent;
    this.popularEvents = lang.popularEvents;
    this.profile = lang.profile;
    this.viewAll = lang.viewAll;
    this.whatWouldSearch = lang.whatWouldSearch;
    this.search = lang.search;
    this.category = lang.category;
    this.manageEvent = lang.manageEvent;
    this.editProfile = lang.editProfile;
    this.logout = lang.logout;
    this.allEvents = lang.allEvents;
    this.location = lang.location;
    this.about = lang.about;
    this.joined = lang.joined;
    this.join = lang.join;
    this.createdEvent = lang.createdEvent;
    this.loading = lang.loading;
    this.signUp = lang.signUp;
    this.photoProfile = lang.photoProfile;
    this.name = lang.name;
    this.country = lang.country;
    this.city = lang.city;
    this.email = lang.email;
    this.emailAddress = lang.emailAddress;
    this.password = lang.password;
    this.repeatPassword = lang.repeatPassword;
    this.rememberMe = lang.rememberMe;
    this.signIn = lang.signIn;
    this.skip = lang.skip;
    this.done = lang.done;
    this.login = lang.login;
    this.title = lang.title;
    this.description = lang.description;
    this.date = lang.date;
    this.price = lang.price;
  }

  @override
  String event;

  @override
  String findEvent;

  @override
  String popularEvents;

  @override
  String profile;

  @override
  String viewAll;

  @override
  String whatWouldSearch;

  @override
  String search;

  @override
  String category;

  @override
  String manageEvent;

  @override
  String editProfile;

  @override
  String logout;

  @override
  String allEvents;

  @override
  String location;

  @override
  String about;

  @override
  String joined;

  @override
  String join;

  @override
  String createdEvent;

  @override
  String loading; 

  @override
  String signUp;

  @override
  String photoProfile;

  @override
  String name;

  @override
  String country;

  @override
  String city;

  @override
  String email;

  @override
  String password;

  @override
  String repeatPassword;

  @override
  String emailAddress;

  @override
  String rememberMe;

  @override
  String signIn;

  @override
  String skip;

  @override
  String done;

  @override
  String login;

  @override
  String title;

  @override
  String description;

  @override
  String date;

  @override
  String price;
}