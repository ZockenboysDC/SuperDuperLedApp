class IntSetting {
  var name;
  int current;
  int max;
  int min;
  int standart;
  String endpoint;

  IntSetting(
      {this.max,
      this.min,
      this.standart,
      this.name,
      this.endpoint,
      this.current});
}
