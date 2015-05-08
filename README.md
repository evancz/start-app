# Start App

This package makes it super simple to create an HTML app and start it up.

It is designed to be used along with [the Elm Architecture][arch] which makes
modularity, testing, and reuse a breeze.

[arch]: https://github.com/evancz/elm-architecture-tutorial/

## Overview

The full API of this package is tiny, just a type alias and a function:


```elm
type alias App model action =
    { model : model
    , view : Address action -> model -> Html
    , update : action -> model -> model
    }

start : App model action -> Signal Html
```

An `App` has three key components:

  * `model` &mdash; a big chunk of data fully describing your application
  * `view` &mdash; a way to show your model on screen with [elm-html][]
  * `update` &mdash; a function to update your model

Okay, so once you have your `App` you give it to `start` and it is running.
That's all there is to it.

[elm-html]: http://elm-lang.org/blog/Blazing-Fast-Html.elm
[address]: http://package.elm-lang.org/packages/elm-lang/core/2.0.1/Signal#Mailbox


## Example

The following chunk of code sets up a simple counter that you can increment
and decrement. You can paste the code into [Elm's online editor][edit] to see
it in action.

[edit]: http://elm-lang.org/try

```elm
import Html exposing (div, button, text)
import Html.Events exposing (onClick)
import StartApp


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

You can read more about the `StartApp` API itself [here][docs].

[docs]: http://package.elm-lang.org/packages/evancz/start-app/latest/StartApp

For more examples and guidelines for making apps in Elm, check out [this
tutorial][arch]. It goes through some simple examples and shows how the code
for this basic counter app can scale to huge applications that are easy to
test, maintain, and refactor.
