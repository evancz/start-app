# Using Elm is easier than ever

Getting started with Elm is now easier than ever with the `StartApp` package.

With [the Elm Architecture][arch], it has never been easier to write modular
front-end code that is [shockingly fast][elm-html] and easy to test, refactor,
and debug. The `StartApp` package drastically lowers the barrier to entry,
setting everything up so you can focus entirely on writing your app. 

[arch]: https://github.com/evancz/elm-architecture-tutorial/
[elm-html]: http://elm-lang.org/blog/Blazing-Fast-Html.elm

Try it [online][edit] or install [Elm Platform](https://www.npmjs.com/package/elm)
and run these commands to get all the relevant packages locally:

```
elm-package install evancz/start-app
elm-package install evancz/elm-html
```

## Example

The following chunk of code sets up a simple counter that you can increment
and decrement. Notice that you focus entirely on setting up `model`, `view`,
and `update`. That is it, no distractions!

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

<span style="color:grey;">
Paste the code into [Elm's online editor][edit] to see it in action.
</span>

Notice that the `update` and `view` functions are totally separate. This is
great for architecture, but it also makes testing way easier. Your application
logic is entirely isolated, so you can make sure it works correctly without
worrying about the DOM.

[edit]: http://elm-lang.org/try

So this is a super simple program, but the core concepts here can grow into
great code bases if you follow [the Elm Architecture][arch].

## How it works

Every Elm `App` has three key components:

  * `model` &mdash; a big chunk of data fully describing your application
  * `view` &mdash; a way to show your model on screen with [elm-html][]
  * `update` &mdash; a function to update your model

This is the essence of every Elm program. Because of how Elm is designed, you
get a clean separation between `model`, `view`, and `update` every single time.
Even when you are hacking something together at 4am in the morning.

But why? Everything in Elm is built on immutable data structures that
provide an amazing amount of reliability in a large code base while
[maintaining speed](http://elm-lang.org/blog/announce/0.12.1). Immutability
means that **it is literally impossible to mix your `model` and `view`**.
It simply is not possible to mutate state in event handlers, so a growing
code-base does not rot and degrade as logic is spread to weirder and weirder
places. The practical benefits of this are shocking.

The point is, this package takes this architecture pattern that arises
naturally in every Elm program, makes it explicit, and makes it super simple to
use. The `StartApp` API only has two things in it. First, the definition of an
`App`.

```elm
type alias App model action =
    { model : model
    , view : Address action -> model -> Html
    , update : action -> model -> model
    }
```

An `App` is defined as a `model`, a way to `update` that model, and a way to
`view` that model. Your job is to define an `App` and then `start` it up!

```elm
start : App model action -> Signal Html
```

You can read more about the `StartApp` API [here][docs].

[docs]: http://package.elm-lang.org/packages/evancz/start-app/latest/StartApp

For more guidelines and examples of making apps in Elm, check out the following
resources:

  * [The Elm Architecture][arch] &mdash; simple examples demonstrating how our
    basic counter app can scale to huge applications that are easy to test,
    maintain, and refactor.
  * [elm-todomvc][] &mdash; a typical TodoMVC program ([live][]) built on the
    Elm Architecture. You will see the `model`, `update`, `view` pattern but
    for a more realistic application than a counter.
  * [dreamwriter][] &mdash; a writing app built in Elm that again uses the Elm
    Architecture. The creator has *never* had a runtime exception in his Elm
    code. Unlike JavaScript, Elm is designed for reliability that scales to
    any size.

[elm-todomvc]: https://github.com/evancz/elm-todomvc/blob/master/Todo.elm
[live]: http://evancz.github.io/elm-todomvc/
[dreamwriter]: https://github.com/rtfeldman/dreamwriter/

It is now easier than ever to write great front-end code. Do it!
