import 'package:flutter/foundation.dart';

/// Map数据解析
class MapParser {
  /// 获取Map中，String类型的值
  /// * [map]
  /// * [key]
  /// * [value] 是默认值
  static String getString(Map? map, String key, String value) {
    String? result = readString(map, key);
    if (result != null) {
      return result;
    }
    return value;
  }

  static String? readString(Map? map, String key) {
    try {
      if (map == null) {
        return null;
      }
      if (map.containsKey(key)) {
        dynamic obj = map[key];
        if (obj is String) {
          return obj;
        } else {
          return obj.toString();
        }
      }
    } catch (e, s) {
      if (kDebugMode) {
        debugPrint('MapParser:: Exception details:\n $e');
        // print('MapParser:: Exception details:\n $e');
        // print('MapParser:: Stack trace:\n $s');
      }
    }
    return null;
  }

  /// 获取Map中，bool类型的值
  /// * [map]
  /// * [key]
  /// * [value] 是默认值
  static bool getBool(Map? map, String key, bool value) {
    bool? result = readBool(map, key);
    if (result != null) {
      return result;
    }
    return value;
  }

  static bool? readBool(Map? map, String key) {
    try {
      if (map == null) {
        return null;
      }
      if (map.containsKey(key)) {
        dynamic obj = map[key];
        if (obj is bool) {
          return obj;
        } else if (obj is String) {
          if (obj == 'true' || obj == 'YES') {
            return true;
          } else if (obj == 'false' || obj == 'NO') {
            return false;
          }
        }
      }
    } catch (e, s) {
      if (kDebugMode) {
        print('MapParser:: Exception details:\n $e');
        print('MapParser:: Stack trace:\n $s');
      }
    }
    return null;
  }

  /// 获取Map中，int类型的值
  /// * [map]
  /// * [key]
  /// * [value] 是默认值
  static int getInt(Map? map, String key, int value) {
    int? result = readInt(map, key);
    if (result != null) {
      return result;
    }
    return value;
  }

  static int? readInt(Map? map, String key) {
    try {
      if (map == null) {
        return null;
      }
      if (map.containsKey(key)) {
        dynamic obj = map[key];
        if (obj is int) {
          return obj;
        } else if (obj is double) {
          return obj.toInt();
        } else if (obj is String) {
          return int.parse(obj);
        }
      }
    } catch (e, s) {
      if (kDebugMode) {
        print('MapParser:: Exception details:\n $e');
        print('MapParser:: Stack trace:\n $s');
      }
    }
    return null;
  }

  /// 获取Map中，double类型的值
  /// * [map]
  /// * [key]
  /// * [value] 是默认值
  static double getDouble(Map? map, String key, double value) {
    double? result = readDouble(map, key);
    if (result != null) {
      return result;
    }
    return value;
  }

  static double? readDouble(Map? map, String key) {
    try {
      if (map == null) {
        return null;
      }
      if (map.containsKey(key)) {
        dynamic obj = map[key];
        if (obj is double) {
          return obj;
        } else if (obj is int) {
          return obj.toDouble();
        } else if (obj is String) {
          return double.parse(obj);
        }
      }
    } catch (e, s) {
      if (kDebugMode) {
        print('MapParser:: Exception details:\n $e');
        print('MapParser:: Stack trace:\n $s');
      }
    }
    return null;
  }
}
