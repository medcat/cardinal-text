Cardinal.story.dialog do
  language: \en
  content:
    'stonebrook.southgate.inn.keeper.dialog':
      type: \dialog
      begin: \.welcome
      content:
        welcome: [
        * type: \text
          content: "Welcome to the Stonebrook Inn!"
        * type: \action
          content: "-move up"
        ]
