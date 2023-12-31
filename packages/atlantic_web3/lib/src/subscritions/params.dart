class FilterCreationParams {
  FilterCreationParams(this.method, this.params);

  final String method;
  final List<dynamic> params;
}

class PubSubCreationParams {
  PubSubCreationParams(this.params);

  final List<dynamic> params;
}
