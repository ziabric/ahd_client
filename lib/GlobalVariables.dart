import 'package:flutter/material.dart';

String g_login = '';
bool authAccept = false;

// List<String> commonUser = ['user', 'user1'];
List<String> managerUser = ['postgres'];

BoxShadow boxShadow = const BoxShadow(
                                // color: Colors.black,
                                offset: Offset(
                                  2.0,
                                  10.0,
                                ),
                                blurRadius: 40.0,
                                spreadRadius: 1.0,
                              );

Shadow shadow = const Shadow(
  offset: Offset(2.0, 10.0),
  blurRadius: 40,
);