import './es.dart' as Es;

class Language {
  // event
  String event;
  String popularEvents;
  String viewAll;
  String findEvent;
  // profile
  String profile;
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
}