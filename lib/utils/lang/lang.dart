import './es.dart' as Es;

class Language {
  String logout;
  String loading;
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

}