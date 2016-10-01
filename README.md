# handlebars

A wrapper for the Handlebars.js library.

## Usage

Include the native JavaScript `handlebars` library provided with this
package in `index.html`.

```html
<html>
  <head>
    <script src="packages/handlebars/dist/handlebars-v4.0.5.js"></script>
    <script async type="application/dart" src="your_app_name.dart"></script>
    <script async src="packages/browser/dart.js"></script>
  </head>
  <body>
  </body>
</html>
```

Initialize partials and helpers and compile your template with
`handlebars.compile`.

```dart
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
```

See the example directory for other examples.

