abstract class IWeb3Abi {
  Future<List<dynamic>> getCompilers();

  Future<String> compilerSolidity(String source);

  Future<String> compilerLLL(String source);

  Future<String> compilerSerpent(String source);
}
