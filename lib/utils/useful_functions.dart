

class UsefulFunctions{

 static String getLocalDateTime(String datetime){

    DateTime create_date = DateTime.parse(datetime);
create_date = create_date.toLocal();

//String convertedDateTime = "${create_date.year.toString()}-${create_date.month.toString().padLeft(2,'0')}-${create_date.day.toString().padLeft(2,'0')} ${create_date.hour.toString().padLeft(2,'0')}-${create_date.minute.toString().padLeft(2,'0')}";
 
String convertedDateTime = "${create_date.year.toString()}-${create_date.month.toString().padLeft(2,'0')}-${create_date.day.toString().padLeft(2,'0')}";
 
return convertedDateTime;
 }
}
