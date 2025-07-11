// lib/views/application_form.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:country_list_pick/country_list_pick.dart';
import '../controllers/application_controller.dart';
import '../models/application.dart';

class ApplicationForm extends StatelessWidget {
  final String vacancyId;
  const ApplicationForm({super.key, required this.vacancyId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ApplicationController(),
      child: Scaffold(
        backgroundColor: const Color(0xFFD8D3CD),
        appBar: AppBar(
          backgroundColor: const Color(0xFF001A31),
          elevation: 0,
          leading: const BackButton(color: Colors.white),
          title: const Text(
            'Job application form',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          toolbarHeight: 80,
        ),
        body: _ApplicationFormBody(vacancyId: vacancyId),
      ),
    );
  }
}

class _ApplicationFormBody extends StatefulWidget {
  final String vacancyId;
  const _ApplicationFormBody({required this.vacancyId});
  @override
  State<_ApplicationFormBody> createState() => _ApplicationFormBodyState();
}

class _ApplicationFormBodyState extends State<_ApplicationFormBody> {
  final _formKey = GlobalKey<FormState>();

  // controllers
  final _fullName = TextEditingController();
  final _dob = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _secondPhone = TextEditingController();

  // other state
  String _phoneCountryCode = '+372';
  String _secondPhoneCountryCode = '+372';
  String? _gender;
  String _country = 'Estonia';
  bool _tapped = false;

  // маска для даты
  final _dobMask = MaskTextInputFormatter(
    mask: '## / ## / ####',
    filter: {"#": RegExp(r'\d')},
  );

  bool get _allFilled =>
      _fullName.text.isNotEmpty &&
          _dob.text.length == 14 &&
          _gender != null &&
          _phone.text.isNotEmpty &&
          _country.isNotEmpty;

  @override
  void dispose() {
    _fullName.dispose();
    _dob.dispose();
    _email.dispose();
    _phone.dispose();
    _secondPhone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<ApplicationController>();

    return Column(
      children: [
        Expanded(
          child: Form(
            key: _formKey,
            autovalidateMode:
            _tapped ? AutovalidateMode.always : AutovalidateMode.disabled,
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const Text('Personal Information',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF001A31))),
                const SizedBox(height: 16),

                // Full name
                _buildTextField(
                  controller: _fullName,
                  label: 'Full name *',
                  hint: 'First Name and Last name',
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),

                // Date of birth
                _buildTextField(
                  controller: _dob,
                  label: 'Date of birth *',
                  hint: 'DD / MM / YYYY',
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    _dobMask,
                  ],
                  suffix: _dob.text.length == 14
                      ? Icons.check_circle
                      : Icons.calendar_today,
                  validator: (v) =>
                  v!.length < 14 ? 'Please enter full date' : null,
                ),

                // Gender
                const SizedBox(height: 12),
                const Text('Gender *',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Color(0xFF001A31))),
                const SizedBox(height: 4),
                Row(
                  children: ['Male', 'Female', 'Other']
                      .map((label) => Expanded(
                    child: Row(
                      children: [
                        Radio<String>(
                          value: label,
                          groupValue: _gender,
                          activeColor: Colors.orange,
                          onChanged: (v) =>
                              setState(() => _gender = v),
                        ),
                        Text(label),
                      ],
                    ),
                  ))
                      .toList(),
                ),
                if (_gender != null)
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Icon(Icons.check_circle, color: Colors.green),
                  ),

                // Email
                _buildTextField(
                  controller: _email,
                  label: 'Email address (optional)',
                  hint: 'info@intrezo.ee',
                  validator: (v) => (v != null &&
                      v.isNotEmpty &&
                      !v.contains('@'))
                      ? 'Invalid'
                      : null,
                ),

                // Phone number
                const SizedBox(height: 12),
                const Text('Phone number *',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Color(0xFF001A31))),
                const SizedBox(height: 4),
                _buildPhoneRow(
                  _phoneCountryCode,
                      (v) {
                    if (v != null) setState(() => _phoneCountryCode = v);
                  },
                  _phone,
                  '1234 5678',
                ),

                // Second phone
                const SizedBox(height: 12),
                const Text('Second phone (optional)',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Color(0xFF001A31))),
                const SizedBox(height: 4),
                _buildPhoneRow(
                  _secondPhoneCountryCode,
                      (v) {
                    if (v != null) setState(() => _secondPhoneCountryCode = v);
                  },
                  _secondPhone,
                  '5678 9012',
                ),

                // Citizenship via country_list_pick
                const SizedBox(height: 12),
                const Text('Citizenship *',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Color(0xFF001A31))),
                const SizedBox(height: 4),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CountryListPick(
                    initialSelection: _country,
                    theme: CountryTheme(
                      isShowTitle: true,
                      isDownIcon: false,
                      showEnglishName: true,
                      isShowCode: false,
                    ),
                    onChanged: (CountryCode? code) {
                      if (code != null) setState(() => _country = code.name!);
                    },
                  ),
                ),


                if (_tapped && !_allFilled)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      'Please fill in all required fields.',
                      style:
                      TextStyle(color: Colors.red[700], fontSize: 14),
                    ),
                  ),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ),

        // Footer button
        ctrl.isSubmitting
            ? const Padding(
          padding: EdgeInsets.all(24),
          child: CircularProgressIndicator(),
        )
            : Container(
          color: const Color(0xFF001A31),
          padding: const EdgeInsets.all(24),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              setState(() => _tapped = true);
              if (!_allFilled) return;
              if (!_formKey.currentState!.validate()) return;

              final app = Application(
                vacancyId: widget.vacancyId,
                fullName: _fullName.text,
                email: _email.text,
                phone: '$_phoneCountryCode ${_phone.text}',
                secondPhone:
                '$_secondPhoneCountryCode ${_secondPhone.text}',
                coverLetter: '',
                dateOfBirth: _dob.text,
                gender: _gender!,
                citizenship: _country,
              );
              final ok = await ctrl.submit(app);
              if (!context.mounted) return;
              if (ok) Navigator.pop(context);
            },
            child: const Text('NEXT',
                style: TextStyle(
                    color: Color(0xFF001A31),
                    fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  /// Универсальный билд текстового поля
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    IconData? suffix,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Color(0xFF001A31))),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontStyle: FontStyle.italic),
            filled: true,
            fillColor: Colors.white,
            border: InputBorder.none,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
            suffixIcon: suffix != null
                ? Icon(suffix,
                color: suffix == Icons.check_circle
                    ? Colors.green
                    : Colors.black54)
                : (controller.text.isNotEmpty
                ? const Icon(Icons.check_circle, color: Colors.green)
                : null),
          ),
          validator: validator,
          onChanged: (_) => setState(() {}),
        ),
      ],
    );
  }

  /// Ряд для телефона с кодом страны + ввод номера
  Widget _buildPhoneRow(
      String code,
      ValueChanged<String?> onCodeChanged,
      TextEditingController controller,
      String placeholder,
      ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: code,
              items: <String>['+372', '+1', '+44', '+49']
                  .map((c) => DropdownMenuItem(
                value: c,
                child: Text(c,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black)),
              ))
                  .toList(),
              onChanged: onCodeChanged,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: const TextStyle(fontStyle: FontStyle.italic),
              filled: true,
              fillColor: Colors.white,
              border: InputBorder.none,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none),
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none),
              suffixIcon: controller.text.isNotEmpty
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : null,
            ),
            validator: (v) =>
            controller == _phone && (v == null || v.isEmpty)
                ? 'Required'
                : null,
            onChanged: (_) => setState(() {}),
          ),
        ),
      ],
    );
  }
}
