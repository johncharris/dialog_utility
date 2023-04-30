import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

CollectionReference conversationsRef = FirebaseFirestore.instance.collection('conversations');
CollectionReference charactersRef = FirebaseFirestore.instance.collection('characters');

const uuid = Uuid();
