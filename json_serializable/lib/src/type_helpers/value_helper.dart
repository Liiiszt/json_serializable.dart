// Copyright (c) 2018, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/element/type.dart';
import 'package:source_helper/source_helper.dart';

import '../shared_checkers.dart';
import '../type_helper.dart';
import '../utils.dart';

/// Handles the types corresponding to [simpleJsonTypeChecker], namely
/// [String], [bool], [num], [int], [double].
class ValueHelper extends TypeHelper {
  const ValueHelper();

  @override
  String? serialize(
    DartType targetType,
    String expression,
    TypeHelperContext context,
  ) {
    if (targetType.isDartCoreObject ||
        targetType.isDynamic ||
        simpleJsonTypeChecker.isAssignableFromType(targetType)) {
      return expression;
    }

    return null;
  }

//int?/json['order']
  @override
  String? deserialize(
    DartType targetType,
    String expression,
    TypeHelperContext context,
    bool defaultProvided,
  ) {
    print('value_helper.dart: deserialize: targetType: $targetType, expression: $expression, context: $context, defaultProvided: $defaultProvided');
    //targetType: String?, expression: json['title'], context: Instance of 'TypeHelperCtx', defaultProvided: false
    if (targetType.isDartCoreObject && !targetType.isNullableType) {
      // print('value_helper.dart:----01');
      final question = defaultProvided ? '?' : '';
      return '$expression as Object$question';
    } else if (targetType.isDartCoreObject || targetType.isDynamic) {
      // print('value_helper.dart:----02');
      // just return it as-is. We'll hope it's safe.
      return expression;
    } else if (targetType.isDartCoreDouble) {                               //double
      final targetTypeNullable = defaultProvided || targetType.isNullableType;
      final question = targetTypeNullable ? '?' : '';
      return '($expression as num$question)$question.toDouble()';
    // } else if (targetType.isDartCoreInt) {                                  //int
        // if (json['order'] != null) {
        //   dynamic obj = json['order'];
        //   if (obj is int) {
        //     order = obj;
        //   } else if (obj is double) {
        //     order = obj.toInt();
        //   } else if (obj is String) {
        //     order = int.parse(obj);
        //   }
        // }
      // return '';

    } else if (simpleJsonTypeChecker.isAssignableFromType(targetType)) {    //num(int), bool, String
      final typeCode = typeToCode(targetType, forceNullable: defaultProvided);
      return '$expression as $typeCode';          //局限：List中有嵌套调用。整体技术方案非常复杂
    }

    return null;
  }
}
