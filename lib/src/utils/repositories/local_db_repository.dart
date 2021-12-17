import 'dart:io';

import 'package:markaa/src/config/config.dart';
import 'package:sqflite/sqflite.dart';

class LocalDBRepository {
  Database? db;

  Future<void> init() async {
    String path = 'markaa_db.db';
    int version = Platform.isAndroid ? MarkaaVersion.androidVersion : MarkaaVersion.iOSVersion;
    db = await openDatabase(path, version: version, onCreate: (db, version) async {
      const String createTableQuery =
          '''CREATE TABLE address_table (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, firstname TEXT, lastname TEXT, email TEXT, country_name TEXT, country_id TEXT, region TEXT, region_id TEXT, city TEXT, street TEXT, postcode TEXT, company TEXT, telephone TEXT, DefaultBillingAddress INTEGER, DefaultShippingAddress INTEGER)''';
      await db.execute(createTableQuery);
    });
  }

  Future<List> getAddress() async {
    if (db == null) {
      await this.init();
    }
    const String getQuery = 'SELECT * FROM address_table';
    return await db!.rawQuery(getQuery);
  }

  Future<int> addAddress(Map<String, dynamic> data) async {
    if (db == null) {
      await this.init();
    }
    final String addQuery =
        '''INSERT INTO address_table(firstname, lastname, email, country_name, country_id, region, region_id, city, street, postcode, company, telephone, DefaultBillingAddress, DefaultShippingAddress) VALUES("${data['firstname']}", "${data['lastname']}", "${data['email']}", "${data['country_name']}", "${data['country_id']}", "${data['region']}", "${data['region_id']}", "${data['city']}", "${data['street']}", "${data['postcode']}", "${data['company']}", "${data['telephone']}", ${data['DefaultBillingAddress']}, ${data['DefaultShippingAddress']})''';
    return await db!.rawInsert(addQuery);
  }

  Future<bool> updateAddress(Map<String, dynamic> data) async {
    if (db == null) {
      await this.init();
    }
    final String updateQuery =
        'UPDATE address_table SET firstname = ?, lastname = ?, email = ?, country_name = ?, country_id = ?, region = ?, region_id = ?, city = ?, street = ?, postcode = ?, company = ?, telephone = ?, DefaultBillingAddress = ?, DefaultShippingAddress = ? WHERE id = ?';
    List<Object?> arguments = [
      data['firstname'],
      data['lastname'],
      data['email'],
      data['country_name'],
      data['country_id'],
      data['region'],
      data['region_id'],
      data['city'],
      data['street'],
      data['postcode'],
      data['company'],
      data['telephone'],
      data['isdefaultbilling'],
      data['isdefaultshipping'],
      data['id']
    ];
    int changes = await db!.rawUpdate(updateQuery, arguments);
    return changes > 0;
  }

  Future<bool> removeAddress(int id) async {
    if (db == null) {
      await this.init();
    }
    const String removeSql = 'DELETE FROM address_table WHERE id = ?';
    int count = await db!.rawDelete(removeSql, [id]);
    return count == 1;
  }
}
