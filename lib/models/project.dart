import 'package:meta/meta.dart';

/*
var projectPositions: List<Position>?
 */
class Project {
  String? _id, name, projectId, description, organizationId, created;
  String? organizationName;

  double? monitorMaxDistanceInMetres;
  Project(
      {required this.name,
      required this.description,
      this.organizationId,
      this.organizationName,
      this.monitorMaxDistanceInMetres,
      required this.projectId});

  Project.fromJson(Map data) {
    this.name = data['name'];

    this.projectId = data['projectId'];
    this.description = data['description'];
    this.organizationId = data['organizationId'];
    this.created = data['created'];
    this.organizationName = data['organizationName'];
    this.monitorMaxDistanceInMetres = data['monitorMaxDistanceInMetres'];
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'name': name,
      'projectId': projectId,
      'description': description,
      'organizationId': organizationId,
      'monitorMaxDistanceInMetres': monitorMaxDistanceInMetres,
      'organizationName': organizationName,
      'created': created,
    };
    return map;
  }
}
