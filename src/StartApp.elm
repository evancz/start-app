module StartApp where
{-| This module makes it super simple to get started making a typical web-app.
It is designed to work perfectly with [the Elm Architecture][arch] which
describes a simple architecture pattern that makes testing and refactoring
shockingly pleasant. Definititely read [the tutorial][arch] to get started!

[arch]: https://github.com/evancz/elm-architecture-tutorial/

# Define your App
@docs App

# Run your App
@docs start

-}

import Html exposing (..)
import Signal exposing (Address)
import Task as T


{-| An app has three key components:

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
modularity you want. But since we have whole model in one place, it is
also really easy to support features like *save* and *undo* that can be quite
hard in other languages.

[address]: http://package.elm-lang.org/packages/elm-lang/core/2.0.1/Signal#Mailbox
[arch]: https://github.com/evancz/elm-architecture-tutorial/
-}
type alias App model action error =
    { initialState : model
    , view : Address action -> model -> Html
    , update : action -> model -> (model, Maybe (T.Task error action))
    , noOp : action
    }


{-| This actually starts up your `App`. The following code sets up a counter
that can be incremented and decremented. You can read more about writing
programs like this [here](https://github.com/evancz/elm-architecture-tutorial/).

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

Notice that the program cleanly breaks up into model, update, and view.
This means it is super easy to test your update logic independent of any
rendering.
-}
start : App model action error
     -> Signal action
     -> (Signal Html, Signal (T.Task error ()))
start app externalActions =
  let
    --actionsMailbox : Signal.Mailbox action
    actionsMailbox =
      Signal.mailbox app.noOp

    --sendToMailbox : action -> T.Task error ()
    sendToMailbox action =
      Signal.send actionsMailbox.address action

    --allActions : Signal action
    allActions =
      Signal.merge actionsMailbox.signal externalActions

    --stateAndTask : Signal (model, Maybe (T.Task error action))
    stateAndTask =
      Signal.foldp
        (\action (state, _) -> app.update action state)
        (app.initialState, Nothing)
        allActions

    --html : Signal Html
    html =
      stateAndTask
        |> Signal.map fst
        |> Signal.map (app.view actionsMailbox.address)

    --tasks : Signal (T.Task error ())
    tasks =
      stateAndTask
        |> Signal.filterMap snd (T.succeed app.noOp)
        |> Signal.map (\task -> task `T.andThen` sendToMailbox)
  in
    (html, tasks)
