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
import 'PrivateNote.dart';
import 'Task.dart';

export 'PrivateNote.dart';
export 'Task.dart';

class ModelProvider implements ModelProviderInterface {
  @override
  String version = "e04aa1c367c834582081dd6f1a49e817";
  @override
  List<ModelSchema> modelSchemas = [PrivateNote.schema, Task.schema];
  static final ModelProvider _instance = ModelProvider();

  static ModelProvider get instance => _instance;
  
  ModelType getModelTypeByModelName(String modelName) {
    switch(modelName) {
    case "PrivateNote": {
    return PrivateNote.classType;
    }
    break;
    case "Task": {
    return Task.classType;
    }
    break;
    default: {
    throw Exception("Failed to find model in model provider for model name: " + modelName);
    }
    }
  }
}