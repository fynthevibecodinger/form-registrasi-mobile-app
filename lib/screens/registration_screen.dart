import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});
  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _notelpController = TextEditingController();
  final _birthController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _selectedGender;
  bool _agreedToTerms = false;
  String? _termsError;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  int _passwordStrength = 0; // 0: Kosong/Lemah, 1: Lemah, 2: Sedang, 3: Kuat
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _notelpController.dispose();
    _birthController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Validasi nama
  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama tidak boleh kosong';
    }
    if (value.trim().length < 3) {
      return 'Nama minimal 3 karakter';
    }
    return null;
  }

  // Validasi email
  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email tidak boleh kosong';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Format email tidak valid';
    }
    return null;
  }

  // validasi no telp
  String? _validateNotelp(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nomor telepon wajib diisi';
    }

    String cleanValue = value.trim();

    final numericRegExp = RegExp(r'^[0-9]+$');
    if (!numericRegExp.hasMatch(cleanValue)) {
      return 'Nomor telepon hanya boleh berisi angka';
    }

    if (cleanValue.length < 10 || cleanValue.length > 13) {
      return 'Nomor telepon harus antara 10 hingga 13 digit';
    }

    return null;
  }

  // Validasi password
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (value.length < 8) {
      return 'Password minimal 8 karakter';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password harus mengandung huruf kapital';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password harus mengandung angka';
    }
    return null;
  }

  // Validasi konfirmasi password
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }
    if (value != _passwordController.text) {
      return 'Password tidak cocok';
    }
    return null;
  }

  // Handler submit form
  void _submitForm() {
    setState(() {
      if (!_agreedToTerms) {
        _termsError = 'Anda harus menyetujui syarat & ketentuan';
      } else {
        _termsError = null;
      }
    });

    if (_formKey.currentState!.validate() && _agreedToTerms) {
      setState(() {
        _isLoading = true;
      });
      // Simulasi proses registrasi
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });
        // Tampilkan dialog sukses
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Registrasi Berhasil'),
            content: Text(
              'Selamat, ${_nameController.text}!\n'
              'Email: ${_emailController.text}',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _resetForm();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      });
    }
  }

  // Reset form
  void _resetForm() {
    _formKey.currentState!.reset();
    _nameController.clear();
    _emailController.clear();
    _notelpController.clear();
    _birthController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    setState(() {
      _selectedGender = null;
      _agreedToTerms = false;
      _termsError = null;
      _passwordStrength = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Registrasi'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                const SizedBox(height: 16),
                const Icon(
                  Icons.person_add,
                  size: 80,
                  color: Colors.deepPurple,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Buat Akun Baru',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Isi form di bawah ini untuk mendaftar',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                // Field Nama
                CustomTextField(
                  controller: _nameController,
                  label: 'Nama Lengkap',
                  hint: 'Masukkan nama lengkap Anda',
                  prefixIcon: Icons.person,
                  validator: _validateName,
                ),
                // Field Email
                CustomTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'Masukkan email Anda',
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                ),
                // Field No telp
                CustomTextField(
                  controller: _notelpController,
                  label: 'No Telp',
                  hint: 'Masukkan no telp Anda',
                  prefixIcon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: _validateNotelp,
                ),
                 // Field Jenis Kelamin (Dropdown)
                 Padding(
                   padding: const EdgeInsets.symmetric(vertical: 8.0),
                   child: DropdownButtonFormField<String>(
                     value: _selectedGender,
                     decoration: InputDecoration(
                       labelText: 'Jenis Kelamin',
                       hintText: 'Pilih jenis kelamin',
                       prefixIcon: const Icon(Icons.wc),
                       border: const OutlineInputBorder(),
                       filled: true,
                       fillColor: Colors.grey[50],
                     ),
                     items: const [
                       DropdownMenuItem(
                         value: 'Laki-laki',
                         child: Text('Laki-laki'),
                       ),
                       DropdownMenuItem(
                         value: 'Perempuan',
                         child: Text('Perempuan'),
                       ),
                     ],
                     onChanged: (value) {
                       setState(() {
                         _selectedGender = value;
                       });
                     },
                     validator: (value) {
                       if (value == null || value.isEmpty) {
                         return 'Jenis kelamin wajib dipilih';
                       }
                       return null;
                     },
                   ),
                 ),
                 CustomTextField(
                   controller: _birthController,
                   label: 'Tanggal Lahir',
                   hint: 'Pilih tanggal lahir',
                   prefixIcon: Icons.calendar_today,
                   readOnly: true,
                   onTap: () async {
                     DateTime? pickedDate = await showDatePicker(
                       context: context,
                       initialDate: DateTime.now(),
                       firstDate: DateTime(1900),
                       lastDate: DateTime.now(),
                     );
                     if (pickedDate != null) {
                       // Masukkan tanggal yang dipilih ke controller
                       _birthController.text =
                           "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                     }
                   },
                   validator: (value) {
                     if (value == null || value.trim().isEmpty) {
                       return 'Tanggal lahir wajib diisi';
                     }
                     return null;
                   },
                 ),
                 // Field Password
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _passwordController,
                        onChanged: (value) {
                          setState(() {
                            if (value.isEmpty) {
                              _passwordStrength = 0;
                            } else if (value.length < 8) {
                              _passwordStrength = 1; // Lemah
                            } else {
                              bool hasUpper = value.contains(RegExp(r'[A-Z]'));
                              bool hasLower = value.contains(RegExp(r'[a-z]'));
                              bool hasDigit = value.contains(RegExp(r'[0-9]'));
                              bool hasSymbol = value.contains(RegExp(r'[!@#\$&*~_.,icata]'));

                              if (hasUpper && hasLower && hasDigit && hasSymbol) {
                                _passwordStrength = 3; // Kuat
                              } else if ((hasUpper || hasLower) && hasDigit) {
                                _passwordStrength = 2; // Sedang
                              } else {
                                _passwordStrength = 1; // Lemah
                              }
                            }
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Minimal 8 karakter, huruf kapital, angka',
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          border: const OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        obscureText: _obscurePassword,
                        validator: _validatePassword,
                      ),
                      const SizedBox(height: 8),
                      if (_passwordController.text.isNotEmpty) ...[
                        LinearProgressIndicator(
                          value: _passwordStrength == 1
                              ? 0.33
                              : _passwordStrength == 2
                                  ? 0.66
                                  : _passwordStrength == 3
                                      ? 1.0
                                      : 0.0,
                          backgroundColor: Colors.grey[300],
                          color: _passwordStrength == 1
                              ? Colors.red
                              : _passwordStrength == 2
                                  ? Colors.orange
                                  : Colors.green,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _passwordStrength == 1
                              ? 'Kekuatan Password: Lemah'
                              : _passwordStrength == 2
                                  ? 'Kekuatan Password: Sedang'
                                  : _passwordStrength == 3
                                      ? 'Kekuatan Password: Kuat'
                                      : '',
                          style: TextStyle(
                            fontSize: 12,
                            color: _passwordStrength == 1
                                ? Colors.red
                                : _passwordStrength == 2
                                    ? Colors.orange
                                    : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                 // Field Konfirmasi Password
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Konfirmasi Password',
                      hintText: 'Ulangi password Anda',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    obscureText: _obscureConfirmPassword,
                    validator: _validateConfirmPassword,
                  ),
                ),
                // Checkbox Syarat & Ketentuan
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CheckboxListTile(
                        title: const Text('Setuju dengan Syarat & Ketentuan'),
                        value: _agreedToTerms,
                        onChanged: (value) {
                          setState(() {
                            _agreedToTerms = value ?? false;
                            if (_agreedToTerms) _termsError = null;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),
                      if (_termsError != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Text(
                            _termsError!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Tombol Submit
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Daftar', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 12),
                // Tombol Reset
                OutlinedButton(
                  onPressed: _isLoading ? null : _resetForm,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Reset'),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
