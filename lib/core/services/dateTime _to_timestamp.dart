

import 'package:built_value/serializer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:built_value/serializer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DateTimeToTimestampSerializerPlugin implements SerializerPlugin {
  @override
  Object beforeSerialize(Object object, FullType specifiedType) {
    if (object is DateTime && specifiedType.root == DateTime) {
      return object.toUtc();
    }
    
    return object;
  }

  @override
  Object afterSerialize(Object object, FullType specifiedType) {
    if (object is int && specifiedType.root == DateTime) {
      return Timestamp.fromMicrosecondsSinceEpoch(object);
    }
    return object;
  }

  @override
  Object beforeDeserialiimport 'package:built_value/serializer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:built_value/serializer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DateTimeToTimestampSerializerPlugin implements SerializerPlugin {
  @override
  Object beforeSerialize(Object object, FullType specifiedType) {
    if (object is DateTime && specifiedType.root == DateTime) {
      return object.toUtc();
    }
    
    return object;
  }

  @override
  Object afterSerialize(Object object, FullType specifiedType) {
    if (object is int && specifiedType.root == DateTime) {
      return Timestamp.fromMicrosecondsSinceEpoch(object);
    }
    return object;
  }

  @override
  Object beforeDeserialize(Object object, FullType specifiedType) {
    if (object is Timestamp && specifiedType.root == DateTime)
      return object.toDate().microsecondsSinceEpoch ;
    
    return object;
  }

  int _getOffsetInMicroseconds() => DateTime.now().timeZoneOffset.inMicroseconds;

  @override
  Object afterDeserialize(Object object, FullType specifiedType) {
    if (object is DateTime && specifiedType.root == DateTime) {
      return object.toLocal();
    }
    return object;
  }
}ze(Object object, FullType specifiedType) {
    if (object is Timestamp && specifiedType.root == DateTime)
      return object.toDate().microsecondsSinceEpoch ;
    
    return object;
  }

  int _getOffsetInMicroseconds() => DateTime.now().timeZoneOffset.inMicroseconds;

  @override
  Object afterDeserialize(Object object, FullType specifiedType) {
    if (object is DateTime && specifiedType.root == DateTime) {
      return object.toLocal();
    }
    return object;
  }
}

// class DateTimeToTimestampSerializerPlugin implements SerializerPlugin {
//   @override
//   Object beforeSerialize(Object object, FullType specifiedType) {
//     return object;
//   }

//   @override
//   Object afterSerialize(Object object, FullType specifiedType) {
//     if (specifiedType.root == DateTime)
//       return Timestamp.fromMicrosecondsSinceEpoch(object);

//     return object;
//   }

//   @override
//   Object beforeDeserialize(Object object, FullType specifiedType) {
//     if (object is DateTime && specifiedType.root == DateTime)
//       return object.microsecondsSinceEpoch;

//     return object;
//   }

//   @override
//   Object afterDeserialize(Object object, FullType specifiedType) {
//     return object;
//   }
// }