import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RegisterPage(),
    );
  }
}

class User {
  final String name;
  final String phone;
  final String email;
  final String country;
  final String story;

  User({
    required this.name,
    required this.phone,
    required this.email,
    required this.country,
    required this.story,
  });
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _storyController = TextEditingController();

  final List<String> _countries = ['Russia', 'Ukraine', 'Germany', 'France'];
  String? _selectedCountry;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _storyController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (!RegExp(r'^[A-Za-zА-Яа-я ]+$').hasMatch(value.trim())) {
      return 'Please enter a valid name';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (!RegExp(r'^\(\d{3}\)\d{3}-\d{4}$').hasMatch(value)) {
      return 'Phone number must be entered as (XXX)XXX-XXXX';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    // Email необязателен, но если введён, проверяем формат
    if (value != null && value.isNotEmpty) {
      if (!RegExp(r'^[\w\.\-]+@[\w\-]+\.[A-Za-z]{2,}$').hasMatch(value)) {
        return 'Please enter a valid email address';
      }
    }
    return null;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final user = User(
        name: _nameController.text.trim(),
        phone: _phoneController.text,
        email: _emailController.text.trim(),
        country: _selectedCountry ?? '',
        story: _storyController.text,
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UserInfoPage(user: user)),
      );
    }
  }

  Widget _clearButton(TextEditingController controller) {
    return IconButton(
      icon: const Icon(Icons.delete_outline, color: Colors.red),
      onPressed: () => controller.clear(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register Page'), centerTitle: true),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            // Full Name
            TextFormField(
              controller: _nameController,
              validator: _validateName,
              decoration: InputDecoration(
                labelText: 'Full Name *',
                prefixIcon: const Icon(Icons.person),
                suffixIcon: _clearButton(_nameController),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // Phone Number
            TextFormField(
              controller: _phoneController,
              validator: _validatePhone,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                LengthLimitingTextInputFormatter(13),
                FilteringTextInputFormatter.allow(RegExp(r'[()\d-]')),
              ],
              decoration: InputDecoration(
                labelText: 'Phone Number *',
                helperText: 'Phone format: (XXX)XXX-XXXX',
                prefixIcon: const Icon(Icons.call),
                suffixIcon: _clearButton(_phoneController),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // Email
            TextFormField(
              controller: _emailController,
              validator: _validateEmail,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email Address',
                icon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 16.0),

            // Country
            DropdownButtonFormField<String>(
              value: _selectedCountry,
              items: _countries
                  .map(
                    (country) => DropdownMenuItem<String>(
                      value: country,
                      child: Text(country),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _selectedCountry = value),
              validator: (value) =>
                  value == null ? 'Please select a country' : null,
              decoration: const InputDecoration(
                labelText: 'Country?',
                icon: Icon(Icons.map),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),

            // Life story
            TextFormField(
              controller: _storyController,
              maxLines: 3,
              inputFormatters: [LengthLimitingTextInputFormatter(100)],
              decoration: const InputDecoration(
                labelText: 'Life story',
                helperText: 'Keep it short, this is just a demo',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24.0),

            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 14.0),
              ),
              child: const Text(
                'Submit Form',
                style: TextStyle(fontSize: 18.0, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserInfoPage extends StatelessWidget {
  final User user;

  const UserInfoPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Info'), centerTitle: true),
      body: Card(
        margin: const EdgeInsets.all(16.0),
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(user.name),
              trailing: Text(user.country),
            ),
            ListTile(leading: const Icon(Icons.call), title: Text(user.phone)),
            if (user.email.isNotEmpty)
              ListTile(
                leading: const Icon(Icons.email),
                title: Text(user.email),
              ),
            if (user.story.isNotEmpty)
              ListTile(
                leading: const Icon(Icons.book),
                title: Text(user.story),
              ),
          ],
        ),
      ),
    );
  }
}
