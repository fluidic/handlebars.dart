// Copyright (c) 2016, Fluidic Inc. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

@JS()
library example.handlebars;

import 'dart:html';

import 'package:handlebars/handlebars.dart';
import 'package:js/js.dart';
import 'package:js_util/js_util.dart';

@JS()
@anonymous
class Person {
  external String get firstName;
  external String get lastName;

  external factory Person({String firstName, String lastName});
}

@JS()
@anonymous
class Post {
  external Person get author;
  external String get body;
  external List<Comment> get comments;

  external factory Post({Person author, String body, List<Comment> comments});
}

@JS()
@anonymous
class Comment {
  external Person get author;
  external String get body;

  external factory Comment({Person author, String body});
}

@JS()
@anonymous
class Items {
  external List<Item> get items;

  external factory Items({List<Item> items});
}

@JS()
@anonymous
class Item {
  external String get name;
  external String get emotion;

  external factory Item({String name, String emotion});
}

String list(items, Options options) {
  final className = getValue(options.hash, 'class');
  final buffer = new StringBuffer();
  buffer.writeln('<ul class="${className}">');

  for (final item in items) {
    buffer.writeln('<li>${options.fn(item)}</li>');
  }

  buffer.writeln('</ul>');
  return buffer.toString();
}

String myIf(context, conditional, Options options) {
  if (conditional) {
    return options.fn(context);
  } else {
    return options.inverse(context);
  }
}

void renderPeople() {
  final template = '''
{{#list people class="people"}}
  {{#my-if isActive}}
    {{firstName}} {{lastName}}
  {{else}}
    <strike>{{firstName}} {{lastName}}</strike>
  {{/my-if}}
{{/list}}
''';

  handlebars.registerHelper('list', allowInterop(list));
  handlebars.registerHelper('my-if', allowInteropCaptureThis(myIf));

  final context = toJS({
    'people': [
      {'firstName': 'Yehuda', 'lastName': 'Katz', 'isActive': false},
      {'firstName': 'Carl', 'lastName': 'Lerche', 'isActive': true},
      {'firstName': 'Alan', 'lastName': 'Johnson', 'isActive': true}
    ]
  });

  final text = handlebars.compile(template)(context);
  document.querySelector('#container_people').innerHtml = text;
}

void renderPost() {
  final template = '''
<div class="post">
  {{> userMessage tagName="h1" }}

  <h1>Comments</h1>

  {{#each comments}}
    {{> userMessage tagName="h2" }}
  {{/each}}
</div>
''';

  handlebars.registerPartial(
      'userMessage',
      '<{{tagName}}>By {{author.firstName}} {{author.lastName}}</{{tagName}}>' +
          '<div class="body">{{body}}</div>');

  final context = new Post(
      author: new Person(firstName: 'Alan', lastName: 'Johnson'),
      body: 'I Love Handlebars',
      comments: [
        new Comment(
            author: new Person(firstName: 'Yehuda', lastName: 'Katz'),
            body: 'Me too!')
      ]);
  final text = handlebars.compile(template)(context);
  document.querySelector('#container_post').innerHtml = text;
}

SafeString agreeButton(Item item, Options options) {
  final emotion = handlebars.escapeExpression(item.emotion);
  final name = handlebars.escapeExpression(item.name);

  return new SafeString('<button>I agree. I ${emotion} ${name}</button>');
}

void renderItems() {
  final template = '''
<ul>
  {{#each items}}
  <li>{{agree_button}}</li>
  {{/each}}
</ul>
''';

  handlebars.registerHelper(
      'agree_button', allowInteropCaptureThis(agreeButton));

  final context = new Items(items: [
    new Item(name: 'Handlebars', emotion: 'love'),
    new Item(name: 'Mustache', emotion: 'enjoy'),
    new Item(name: 'Ember', emotion: 'want to learn')
  ]);
  final text = handlebars.compile(template)(context);
  document.querySelector('#container_items').innerHtml = text;
}

void main() {
  renderPeople();
  renderPost();
  renderItems();
}
