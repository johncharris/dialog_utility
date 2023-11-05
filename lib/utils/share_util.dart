import 'package:dialog_utility/models/conversation.dart';

String getShareLink(Conversation conversation) => "https://dialog-manager-9f243.web.app/v?id=${conversation.id}";
