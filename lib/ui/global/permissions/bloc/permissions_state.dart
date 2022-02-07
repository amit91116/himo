part of 'permissions_bloc.dart';

@immutable
class PermissionState extends Equatable {
  final PermissionStatus contactPermission;
  final PermissionStatus phonePermission;

  const PermissionState(this.contactPermission, this.phonePermission);

  @override
  List<Object?> get props => [contactPermission, phonePermission];
}

class PermissionInitial extends PermissionState {
  const PermissionInitial(contactPermission, phonePermission) : super(contactPermission, phonePermission);

  @override
  List<Object?> get props => [contactPermission, phonePermission];
}

class PermissionsApproved extends PermissionState {
  const PermissionsApproved(contactPermission, phonePermission) : super(contactPermission, phonePermission);

  @override
  List<Object?> get props => [contactPermission, phonePermission];
}

class PermissionFailed extends PermissionState {
  const PermissionFailed(contactPermission, phonePermission) : super(contactPermission, phonePermission);

  @override
  List<Object?> get props => [contactPermission, phonePermission];
}
