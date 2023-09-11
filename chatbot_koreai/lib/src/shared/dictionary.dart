import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/date_symbol_data_local.dart' as intl;
extension StringExtensions on DateTime {

  String formattTime() {
    tz.initializeTimeZones(); // Inicializa a biblioteca timezone
    final DateTime timeDate = tz.TZDateTime.from(this, tz.getLocation('America/Sao_Paulo'));
    String time = DateFormat('HH:mm').format(timeDate);
    return time;
  }

  String formattDate() {
    intl.initializeDateFormatting();
    tz.initializeTimeZones(); // Inicializa a biblioteca timezone
    final DateTime date = tz.TZDateTime.from(this, tz.getLocation('America/Sao_Paulo'));
    String dataFormatada = DateFormat('MMMMd', 'pt_BR').format(date);
    return dataFormatada;
  }
}
