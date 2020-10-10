import 'package:cloud_firestore/cloud_firestore.dart' show DocumentSnapshot;

import 'package:cloud_firestore/cloud_firestore.dart';

/// A [Bump] contains data read from a bump document in the [FirebaseFirestore]
/// database for this project.
///
/// The data can be extracted with the getters properties.
class Bump {
  /// Creates a [Bump] instance with all the attributes.
  Bump({
    this.id,
    this.address,
    this.createdAt,
    this.coords,
    this.image,
    this.status,
    this.userId,
  });

  /// Creates a [Bump] instance without the [id] attribute.
  Bump.partial({
    this.address,
    this.createdAt,
    this.coords,
    this.image,
    this.status,
    this.userId,
  });

  /// Creates an empty [Bump] instance.
  Bump.empty();

  /// Creates a [Bump] instance of a document of the Firebase bump collection.
  factory Bump.fromDocument(DocumentSnapshot snapshot) {
    final Map<String, dynamic> data = snapshot.data();
    return Bump(
      id: snapshot.id,
      address: data['address'] as String,
      createdAt: data['createdAt'] as Timestamp,
      coords: data['coords'] as GeoPoint,
      image: data['image'] as String,
      status: data['status'] as int,
      userId: data['userId'] as String,
    );
  }

  /// Document [id] extracted from the [DocumentSnapshot.id] getter.
  String id;

  /// Address where the bump is localized.
  String address;

  /// Document created date.
  Timestamp createdAt;

  /// Bump geographical point.
  GeoPoint coords;

  /// Image in base64 of the bump.
  String image;

  /// Bump status, the valid values are:
  ///
  /// `0` - reported.
  /// `1` - in-repair.
  /// `2` - repaired.
  int status;

  /// Reference of the user that reports the bump.
  String userId;

  /// Specifies the [DocumentSnapshot] ID for this instance.
  set bumpId(String value) => id = value;

  /// Returns the [DocumentSnapshot.id] of the current instance.
  String get bumpId => id;

  /// Specifies the bump address for this instance.
  set bumpAddress(String value) => address = value;

  /// Returns the bump address.
  String get bumpAddress => address;

  /// Specifies the date when the bump report was created.
  set bumpCreatedAt(Timestamp value) => createdAt = value;

  /// Returns the date when the bump was reported.
  Timestamp get bumpCreatedAt => createdAt;

  /// Specifies the geographical point of the bump.
  set bumpCoords(GeoPoint value) => coords = value;

  /// Returns the bump geographical point.
  GeoPoint get bumpCoords => coords;

  /// Specifies the base64 image of the bump
  set bumpImage(String value) => image = value;

  /// Returns the base64 image of the bump.
  String get bumpImage => image;

  /// Specifies the bump current status, the valid values are:
  ///
  /// `0` - reported.
  /// `1` - in-repair.
  /// `2` - repaired.
  set bumpStatus(int value) => status = value;

  /// Returns the current status of the bump.
  int get bumpStatus => status;

  /// Specifies the [DocumentSnapshot] ID of the user that creates the current
  /// bump report.
  set bumpUserId(String value) => userId = value;

  /// Returns the references of the user that reports the bump.
  ///
  /// The value represents a [DocumentSnapshot] ID.
  String get bumpUserId => userId;

  /// Returns a [Map] instance that has the necessary information to serialize
  /// and create a new [Bump] document in our [FirebaseFirestore] database.
  ///
  /// The [Map] keys are instance of [String] and the values are instance of
  /// [dynamic].
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'address': address,
      'createdAt': createdAt,
      'coords': coords,
      'image': image,
      'status': status,
      'userId': userId,
    };
  }
}
