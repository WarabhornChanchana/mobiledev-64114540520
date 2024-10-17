import 'package:pocketbase/pocketbase.dart';

class AuthService {
  final pb = PocketBase('http://127.0.0.1:8090'); // ตรวจสอบ URL ของ PocketBase

  // ฟังก์ชันสมัครสมาชิก
  Future<void> signUp(String email, String password) async {
    try {
      await pb.collection('users').create(body: {
        'email': email,
        'password': password,
        'passwordConfirm': password,
        'role': 'member',  // บทบาทเริ่มต้นเป็น 'member'
      });
    } catch (e) {
      print('Error during sign-up: $e');
      throw e;
    }
  }

  // ฟังก์ชันล็อกอิน
  Future<void> signIn(String email, String password) async {
    try {
      await pb.collection('users').authWithPassword(email, password);
      print('Login successful, User role: ${pb.authStore.model.data['role']}');
    } catch (e) {
      print('Error during sign-in: $e');
      throw e;
    }
  }

  // ฟังก์ชันล็อกเอาท์
  Future<void> signOut() async {
    pb.authStore.clear();
    print('User signed out');
  }

  // ฟังก์ชันตรวจสอบบทบาทของผู้ใช้
  Future<String> getUserRole(String userId) async {
    try {
      final user = await pb.collection('users').getOne(userId);
      return user.data['role'] ?? 'member';  // คืนค่า 'member' ถ้าไม่มีบทบาท
    } catch (e) {
      print('Error fetching user role: $e');
      throw e;
    }
  }
}
