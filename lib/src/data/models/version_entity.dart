class VersionEntity {
  bool canUpdate;
  bool updateMandatory;
  String dialogTitle;
  String dialogContent;
  String storeLink;

  VersionEntity({
    this.canUpdate,
    this.updateMandatory,
    this.dialogTitle,
    this.dialogContent,
    this.storeLink,
  });
}
