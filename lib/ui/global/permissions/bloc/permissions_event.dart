part of 'permissions_bloc.dart';

@immutable
abstract class PermissionEvent extends Equatable {
  final PermissionStatus contactPermission;
  final PermissionStatus phonePermission;

  const PermissionEvent(this.contactPermission, this.phonePermission);
}

class InitializePermission extends PermissionEvent {
  const InitializePermission(contactPermission, phonePermission) : super(contactPermission, phonePermission);

  @override
  List<Object?> get props => [contactPermission, phonePermission];
}

class PermissionChanged extends PermissionEvent {
  const PermissionChanged(contactPermission, phonePermission) : super(contactPermission, phonePermission);

  @override
  List<Object?> get props => [contactPermission, phonePermission];
}
