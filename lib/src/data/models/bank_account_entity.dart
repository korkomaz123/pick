class BankAccountEntity {
  final String title;
  final String bank;
  final String name;
  final String iBan;

  BankAccountEntity({
    this.title,
    this.bank,
    this.name,
    this.iBan,
  });

  BankAccountEntity.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        bank = json['bank'],
        name = json['name'],
        iBan = json['iBan'];

  Map<String, dynamic> toJson() => {
        'title': title,
        'bank': bank,
        'name': name,
        'iBan': iBan,
      };
}