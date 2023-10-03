import 'package:flutter/material.dart'; 

AlertDialog getNewCaseAlert(BuildContext context) {

 TextEditingController _caseTextController = TextEditingController(); 
  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text("Cancel"),
    onPressed:  () {},
  );
  Widget continueButton = TextButton(
    child: Text("Continue"),
    onPressed:  () {  
       Navigator.pop(context,  _caseTextController.text); 
    },
  );

 TextFormField textFormField= TextFormField(
                                      controller: _caseTextController, 
                    
                                      decoration: InputDecoration(
                      labelText: 'Case name',
                                      )
                                      
                                    );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(

    title: Text("AlertDialog"),
    content: textFormField,
    
    actions: [
      cancelButton,
      continueButton,
    ],
  );
return alert;
  // show the dialog
}

Future<String> customDialogDisplay(BuildContext context, AlertDialog dialog ) async {

   String result=  await showDialog(
    context: context,

    builder: (BuildContext context) {
      return dialog;
    },
  ).then((value) {  
                    return value;

  }); 
  return result; 
}