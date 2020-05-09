import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
const locale = "es";

class Moment {
  String date;

  Moment(date);

  static Future<Moment> parse(String date) async {
    await initializeDateFormatting(locale);
    DateTime _date = DateFormat("yyyy-MM-dd").parse(date);
    return Moment(_date.toString());
  }

  String format(){
    return date;
  }
}