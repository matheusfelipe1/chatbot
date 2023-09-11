class ButtonsModel {
  String? id;
  String? label;
  String? action;
  int? type;
  // 0 - send label button at chat
  // 1 - execute a action to do launch
  // 2 - pass params for the app.

  ButtonsModel({
    this.id,
    this.label,
    this.action,
    this.type
  });
}