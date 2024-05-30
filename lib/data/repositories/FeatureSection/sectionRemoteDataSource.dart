// ignore_for_file: file_names

import 'package:news/utils/api.dart';
import 'package:news/utils/constant.dart';
import 'package:news/utils/strings.dart';

class SectionRemoteDataSource {
  Future<dynamic> getSections(
      {required String langId, String? latitude, String? longitude}) async {
    try {
      final body = {
        LANGUAGE_ID: langId,
        LIMIT: limitOfAPIData.toString(),
        OFFSET: "0"
      }; //pass limit and offset

      if (latitude != null && latitude != "null") body[LATITUDE] = latitude;
      if (longitude != null && longitude != "null") body[LONGITUDE] = longitude;

      final result = await Api.sendApiRequest(
          body: body, url: Api.getFeatureSectionApi, isGet: true);
      print('result: $result');
      return result;
    } catch (e) {
      throw ApiMessageAndCodeException(errorMessage: e.toString());
    }
  }
}
