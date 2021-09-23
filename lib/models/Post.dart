/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// ignore_for_file: public_member_api_docs

import 'package:amplify_datastore_plugin_interface/amplify_datastore_plugin_interface.dart';
import 'package:flutter/foundation.dart';


/** This is an auto generated class representing the Post type in your schema. */
@immutable
class Post extends Model {
  static const classType = const _PostModelType();
  final String id;
  final String? _content;
  final int? _genreId;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String get content {
    try {
      return _content!;
    } catch(e) {
      throw new DataStoreException(DataStoreExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage, recoverySuggestion: DataStoreExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion, underlyingException: e.toString());
    }
  }
  
  int get genreId {
    try {
      return _genreId!;
    } catch(e) {
      throw new DataStoreException(DataStoreExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage, recoverySuggestion: DataStoreExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion, underlyingException: e.toString());
    }
  }
  
  const Post._internal({required this.id, required content, required genreId}): _content = content, _genreId = genreId;
  
  factory Post({String? id, required String content, required int genreId}) {
    return Post._internal(
      id: id == null ? UUID.getUUID() : id,
      content: content,
      genreId: genreId);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Post &&
      id == other.id &&
      _content == other._content &&
      _genreId == other._genreId;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Post {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("content=" + "$_content" + ", ");
    buffer.write("genreId=" + (_genreId != null ? _genreId!.toString() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Post copyWith({String? id, String? content, int? genreId}) {
    return Post(
      id: id ?? this.id,
      content: content ?? this.content,
      genreId: genreId ?? this.genreId);
  }
  
  Post.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _content = json['content'],
      _genreId = json['genreId'];
  
  Map<String, dynamic> toJson() => {
    'id': id, 'content': _content, 'genreId': _genreId
  };

  static final QueryField ID = QueryField(fieldName: "post.id");
  static final QueryField CONTENT = QueryField(fieldName: "content");
  static final QueryField GENREID = QueryField(fieldName: "genreId");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Post";
    modelSchemaDefinition.pluralName = "Posts";
    
    modelSchemaDefinition.addField(ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Post.CONTENT,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Post.GENREID,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
  });
}

class _PostModelType extends ModelType<Post> {
  const _PostModelType();
  
  @override
  Post fromJson(Map<String, dynamic> jsonData) {
    return Post.fromJson(jsonData);
  }
}