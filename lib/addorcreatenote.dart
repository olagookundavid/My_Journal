import 'package:flutter/material.dart';

import 'database.dart';

class AddOrUpdate extends StatelessWidget {
  const AddOrUpdate(
      {Key? key,
      required this.titleController,
      required this.descriptionController,
      required this.id})
      : super(key: key);
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final int? id;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(
          top: 15,
          left: 15,
          right: 15,
          // this will prevent the soft keyboard from covering the text fields
          bottom: MediaQuery.of(context).viewInsets.bottom + 120,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(hintText: 'Title'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(hintText: 'Description'),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                // Save new journal
                if (id == null) {
                  await SQLHelper.createItem(
                    titleController.text,
                    descriptionController.text,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Journal has been addded!'),
                    ),
                  );
                }

                if (id != null) {
                  await SQLHelper.updateItem(
                    id,
                    titleController.text,
                    descriptionController.text,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Journal Updated!'),
                    ),
                  );
                }

                // Close the bottom sheet
                Navigator.of(context).pop();
              },
              child: Text(id == null ? 'Create New' : 'Update'),
            )
          ],
        ));
  }
}
