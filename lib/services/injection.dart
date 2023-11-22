import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import './chatgpt_service.dart';

// 接入 chatgpt 服务
final chatgpt = ChatGPTService();

// 开发模式下启用 trace 级别的日志(debug)，生产模式下启用 info 级别的日志
final logger = Logger(level: kDebugMode ? Level.trace : Level.info);
