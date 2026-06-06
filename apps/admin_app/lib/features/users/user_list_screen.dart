import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<Map<String, dynamic>> _users = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    final data = await Supabase.instance.client
        .from('profiles')
        .select('*')
        .eq('role', 'user')
        .order('created_at', ascending: false);
    setState(() {
      _users = List<Map<String, dynamic>>.from(data);
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _users.isEmpty
              ? const Center(child: Text('No users yet'))
              : RefreshIndicator(
                  onRefresh: _fetchUsers,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _users.length,
                    itemBuilder: (context, index) {
                      final user = _users[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                            child: Icon(Icons.person, color: AppTheme.primaryColor),
                          ),
                          title: Text(user['full_name'] ?? 'No Name', style: const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (user['phone'] != null) Text(user['phone']),
                              Text(
                                'Joined: ${DateTime.parse(user['created_at']).day}/${DateTime.parse(user['created_at']).month}/${DateTime.parse(user['created_at']).year}',
                                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
