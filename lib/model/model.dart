import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';
import 'package:http/http.dart' as http;
part 'model.g.dart';

// This is where we define our tables:
const SqfEntityTable tableTodo = SqfEntityTable(
    tableName: 'todos',
    primaryKeyName: 'id',
    useSoftDeleting: false,
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      SqfEntityField('title', DbType.text), //Title of todo item
      SqfEntityField('completed', DbType.bool,
          defaultValue: false) //if it was completed
    ]);
const seqIdentity = SqfEntitySequence(
  sequenceName: 'identity',
);
// This is where we define our database:
@SqfEntityBuilder(myDbModel)
const myDbModel = SqfEntityModel(
  modelName: 'MyAppDatabaseModel',
  databaseName: 'myapp-db.db',
  sequences: [seqIdentity],
  databaseTables: [
    tableTodo
  ], //if you will be adding new tables, do not forget to put them here
);
