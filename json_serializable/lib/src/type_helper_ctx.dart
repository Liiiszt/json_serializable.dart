// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:source_helper/source_helper.dart';

import 'default_container.dart';
import 'helper_core.dart';
import 'type_helper.dart';
import 'type_helpers/config_types.dart';
import 'type_helpers/convert_helper.dart';
import 'unsupported_type_error.dart';
import 'utils.dart';

TypeHelperCtx typeHelperContext(
  HelperCore helperCore,
  FieldElement fieldElement,
) =>
    TypeHelperCtx._(helperCore, fieldElement);

class TypeHelperCtx
    implements TypeHelperContextWithConfig, TypeHelperContextWithConvert {
  final HelperCore _helperCore;

  @override
  final FieldElement fieldElement;

  @override
  ClassElement get classElement => _helperCore.element;

  @override
  ClassConfig get config => _helperCore.config;

  @override
  ConvertData? get serializeConvertData => _pairFromContext.toJson;

  @override
  ConvertData? get deserializeConvertData => _pairFromContext.fromJson;

  late final _pairFromContext = _ConvertPair(fieldElement);

  TypeHelperCtx._(this._helperCore, this.fieldElement);

  @override
  void addMember(String memberContent) {
    _helperCore.addMember(memberContent);
  }

  @override
  Object? serialize(DartType targetType, String expression) => _run(
        targetType,
        expression,
        (TypeHelper th) => th.serialize(targetType, expression, this),
      );

  //String?/json['title']/null
  @override
  Object deserialize(
    DartType targetType,
    String expression, {
    String? defaultValue,
  }) {
    // print(_helperCore.allTypeHelpers);
    // final value = _run(
    //   targetType,
    //   expression,
    //   (TypeHelper th) => th.deserialize(
    //     targetType,
    //     expression,
    //     this,
    //     defaultValue != null,
    //   ),
    // );
    //value: json['title'] as String?
    final value = _newRun(targetType, expression);
    print('value: $value,nullable: ${targetType.isNullableType},defaultValue: $defaultValue');
    return DefaultContainer.deserialize(
      value,
      nullable: targetType.isNullableType,
      defaultValue: defaultValue,
    );
  }

  Object _run(
    DartType targetType,
    String expression,
    Object? Function(TypeHelper) invoke,
  ) =>
      //TypeHelper是父类，有大约15个子类，每个子类都有一个serialize和deserialize方法
      //ValueHelper是最常见的一个子类
      _helperCore.allTypeHelpers.map(invoke).firstWhere(
            (r) => r != null,
            orElse: () => throw UnsupportedTypeError(targetType, expression),
          ) as Object;

  Object _newRun(
    DartType targetType, //int?
    String expression, //json['count']

  ) {
    final jsonKeyName = expression.split('\'')[1].split('\'')[0]; //count
    final result = StringBuffer();
    if (targetType.isDartCoreInt) {
      result
        ..write('$targetType $jsonKeyName;')
        ..write('if($expression != null) {')
        ..write('final dynamic value = $expression;')
        ..write(
            '$jsonKeyName = value is int ? value : value is double ? value.toInt() : value is String ? int.parse(value) : null;}');
    } else if (targetType.isDartCoreBool) {
      result
        ..write('$targetType $jsonKeyName;')
        ..write('if($expression != null) {')
        ..write('final dynamic value = $expression;')
        ..write(
            '$jsonKeyName = value is bool ? value : value is String ? value.toLowerCase() == \'true\' || value.toLowerCase() == \'yes\' : null;}');
    } else if (targetType.isDartCoreString) {
      result
        ..write('$targetType $jsonKeyName;')
        ..write('if($expression != null) {')
        ..write('final dynamic value = $expression;')
        ..write(
            '$jsonKeyName = value is String ? value : value.toString();}')
        
            ;
            
    }

    return result;
  }
}

class _ConvertPair {
  static final _expando = Expando<_ConvertPair>();

  final ConvertData? fromJson, toJson;

  _ConvertPair._(this.fromJson, this.toJson);

  factory _ConvertPair(FieldElement element) {
    var pair = _expando[element];

    if (pair == null) {
      final obj = jsonKeyAnnotation(element);
      if (obj.isNull) {
        pair = _ConvertPair._(null, null);
      } else {
        final toJson = _convertData(obj.objectValue, element, false);
        final fromJson = _convertData(obj.objectValue, element, true);
        pair = _ConvertPair._(fromJson, toJson);
      }
      _expando[element] = pair;
    }
    return pair;
  }
}

ConvertData? _convertData(DartObject obj, FieldElement element, bool isFrom) {
  final paramName = isFrom ? 'fromJson' : 'toJson';
  final objectValue = obj.getField(paramName);

  if (objectValue == null || objectValue.isNull) {
    return null;
  }

  final executableElement = objectValue.toFunctionValue()!;

  if (executableElement.parameters.isEmpty ||
      executableElement.parameters.first.isNamed ||
      executableElement.parameters.where((pe) => !pe.isOptional).length > 1) {
    throwUnsupported(
        element,
        'The `$paramName` function `${executableElement.name}` must have one '
        'positional parameter.');
  }

  final returnType = executableElement.returnType;
  final argType = executableElement.parameters.first.type;
  if (isFrom) {
    final hasDefaultValue =
        !jsonKeyAnnotation(element).read('defaultValue').isNull;

    if (returnType is TypeParameterType) {
      // We keep things simple in this case. We rely on inferred type arguments
      // to the `fromJson` function.
      // TODO: consider adding error checking here if there is confusion.
    } else if (!returnType.isAssignableTo(element.type)) {
      if (returnType.promoteNonNullable().isAssignableTo(element.type) &&
          hasDefaultValue) {
        // noop
      } else {
        final returnTypeCode = typeToCode(returnType);
        final elementTypeCode = typeToCode(element.type);
        throwUnsupported(
            element,
            'The `$paramName` function `${executableElement.name}` return type '
            '`$returnTypeCode` is not compatible with field type '
            '`$elementTypeCode`.');
      }
    }
  } else {
    if (argType is TypeParameterType) {
      // We keep things simple in this case. We rely on inferred type arguments
      // to the `fromJson` function.
      // TODO: consider adding error checking here if there is confusion.
    } else if (!element.type.isAssignableTo(argType)) {
      final argTypeCode = typeToCode(argType);
      final elementTypeCode = typeToCode(element.type);
      throwUnsupported(
          element,
          'The `$paramName` function `${executableElement.name}` argument type '
          '`$argTypeCode` is not compatible with field type'
          ' `$elementTypeCode`.');
    }
  }

  return ConvertData(executableElement.qualifiedName, argType, returnType);
}
