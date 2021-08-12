import 'package:flutter/material.dart';
import 'package:flutter_todo_app/res/custom_colors.dart';
import 'package:flutter_todo_app/utils/database.dart';
import 'package:flutter_todo_app/utils/validator.dart';
import 'custom_form_field.dart';

class EditItemForm extends StatefulWidget {
  final FocusNode titleFocusNode;
  final FocusNode descriptionFocusNode;
  final String currentTitle;
  final String currentDescription;
  final String documentId;

  const EditItemForm(
      {required this.titleFocusNode,
      required this.descriptionFocusNode,
      required this.currentTitle,
      required this.currentDescription,
      required this.documentId});

  @override
  _EditItemFormState createState() => _EditItemFormState();
}

class _EditItemFormState extends State<EditItemForm> {
  final _editItemFormKey = GlobalKey<FormState>();

  bool _isProcessing = false;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    _titleController = TextEditingController(text: widget.currentTitle);
    _descriptionController =
        TextEditingController(text: widget.currentDescription);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _editItemFormKey,
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
                SizedBox(
                  height: 24.0,
                ),
                Text(
                  'Title',
                  style: TextStyle(
                    color: CustomColors.firebaseGrey,
                    fontSize: 24.0,
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
                SizedBox(
                  height: 8.0,
                ),
                CustomFormField(
                  maxLines: 10,
                  isLabelEnabled: false,
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
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      CustomColors.firebaseOrange,
                    ),
                  ),
                )
              : Container(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        CustomColors.firebaseOrange,
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                      child: Text(
                        'UPDATE ITEM',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: CustomColors.firebaseGrey,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      widget.titleFocusNode.unfocus();
                      widget.descriptionFocusNode.unfocus();
                      if (_editItemFormKey.currentState!.validate()) {
                        setState(() {
                          _isProcessing = true;
                        });
                        await Database.updateItem(
                            title: _titleController.text,
                            description: _descriptionController.text,
                            docId: widget.documentId);
                        setState(() {
                          _isProcessing = false;
                        });
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                )
        ],
      ),
    );
  }
}
