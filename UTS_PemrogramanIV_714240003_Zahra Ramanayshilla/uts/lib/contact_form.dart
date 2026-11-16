import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';

import 'contact_model.dart';

class ContactForm extends StatefulWidget {
  final ContactModel? initialContact;
  final Function(ContactModel) onSave;

  const ContactForm({super.key, this.initialContact, required this.onSave});

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  DateTime? _selectedDate;
  Color _selectedColor = const Color(0xFF0891B2);

  String? _fileName;
  String? _filePath;
  dynamic _fileBytes;

  bool get isEditing => widget.initialContact != null;

  @override
  void initState() {
    super.initState();

    final contact = widget.initialContact;

    if (contact != null) {
      _nameController.text = contact.name;
      _phoneController.text = contact.phone;

      _selectedDate = contact.date;
      _dateController.text = DateFormat('dd-MM-yyyy').format(contact.date);

      _selectedColor = contact.color;
      _fileName = contact.fileName;
      _filePath = contact.filePath;
      _fileBytes = contact.fileBytes;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  // Memilih tanggal
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF0891B2)),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  // Memilih warna
  Future<void> _selectColor() async {
    Color temporaryColor = _selectedColor;

    final Color? result = await showDialog<Color>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pilih Warna Kontak'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: temporaryColor,
              onColorChanged: (color) {
                temporaryColor = color;
              },
              enableAlpha: false,
              displayThumbColor: true,
              labelTypes: const [],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, temporaryColor);
              },
              child: const Text('Pilih'),
            ),
          ],
        );
      },
    );

    if (result != null) {
      setState(() {
        _selectedColor = result;
      });
    }
  }

  // Memilih berkas
Future<void> _selectFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        withData: true,
      );

      // Jika pengguna membatalkan pemilihan file
      if (result == null || result.files.isEmpty) {
        return;
      }

      final file = result.files.single;

      setState(() {
        _fileName = file.name;

        // Tidak menggunakan file.path karena berjalan di Chrome
        _filePath = null;

        // Menggunakan bytes untuk membaca file
        _fileBytes = file.bytes;
      });

      if (_fileBytes == null) {
        _showMessage('File tidak dapat dibaca. Silakan pilih ulang.');
      }
    } catch (e) {
      _showMessage('Gagal memilih berkas: $e');
    }
  }

  // Validasi dan menyimpan kontak
  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      _showMessage('Periksa kembali data yang kamu masukkan.');
      return;
    }

    if (_selectedDate == null) {
      _showMessage('Tanggal harus dipilih.');
      return;
    }

    if (_fileName == null) {
      _showMessage('Silakan pilih berkas terlebih dahulu.');
      return;
    }

    final contact = ContactModel(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      date: _selectedDate!,
      color: _selectedColor,
      fileName: _fileName!,
      filePath: _filePath,
      fileBytes: _fileBytes,
    );

    widget.onSave(contact);

    _showMessage(
      isEditing
          ? 'Kontak berhasil diperbarui.'
          : 'Kontak berhasil ditambahkan.',
    );

    if (!isEditing) {
      _formKey.currentState!.reset();
      _nameController.clear();
      _phoneController.clear();
      _dateController.clear();

      setState(() {
        _selectedDate = null;
        _selectedColor = const Color(0xFF0891B2);
        _fileName = null;
        _filePath = null;
        _fileBytes = null;
      });
    }
  }

  InputDecoration _decoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: const Color(0xFF0891B2)),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF0891B2), width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEditing ? 'Edit Kontak' : 'Tambah Kontak',
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),

              const SizedBox(height: 20),

              // Nama
              TextFormField(
                controller: _nameController,
                decoration: _decoration('Nama Lengkap', Icons.person_outline),
                validator: (value) {
                  final name = value?.trim() ?? '';

                  if (name.isEmpty) {
                    return 'Nama wajib diisi.';
                  }

                  final pattern = RegExp(
                    r'^[A-Z][a-zA-Z]*(?: [A-Z][a-zA-Z]*)+$',
                  );

                  if (!pattern.hasMatch(name)) {
                    return 'Minimal dua kata dan setiap kata diawali huruf kapital.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Nomor telepon
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: _decoration(
                  'Nomor Telepon (62xxxxxxxx)',
                  Icons.phone_outlined,
                ),
          
                validator: (value) {
                  final phone = value?.trim() ?? '';

                  if (phone.isEmpty) {
                    return 'Nomor telepon wajib diisi.';
                  }

                  if (!RegExp(r'^62[0-9]{6,11}$').hasMatch(phone)) {
                    return 'Nomor harus diawali 62 dan terdiri dari 8-13 digit.';
                  }

                  return null;
                },

              ),

              const SizedBox(height: 16),

              // Tanggal
              TextFormField(
                controller: _dateController,
                readOnly: true,
                onTap: _selectDate,
                decoration:
                    _decoration(
                      'Tanggal',
                      Icons.calendar_month_outlined,
                    ).copyWith(
                      hintText: 'Pilih tanggal',
                      suffixIcon: const Icon(Icons.arrow_drop_down),
                    ),
              ),

              const SizedBox(height: 16),

              // Warna
              const Text(
                'Warna Kontak',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),

              const SizedBox(height: 10),

              InkWell(
                onTap: _selectColor,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(radius: 16, backgroundColor: _selectedColor),
                      const SizedBox(width: 12),
                      const Expanded(child: Text('Pilih warna kontak')),
                      const Icon(Icons.palette_outlined),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Berkas
              const Text(
                'Berkas',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),

              const SizedBox(height: 10),

              OutlinedButton.icon(
                onPressed: _selectFile,
                icon: const Icon(Icons.attach_file),
                label: const Text('Pilih Berkas'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF0891B2),
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              if (_fileName != null) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDFA),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.insert_drive_file,
                        color: Color(0xFF0891B2),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _fileName!,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _fileName = null;
                            _filePath = null;
                            _fileBytes = null;
                          });
                        },
                        icon: const Icon(Icons.close, color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Tombol submit
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _submitForm,
                  icon: Icon(isEditing ? Icons.save : Icons.add),
                  label: Text(
                    isEditing ? 'Simpan Perubahan' : 'Submit',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0891B2),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
