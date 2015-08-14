# Using Elm is easier than ever

Getting started with Elm is now easier than ever with the `StartApp` package.

With [the Elm Architecture][arch], it has never been easier to write modular front-end code that is [shockingly fast][elm-html] and easy to test, refactor, and debug. The `StartApp` package drastically lowers the barrier to entry, setting everything up so you can focus entirely on writing your app.

[arch]: https://github.com/evancz/elm-architecture-tutorial/
[elm-html]: http://elm-lang.org/blog/Blazing-Fast-Html.elm


## Example

The following chunk of code sets up a simple counter that you can increment and decrement. Notice that you focus entirely on setting up `model`, `view`, and `update`. That is it, no distractions!

```elm
import Html exposing (div, button, text)
import Html.Events exposing (onClick)
import StartApp.Simple as StartApp


main =
  StartApp.start { model = model, view = view, update = update }


model = 0


view address model =
  div []
    [ button [ onClick address Decrement ] [ text "-" ]
    , div [] [ text (toString model) ]
    , button [ onClick address Increment ] [ text "+" ]
    ]


type Action = Increment | Decrement


update action model =
  case action of
    Increment -> model + 1
    Decrement -> model - 1
```

> Paste the code into [Elm's online editor][edit] to see it in action. From there, [install Elm on your machine](http://elm-lang.org/install) and start working through the [Elm Architecture tutorial][arch] which starts with this counter example and gradually works up to programs with HTTP and animation.

[edit]: http://elm-lang.org/try

Notice that the `update` and `view` functions are totally separate. This is great for architecture, but it also makes testing way easier. Your application logic is entirely isolated, so you can make sure it works correctly without worrying about the DOM.

So this is a super simple program, but the core concepts here can grow into great code bases if you follow [the Elm Architecture][arch].


## Further Learning

Check out the full documentation for this library [here](http://package.elm-lang.org/packages/evancz/start-app/latest/).

For more guidelines and examples of making apps in Elm, check out the following resources:

  * [Language Docs](http://elm-lang.org/docs) &mdash; tons of learning resources that go from syntax to language features to design guidelines.
  * [The Elm Architecture][arch] &mdash; simple examples demonstrating how our basic counter app can scale to huge applications that are easy to test, maintain, and refactor.
  * [elm-todomvc][] &mdash; a typical TodoMVC program ([live][]) built on the Elm Architecture. You will see the `model`, `update`, `view` pattern but for a more realistic application than a counter.
  * [dreamwriter][] &mdash; a writing app built in Elm that again uses the Elm Architecture. The creator has *never* had a runtime exception in his Elm code. Unlike JavaScript, Elm is designed for reliability that scales to any size.

[elm-todomvc]: https://github.com/evancz/elm-todomvc/blob/master/Todo.elm
[live]: http://evancz.github.io/elm-todomvc/
[dreamwriter]: https://github.com/rtfeldman/dreamwriter/
