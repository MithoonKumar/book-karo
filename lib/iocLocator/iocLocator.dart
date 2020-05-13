import 'package:book_karo/config/config.dart';
import 'package:book_karo/constants/constants.dart';
import 'package:book_karo/services/Event.dart';
import 'package:ioc/ioc.dart';

void iocLocator() {
  Ioc().bind('config', (ioc) => Config());
  Ioc().bind('constants', (ioc) => Constants());
  Ioc().bind('event', (ioc) => Event());
}