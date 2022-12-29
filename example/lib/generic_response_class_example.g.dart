// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generic_response_class_example.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseResponse<T> _$BaseResponseFromJson<T>(Map<String, dynamic> json) =>
    BaseResponse<T>(
      status: MapParser.readInt(json, 'status'),
      msg: MapParser.readString(json, 'msg'),
      data: BaseResponse._dataFromJson(json['data'] as Object),
    );

Article _$ArticleFromJson(Map<String, dynamic> json) => Article(
      id: MapParser.getInt(json, 'id', 0),
      title: MapParser.getString(json, 'title', ''),
      author: json['author'] == null
          ? null
          : User.fromJson(json['author'] as Map<String, dynamic>),
      comments: (json['comments'] as List<dynamic>?)
          ?.map((e) => Comment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: MapParser.readInt(json, 'id'),
      email: MapParser.readString(json, 'email'),
    );

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      id: MapParser.readInt(json, 'id'),
      content: MapParser.readString(json, 'content'),
    );
