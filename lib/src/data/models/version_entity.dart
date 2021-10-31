class VersionEntity {
  bool canUpdate;
  bool updateMandatory;
  String dialogTitle;
  String dialogContent;
  String storeLink;

  VersionEntity({
    required this.canUpdate,
    required this.updateMandatory,
    required this.dialogTitle,
    required this.dialogContent,
    required this.storeLink,
  });
}
