// Copyright (c) 2016, Fluidic Inc. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

@JS()
library handlebars.base;

import 'package:js/js.dart';

@JS('Handlebars')
external Handlebars get handlebars;

@JS()
class Handlebars {
  external void registerHelper(String name, Function fn);
  external void unregisterHelper(String name);

  external void registerPartial(String name, str);
  external void unregisterPartial(String name);

  external get partials;
  external get helpers;
  external get decorators;

  external String escapeExpression(String str);

  external HandlebarsTemplateDelegate compile(input, [options]);
}

@JS('Handlebars.SafeString')
class SafeString {
  external factory SafeString(String str);
  external String toString();
}

@JS('Handlebars.Exception')
class HandlebarsException {
  external factory HandlebarsException(String str);
}

typedef String HandlebarsTemplateDelegate(context, [options]);

@JS('Handlebars.Options')
class Options {
  external String fn(item);
  external String inverse(item);
  external get hash;
}
