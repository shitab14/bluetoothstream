import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:watermonitoringapp/common/constants/colors_app.dart';

//text input field type
enum TextFieldType {Email, Password, Number, Text}
enum TextFieldDecorationType {UnderLineTextField, BoxTextField}

class InputField extends StatefulWidget {
  TextEditingController? textEditingController;
  final bool? textFieldEnabled;
  final TextStyle? textStyle;
  final String? labelTextValue;
  final TextStyle? labelTextStyle;
  final String? hintTextValue;
  final TextStyle? hintTextStyle;
  final TextFieldType? textFieldType;
  final TextFieldDecorationType? textFieldDecorationType;
  final Function(String value)? onChanged;
  final String? Function(String? text)? validation;
  final bool? hasSuffixIcon;
  final bool? hasPrefixElement;
  final String? prefixText;
  final int? maxLinesNo;
  final bool? hasLetterCounter;
  final int? maxLetterCount;
  final EdgeInsetsGeometry? inputFieldContentPadding;

  InputField({Key? key,this.textEditingController,this.textFieldEnabled,this.textStyle,this.labelTextValue,this.labelTextStyle, this.hintTextValue, this.hintTextStyle, this.textFieldType,this.textFieldDecorationType = TextFieldDecorationType.BoxTextField, this.onChanged, this.validation, this.hasSuffixIcon = false, this.hasPrefixElement = false, this.prefixText, this.maxLinesNo = 1,this.hasLetterCounter = false,this.maxLetterCount = 0,this.inputFieldContentPadding}) : super(key: key){
    if(textEditingController == null) textEditingController = TextEditingController();
  }

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  FocusNode? _textFieldNode;

  bool _obscureText = true;

  // TextEditingController? textEditingController;

  @override
  void initState() {
    super.initState();
    _textFieldNode = FocusNode();
    // widget.textEditingController ??= TextEditingController();
    // textEditingController = new TextEditingController();
  }

  @override
  void dispose() {
    _textFieldNode!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: _textFieldNode,
      controller: widget.textEditingController,
      readOnly: (widget.textFieldEnabled!=null) ? widget.textFieldEnabled! : false,
      keyboardType: widget.textFieldType == TextFieldType.Email ? TextInputType
          .emailAddress : (widget.textFieldType == TextFieldType.Number
          ? const TextInputType
          .numberWithOptions(decimal: true)
          : TextInputType.text),
      onChanged: (value){
        setState(() {
          widget.onChanged;
        });
      },
      style: (widget.textStyle != null)
          ? widget.textStyle
          : TextStyle(
        color: Colors.black,
        fontSize: 14.sp,
        fontStyle: FontStyle.normal,
      ),
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        alignLabelWithHint: true,
        floatingLabelBehavior: (widget.textFieldEnabled!=null) ? (widget.textFieldEnabled! ? FloatingLabelBehavior.always : null) : null,
        counterText: widget.hasLetterCounter! ? '${widget.textEditingController!.text
            .length}/${widget.maxLetterCount}' : null,
        labelText: widget.labelTextValue,
        labelStyle: (widget.labelTextStyle != null)
            ? widget.labelTextStyle
            : TextStyle(
          color: AppColors.instance.textFieldLabelColor,
          fontSize: 14.sp,
          fontStyle: FontStyle.normal,
        ),
        hintText: widget.hintTextValue,
        hintStyle: (widget.hintTextStyle != null)
            ? widget.hintTextStyle
            : TextStyle(color: AppColors.instance.textFieldHintColor,
            fontSize: 14.sp,
            fontStyle: FontStyle.normal),
        contentPadding: widget.inputFieldContentPadding ?? EdgeInsets.all(15.w),
        enabledBorder: (widget.textFieldDecorationType ==
            TextFieldDecorationType.BoxTextField) ? OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.r),
          borderSide: BorderSide(
            color: AppColors.instance.textFieldBorderColor,
          ),
        ) : UnderlineInputBorder(
          borderRadius: BorderRadius.circular(5.r),
          borderSide: BorderSide(
            color: AppColors.instance.textFieldBorderColor,
            width: 5,
          ),
        ),
        focusedBorder: (widget.textFieldDecorationType ==
            TextFieldDecorationType.BoxTextField) ? OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(5.r),
          borderSide: BorderSide(
            color: AppColors.instance.textFieldBorderColor,
          ),) : UnderlineInputBorder(
          borderRadius:
          BorderRadius.circular(5.r),
          borderSide: BorderSide(
            color: AppColors.instance.textFieldBorderColor,
            width: 5,
          ),
        ),
        errorBorder: (widget.textFieldDecorationType ==
            TextFieldDecorationType.BoxTextField) ? OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(5.r),
          borderSide: BorderSide(
            color: AppColors.instance.textFieldErrorBorderColor,
          ),) : UnderlineInputBorder(
          borderRadius:
          BorderRadius.circular(5.r),
          borderSide: BorderSide(
            color: AppColors.instance.textFieldErrorBorderColor,
            width: 5,
          ),
        ),
        focusedErrorBorder: (widget.textFieldDecorationType ==
            TextFieldDecorationType.BoxTextField) ? OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(5.r),
          borderSide: BorderSide(
            color: AppColors.instance.textFieldBorderColor,
          ),) : UnderlineInputBorder(
          borderRadius:
          BorderRadius.circular(5.r),
          borderSide: BorderSide(
            color: AppColors.instance.textFieldBorderColor,
            width: 5,
          ),
        ),
        border: InputBorder.none,
        suffixIcon: widget.hasSuffixIcon! ? IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: _obscureText
                ? AppColors.instance.textFieldHintColor
                : AppColors.instance.textFieldBorderColor,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ) : null,
        prefixText: widget.hasPrefixElement! ? widget.prefixText! : null,
        errorStyle: TextStyle(
            color: AppColors.instance.textFieldErrorHintColor, fontSize: 12.sp),
        errorMaxLines: 2,
      ),
      maxLines: widget.maxLinesNo,
      validator: widget.validation,
      // onSaved: (password) =>
      //     _password = password, //// onSaved: (email)=> _emailID = email,
      // textInputAction: TextInputAction.next,
      obscureText: widget.hasSuffixIcon! ? _obscureText : false,
    );
  }
}