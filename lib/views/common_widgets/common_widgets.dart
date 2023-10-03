
import 'package:Skywalk/models/status.dart';
import 'package:Skywalk/utils/status_codes.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart'; 
class CommonWidgets{
 
static SnackBar getAweSomeSnackBar(Status status){

  ContentType contentType = ContentType.success;
  String title="Succuess";
  switch(status.type){
    case -1:
      contentType= ContentType.failure;
      title= "Error";
      break;
    case 0:
      contentType= ContentType.warning;
      title= "Warning";
      break;
    case 1:
      contentType= ContentType.success;
      title= "Message";
      break;

  }
  return SnackBar(
                  /// need to set following properties for best effect of awesome_snackbar_content
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  content: AwesomeSnackbarContent(
                    title: title,
                    message: status.codeString,

                    /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                    contentType: contentType,
                  ),
                );
 
}
static Widget getInformationCard(context, int status_code ){
  String title="Warning";
  Color messageColor = Colors.amber.shade300;
  Status status = STATUS_CODES.getStatusByCode(status_code);
  switch(status.type){
    case -1: 
      title= "Error";
      messageColor= Colors.red.shade300;
      break;
    case 0: 
      title= "Warning";
      messageColor= Colors.amber.shade300;
      break;
    case 1: 
      title= "Message";
      messageColor= Theme.of(context).colorScheme.primary;
      break;

  }

  Card infoCard= Card(
    
    child: Container(
      padding: EdgeInsets.all(8),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
    children: [
      
      Text(title, style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: messageColor)), 
      SizedBox(height: 10,),
      Text(status.codeString, style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: messageColor))],
    
      ),
    ),


  );
  return infoCard;
}
}