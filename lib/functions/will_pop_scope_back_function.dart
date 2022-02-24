import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<bool?> onBackPressedCancelFatura(BuildContext context, String detay) {
  return showDialog<bool>(
    context: context,
    builder: (c) => AlertDialog(
      title: const Text('Uyarı'),
      content: Text(
          'Çıkış yaparsanız $detay iptal edilecektir.\nÇıkmak istediğinize emin misiniz?'),
      actions: [
        FlatButton(
          child: const Text('Evet'),
          onPressed: () => Navigator.pop(c, true),
        ),
        FlatButton(
          child: const Text('Hayır'),
          onPressed: () => Navigator.pop(c, false),
        ),
      ],
    ),
  );
}
