import 'package:flutter/material.dart';
import 'package:flutter_todo_app/res/custom_colors.dart';
import 'package:flutter_todo_app/utils/database.dart';
import 'package:flutter_todo_app/utils/validator.dart';
import 'custom_form_field.dart';

class AddItemForm extends StatefulWidget {
  final FocusNode titleFocusNode;
  final FocusNode descriptionFocusNode;
  const AddItemForm({
    required this.titleFocusNode,
    required this.descriptionFocusNode,
  });

  @override
  _AddItemFormState createState() => _AddItemFormState();
}

class _AddItemFormState extends State<AddItemForm> {
  final _addItemFormKey = GlobalKey<FormState>();
  bool _isProcessing = false;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _addItemFormKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
              bottom: 24.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 24.0),
                Text(
                  'Title',
                  style: TextStyle(
                    color: CustomColors.firebaseGrey,
                    fontSize: 22.0,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                CustomFormField(
                  controller: _titleController,
                  focusNode: widget.titleFocusNode,
                  keyBoardType: TextInputType.text,
                  inputAction: TextInputAction.next,
                  label: 'Title',
                  hint: 'Enter your note title',
                  validator: (value) => Validator.validateField(value: value),
                ),
                SizedBox(
                  height: 24.0,
                ),
                Text(
                  'Description',
                  style: TextStyle(
                    color: CustomColors.firebaseGrey,
                    fontSize: 22.0,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CustomFormField(
                  controller: _descriptionController,
                  focusNode: widget.descriptionFocusNode,
                  keyBoardType: TextInputType.text,
                  inputAction: TextInputAction.done,
                  label: 'Description',
                  hint: 'Enter your note description',
                  validator: (value) => Validator.validateField(value: value),
                ),
              ],
            ),
          ),
          _isProcessing
            ? Padding(
            padding: const EdgeInsets.all(16.0),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                CustomColors.firebaseOrange,
              ),
            ),
          ) : Container(
            width: double.maxFinite,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  CustomColors.firebaseOrange
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              onPressed: () async {
                widget.titleFocusNode.unfocus();
                widget.descriptionFocusNode.unfocus();
                if(_addItemFormKey.currentState!.validate()) {
                  _isProcessing = true;

                await Database.addItem(
                  title: _titleController.text,
                  description: _descriptionController.text,
                );
                setState(() {
                  _isProcessing = false;
                });
                Navigator.of(context).pop();
                }
              },
              child: Padding(
                padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                child: Text(
                  'ADD ITEM',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: CustomColors.firebaseGrey,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
