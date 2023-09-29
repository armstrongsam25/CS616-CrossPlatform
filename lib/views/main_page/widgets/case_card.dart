import 'package:Skywalk/models/user_case.dart';
import 'package:Skywalk/utils/useful_functions.dart';
import 'package:flutter/material.dart'; 
import 'package:percent_indicator/percent_indicator.dart';

class CaseCard extends StatefulWidget {

  final UserCase userCase; 
  const CaseCard({super.key,  required this.userCase});
  

  @override
  State<CaseCard> createState() => _CaseCardState();
}

class _CaseCardState extends State<CaseCard> {
  @override
  Widget build(BuildContext context) {
   return   Card(  
                elevation: 3,
      
               // color: ( widget.completed ? Theme.of(context).cardColor :Colors.deepOrange.shade900  ),
        child: InkWell(
          onTap: (){

          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 7,
                child: Column( 
                    
                    children: <Widget>[
                  ListTile(
                   leading: Icon(Icons.folder),
                   title: Text('Case ' + widget.userCase.case_name.toString()),
                   subtitle: Text('Date: '+ UsefulFunctions.getLocalDateTime(widget.userCase.create_date!)),
                 ),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: <Widget>[
                     TextButton(
                       
                       child: Row(crossAxisAlignment: CrossAxisAlignment.center,  children: [ Icon(Icons.picture_as_pdf,
                     ),  SizedBox(width: 10,),Text("Report")]),
                      onPressed: (widget.userCase.completed! ? () {/* ... */} : null),
                     ), 
                     TextButton(
                       
                       child: Row(crossAxisAlignment: CrossAxisAlignment.center,  children: [ Icon(Icons.delete ),  SizedBox(width: 10,),Text("Delete")]),
                      
                       onPressed: () {/* ... */},
                     ),
                     const SizedBox(width: 8),
                   ],
                 ),
                    ],
                  ),
              ),
              Flexible(
                flex: 3,
                child: 
                
              widget.userCase.completed! ? 
                
                
                CircularPercentIndicator(
                radius: 35.0,
                progressColor: Theme.of(context).colorScheme.primary, 
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                lineWidth: 5.0,
                animation: true,
                percent:  (widget.userCase.success_rate! / 100) ,
                center: new Text(
                  widget.userCase.success_rate.toString() + "%",
                  style:
                      new TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),) :  CircularPercentIndicator(
                radius: 35.0,
                progressColor: Theme.of(context).colorScheme.primary, 
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                lineWidth: 5.0,
                animation: true,
                percent:  0,
                center: new Text(  "0.0%",
                  style:
                      new TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),)) 
            ],
          ),
        ),
      );
  }
}