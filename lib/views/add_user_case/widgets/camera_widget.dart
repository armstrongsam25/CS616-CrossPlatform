// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class CameraWidget extends StatelessWidget {

  final VoidCallback callback;
  const CameraWidget({
    Key? key,
    required this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  DottedBorder(
      borderType: BorderType.RRect,
      radius: Radius.circular(12),
      padding: EdgeInsets.all(3),
      strokeWidth: 3,
      borderPadding: EdgeInsets.all(3),
      //strokeCap: StrokeCap.,
      color: Theme.of(context).colorScheme.secondary,
      child: InkWell(
        onTap: callback,
        child: Container(
            height: 150,
            width: double.infinity,
            alignment: Alignment.center,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12))), 
          child: Icon(Icons.camera_enhance,size: 42,color: Theme.of(context).colorScheme.secondary),
        ),
      ),
    );
  }
}
