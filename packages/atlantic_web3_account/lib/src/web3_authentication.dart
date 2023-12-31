import 'package:atlantic_web3/atlantic_web3.dart';
import 'package:atlantic_web3_account/src/user.dart';

class Web3Authentication implements IWeb3Authentication {
  // Principal
  late final BaseProvider _provider;
  late final FilterEngine _filters;

  Web3Authentication(BaseProvider provider) {
    // Principal
    this._provider = provider;
    this._filters = FilterEngine(_provider);
  }

  User? get currentUser {
    return null;
  }

  Future<User?> createUserWithEmailAndPassword({required String email, required String password}) async {
      return null;
  }

  Future<User?> signInWithEmailAndPassword({required String email, required String password}) async {
    return null;
  }

  Future<void> signOut() async {
    return null;
  }

  Stream<User?> authStateChanges() => Stream.empty();

  Future<String> signIn() async {
    return '';
  }

  Future<String> signUp() async {
    return '';
  }
}
