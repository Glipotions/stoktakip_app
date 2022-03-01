import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<bool?> onBackPressed(BuildContext context, String detay) {
  return showDialog<bool>(
    context: context,
    builder: (c) => AlertDialog(
      title: const Text('Uyarı'),
      content: Text(detay),
      actions: [
        TextButton(
          child: const Text('Evet'),
          onPressed: () => Navigator.pop(c, true),
        ),
        TextButton(
          child: const Text('Hayır'),
          onPressed: () => Navigator.pop(c, false),
        ),
      ],
    ),
  );
}

Future onBackPressedCancelFatura(BuildContext context, String detay) async {
  return await onBackPressed(context,
      'Çıkış yaparsanız $detay iptal edilecektir!\nÇıkmak istediğinize emin misiniz?');
}

Future onBackPressedCancelApp(BuildContext context) async {
  return await onBackPressed(context,
      'Programdan Çıkış Yapmak Üzeresiniz!\nÇıkmak istediğinize emin misiniz?');
}

// onWillPop: () async {
//         bool? result =
//             await onBackPressedCancelFatura(context, "Fatura düzenlemesi");
//         result ??= false;
//         return result;
//       },
