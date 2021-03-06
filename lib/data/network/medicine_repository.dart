import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:rootanya/constants.dart';
import 'package:rootanya/data/model/medicine.dart';
import 'package:rootanya/util/string_utils.dart';

class MedicineRepository {
  Future<List<Medicine>> fetchAllMedicines(String token) async {
    final response = await http.get(
      '${Http.api}/medicine/index',
      headers: {
        HttpHeaders.acceptHeader: acceptApplicationJson,
        HttpHeaders.authorizationHeader: createBearer(token),
      },
    );

    final jsonResponse = json.decode(response.body);

    final medicines = Medicine.fromJsonArray(jsonResponse);
    return medicines;
  }

  Future<List<Medicine>> fetchMedicineByQuery(String query, String token) async {
    final response = await http.get(
      '${Http.api}/medicine/user?q=$query',
      headers: {
        HttpHeaders.acceptHeader: acceptApplicationJson,
        HttpHeaders.authorizationHeader: createBearer(token),
      },
    );

    final jsonResponse = json.decode(response.body);
    final medicines = Medicine.fromJsonArray(jsonResponse);

    return medicines;
  }

  Future<Null> addMedicine(Medicine medicine, String token) async {
    final response = await http.post(
      '${Http.api}/medicine/user',
      headers: {
        HttpHeaders.acceptHeader: acceptApplicationJson,
        HttpHeaders.authorizationHeader: createBearer(token),
      },
      body: {
        'barcode': medicine.barcode,
        'name': medicine.name,
        'ingredient': medicine.ingredient,
        'category': medicine.category,
        'type': medicine.type,
        'for': medicine.fors,
        'method': medicine.method,
        'notice': medicine.notice,
        'keeping': medicine.keeping,
        'forget': medicine.forget,
      },
    );
  }
}
