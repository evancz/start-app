module StartApp where
{-| This module makes it super simple to get started making a typical web-app.
It is designed to work perfectly with [the Elm Architecture][arch] which
describes a simple architecture pattern that makes testing and refactoring
shockingly pleasant. Definititely read [the tutorial][arch] to get started!

[arch]: https://github.com/evancz/elm-architecture-tutorial/

# Define your App
@docs App, LoopbackFun

# Run your App
@docs start

-}

import Html exposing (..)
import Signal exposing (Address)
import Task as T
import Time


{-| An app has three key components:

  * `initialState` &mdash; a big chunk of data fully describing the state of
     your application when it first starts.

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
type alias App model error action =
    { initialState : model
    , view : Address action -> model -> Html
    , update : LoopbackFun error action
            -> Time.Time
            -> action
            -> model
            -> (model, Maybe (T.Task error ()))
    }

{-| Use this in your update function to push the result of a task
into your action channel. (TODO: more docs) -}
type alias LoopbackFun error action =
  T.Task error action -> T.Task error ()

{-| This actually starts up your `App`. The following code sets up a counter
that can be incremented and decremented. You can read more about writing
programs like this [here](https://github.com/evancz/elm-architecture-tutorial/).

    import Html exposing (div, button, text)
    import Html.Events exposing (onClick)
    import Task as T
    import StartApp

    main =
      fst viewAndTasks
    
    port tasks : Signal (T.Task String ())
    port tasks =
      snd viewAndTasks

    externalActions =
      Signal.constant NoOp

    viewAndTasks =
      StartApp.start
        { initialState = initialState, view = view, update = update }
        externalActions

    initialState = 0

    view address model =
      div []
        [ button [ onClick address Decrement ] [ text "-" ]
        , div [] [ text (toString model) ]
        , button [ onClick address Increment ] [ text "+" ]
        ]

    type Action = Increment | Decrement | NoOp

    update loopback now action model =
      case action of
        Increment ->
          (model + 1, Nothing)
        Decrement ->
          (model - 1, Nothing)

Notice that the program cleanly breaks up into model, update, and view.
This means it is super easy to test your update logic independent of any
rendering.

TODO: this example is somewhat ridiculous because it doesn't need to use
tasks, external events, or time. Will come up with an example that actually
uses them!
-}
start : App model error action
     -> Signal action
     -> (Signal Html, Signal (T.Task error ()))
start app externalActions =
  let
    {- Annotations which use type vars commented out because if you uncomment
    them, you get type errors like this:
    https://gist.github.com/vilterp/a74cf622ee08c43e76ce -}
    --loopbackFun : LoopbackFun error action
    loopbackFun actionTask =
      actionTask
        `T.andThen` (Signal.send justWrapper)

    --actionsMailbox : Signal.Mailbox (Maybe action)
    actionsMailbox =
      Signal.mailbox Nothing

    justWrapper =
      Signal.forwardTo actionsMailbox.address Just

    --allActions : Signal (Time.Time, Maybe action)
    allActions =
      Signal.merge
        actionsMailbox.signal
        (Signal.map Just externalActions)
        |> Time.timestamp

    --stateAndTask : Signal (model, Maybe (T.Task error ()))
    stateAndTask =
      Signal.foldp
        (\(now, Just action) (state, _) -> app.update loopbackFun now action state)
        (app.initialState, Nothing)
        allActions

    html : Signal Html
    html =
      stateAndTask
        |> Signal.map fst
        |> Signal.map (app.view justWrapper)

    --tasks : Signal (T.Task error ())
    tasks =
      stateAndTask
        |> Signal.filterMap snd (T.succeed ())
  in
    (html, tasks)
