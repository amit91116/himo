import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';

part 'permissions_event.dart';

part 'permissions_state.dart';

class PermissionBloc extends Bloc<PermissionEvent, PermissionState> {
  PermissionBloc() : super(const PermissionInitial(PermissionStatus.denied, PermissionStatus.denied)) {
    on<InitializePermission>((event, emit) async {
      PermissionStatus contactStatus = await Permission.contacts.status;
      PermissionStatus phoneStatus = await Permission.phone.status;
      if (contactStatus == PermissionStatus.granted && phoneStatus == PermissionStatus.granted) {
        emit.call(PermissionsApproved(contactStatus, phoneStatus));
      } else {
        emit.call(PermissionInitial(contactStatus, phoneStatus));
      }
    });

    on<PermissionChanged>((event, emit) async {
      PermissionStatus contactPermission = event.contactPermission;
      PermissionStatus phonePermission = event.phonePermission;
      if (contactPermission == PermissionStatus.granted && phonePermission == PermissionStatus.granted) {
        emit.call(PermissionsApproved(contactPermission, phonePermission));
      } else {
        emit.call(PermissionFailed(contactPermission, phonePermission));
      }
    });
  }
}
