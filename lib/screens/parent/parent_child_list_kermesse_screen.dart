import 'package:flutter/material.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/data/user_data.dart';
import 'package:kermesse_frontend/services/user_service.dart';
import 'package:kermesse_frontend/widgets/global_appBar.dart';
import 'package:kermesse_frontend/widgets/screen_list.dart';

class ParentChildListKermesseScreen extends StatefulWidget {
  final int kermesseId;

  const ParentChildListKermesseScreen({
    super.key,
    required this.kermesseId,
  });

  @override
  State<ParentChildListKermesseScreen> createState() => _ParentChildListKermesseScreenState();
}

class _ParentChildListKermesseScreenState extends State<ParentChildListKermesseScreen> {
  final Key _key = UniqueKey();

  final UserService _userService = UserService();

  Future<List<UserList>> _getAllChildren() async {
    ApiResponse<List<UserList>> response = await _userService.getAllChildren(kermesseId: widget.kermesseId);
    if (response.error != null) {
      throw Exception(response.error);
    }
    return response.data!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GlobalAppBar(title: 'List of children'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Children in Kermesse",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<UserList>>(
                key: _key,
                future: _getAllChildren(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        snapshot.error.toString(),
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  if (snapshot.hasData && snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('No children found.'),
                    );
                  }
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        UserList child = snapshot.data![index];
                        return Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: const Icon(Icons.child_care, size: 40, color: Colors.blue),
                            title: Text(
                              child.name,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text('Jeton: ${child.balance}'),
                          ),
                        );
                      },
                    );
                  }
                  return const Center(
                    child: Text('Something went wrong.'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
