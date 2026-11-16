import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'contact_model.dart';
import 'contact_store.dart';
import 'contact_form.dart';

class ContactPage extends StatefulWidget {
  final ContactStore store;

  const ContactPage({super.key, required this.store});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  int? _editingIndex;

  void _saveContact(ContactModel contact) {
    if (_editingIndex != null) {
      widget.store.updateContact(_editingIndex!, contact);

      setState(() {
        _editingIndex = null;
      });
    } else {
      widget.store.addContact(contact);
    }
  }

  void _editContact(int index) {
    setState(() {
      _editingIndex = index;
    });

    // Kembali ke posisi formulir
    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 300),
    );
  }

  Future<void> _deleteContact(int index) async {
    final contact = widget.store.contacts[index];

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Kontak'),
          content: Text(
            'Apakah kamu yakin ingin menghapus kontak ${contact.name}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      widget.store.deleteContact(index);

      if (_editingIndex == index) {
        setState(() {
          _editingIndex = null;
        });
      } else if (_editingIndex != null && _editingIndex! > index) {
        setState(() {
          _editingIndex = _editingIndex! - 1;
        });
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kontak berhasil dihapus.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  bool _isImage(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();

    return ['jpg', 'jpeg', 'png'].contains(extension);
  }

  Widget _buildFilePreview(ContactModel contact) {
    if (_isImage(contact.fileName) && contact.fileBytes != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.memory(
          contact.fileBytes!,
          width: 55,
          height: 55,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.broken_image, size: 40, color: Colors.grey);
          },
        ),
      );
    }

    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        color: const Color(0xFFE0F2FE),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.insert_drive_file,
        color: Colors.cyan.shade700,
        size: 30,
      ),
    );
  }

  Widget _buildContactCard(ContactModel contact, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      color: Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFilePreview(contact),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contact.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),

                      const SizedBox(height: 6),

                      Row(
                        children: [
                          const Icon(Icons.phone, size: 15, color: Colors.grey),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              contact.phone,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 5),

                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            DateFormat('dd-MM-yyyy').format(contact.date),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      _editContact(index);
                    } else if (value == 'delete') {
                      _deleteContact(index);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, color: Colors.blue),
                          SizedBox(width: 10),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 10),
                          Text('Hapus'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const Divider(height: 25),

            Row(
              children: [
                const Text(
                  'Warna kontak:',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),

                const SizedBox(width: 8),

                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: contact.color,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                ),

                const Spacer(),

                const Icon(Icons.attach_file, size: 16, color: Colors.grey),

                const SizedBox(width: 5),

                Expanded(
                  child: Text(
                    contact.fileName,
                    textAlign: TextAlign.end,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final contacts = widget.store.contacts;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        title: const Text(
          'Daftar Kontak',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: AnimatedBuilder(
        animation: widget.store,
        builder: (context, child) {
          final contacts = widget.store.contacts;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                const Text(
                  'Kelola Kontak',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  'Tambahkan dan kelola informasi kontak kamu.',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),

                const SizedBox(height: 20),

                // Statistik kontak
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0891B2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.contacts, color: Colors.white, size: 35),

                      const SizedBox(width: 15),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total Kontak',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),

                          Text(
                            '${contacts.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // Formulir
                ContactForm(
                  key: ValueKey(_editingIndex),
                  initialContact: _editingIndex != null
                      ? contacts[_editingIndex!]
                      : null,
                  onSave: _saveContact,
                ),

                const SizedBox(height: 28),

                // Judul daftar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Daftar Kontak',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),

                    Text(
                      '${contacts.length} Kontak',
                      style: const TextStyle(
                        color: Color(0xFF0891B2),
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                // ListView kontak
                if (contacts.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Column(
                      children: [
                        Icon(
                          Icons.contact_page_outlined,
                          size: 60,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Belum Ada Kontak',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Silakan tambahkan kontak melalui formulir di atas.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: contacts.length,
                    itemBuilder: (context, index) {
                      return _buildContactCard(contacts[index], index);
                    },
                  ),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
