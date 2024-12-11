import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../FbObjects/FbChat.dart';
import '../FbObjects/FbPerfil.dart';
import '../FbObjects/FbPost.dart';
import 'PlatformAdmin.dart';

class DataHolder {
  static final DataHolder _instance = DataHolder._internal();

  FbPerfil? miPerfil;
  FbChat? fbChatSelected;
  PlatformAdmin? platformAdmin;
  FbPost? fbPostSelected;
  List<FbPost> arPosts = [];

  DataHolder._internal();

  factory DataHolder() {
    return _instance;
  }

  void initPlatformAdmin(BuildContext context) {
    platformAdmin = PlatformAdmin(context: context);
  }

  Future<void> obtenerPerfilDeFirestore(String uid) async {
    try {
      // Accede al perfil del usuario en la colección 'Perfiles' usando su UID
      DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore.instance
          .collection('perfiles')
          .doc(uid)
          .get();

      if (doc.exists) {
        // Asigna el perfil a miPerfil
        DataHolder().miPerfil = FbPerfil.fromFirestore(doc, null);
      } else {
        print("Perfil no encontrado.");
      }
    } catch (e) {
      print("Error al obtener el perfil: $e");
    }
  }


  Future<List<FbChat>> descargarTodosChats() async {
    List<FbChat> arTemp = [];
    var db = FirebaseFirestore.instance;

    final ref = db.collection('Chats').withConverter(
      fromFirestore: FbChat.fromFirestore,
      toFirestore: (FbChat post, _) => post.toFirestore(),
    );
    final querySnap = await ref.get();

    for (QueryDocumentSnapshot<FbChat> doc in querySnap.docs) {
      arTemp.add(doc.data());
    }

    return arTemp;
  }

  String limpiarBase64(String base64String) {
    if (base64String.startsWith('data:image')) {
      final index = base64String.indexOf('base64,');
      if (index != -1) {
        return base64String.substring(index + 7);
      }
    }
    return base64String;
  }

}
