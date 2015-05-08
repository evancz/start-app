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

An app has three key components:

  * `model` &mdash; a big chunk of data fully describing your application.

  * `view` &mdash; a way to show your model on screen. It takes in two
    arguments. One is the model, which contains *all* the information about our
    app. The other is an [`Address`][address] that helps us handle user input.
    Whenever there is a click or key press, we send a message to the address
    describing what happened and where.

  * `update` &mdash; a function to update your model. Whenever a UI event
    occurs, is routed through the `Address` to this update function. We take
    in the message and the current model, then we give back a new model!

[The Elm Architecture][arch] augments this basic pattern to give you all the
modularity you want. Since we have whole model in one place makes, it is also
really easy to support features like *save* and *undo* because everything in
Elm is immutable. This means features that would be a nightmare in typical JS
are pretty much free in Elm.

Testing this is also really pleasant. The `update` is entirely separate from
the `view` so we can just feed in a bunch of actions and see that the model
updates as we expect!

On top of *that*, everything is super fast thanks to [elm-html][].

Okay, so once you have your `App` you give it to `start` and it is running.
That's all there is to it.

[elm-html]: http://elm-lang.org/blog/Blazing-Fast-Html.elm
[address]: http://package.elm-lang.org/packages/elm-lang/core/2.0.1/Signal#Mailbox
[arch]: https://github.com/evancz/elm-architecture-tutorial/


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

For more examples and guidelines for making apps in Elm, check out [this
tutorial][arch]. It goes through some simple examples and shows how the code
for this basic counter app can scale to huge applications that are easy to
test, maintain, and refactor.
