import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:orders/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({required String email, required String password});
  
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  AuthRemoteDataSourceImpl({required this.firebaseAuth});

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // التعديل بتاعك ممتاز: بنجيب الداتا من الـ Firestore
      final documentSnapshot = await firestore
          .collection('users')
          .doc(userCredential.user!.uid) // استخدام doc مباشرة أحسن من where
          .get();

      if (documentSnapshot.exists) {
        return UserModel.fromJson(documentSnapshot.data()!);
      } else {
        // لو الداتا مش في الفايرستور لسبب ما، نرجعها من الـ Auth
        return UserModel(
          id: userCredential.user!.uid,
          name: userCredential.user!.displayName ?? 'User',
          email: userCredential.user!.email ?? email,
        );
      }

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('هذا الحساب غير موجود.');
      } else if (e.code == 'wrong-password') {
        throw Exception('كلمة المرور غير صحيحة.');
      } else {
        throw Exception(e.message ?? 'حدث خطأ أثناء تسجيل الدخول.');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user!.updateDisplayName(name);

      await firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'id': userCredential.user!.uid,
      });

      return UserModel(id: userCredential.user!.uid, name: name, email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception('هذا البريد الإلكتروني مستخدم بالفعل.');
      } else {
        throw Exception(e.message ?? 'حدث خطأ أثناء التسجيل.');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
} 