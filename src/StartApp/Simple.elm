module StartApp.Simple where
{-| This module makes it super simple to get started making a typical web app.
This is what you want if you are new to Elm, still getting a handle on the
syntax and patterns.

It is designed to work perfectly with [the Elm Architecture][arch] which
describes a simple architecture pattern that makes testing and refactoring
shockingly pleasant. Definitely read [the tutorial][arch] to get started!

[arch]: https://github.com/evancz/elm-architecture-tutorial/

# Start your Application
@docs start, Config
-}

import Debug
import Html exposing (Html)
import Signal exposing (Address)


{-| The configuration has three key components:

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
type alias Config model action =
    { model : model
    , view : Address action -> model -> Html
    , update : action -> model -> model
    }


{-| This starts up your application. The following code sets up a counter
that can be incremented and decremented. You can read more about writing
programs like this [here](https://github.com/evancz/elm-architecture-tutorial/).

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

Notice that the program cleanly breaks up into model, update, and view.
This means it is super easy to test your update logic independent of any
rendering.
-}
start : Config model action -> Signal Html
start config =
  let
    actions =
      Signal.mailbox Nothing

    address =
      Signal.forwardTo actions.address Just

    update maybeAction model =
      case maybeAction of
        Just action ->
            config.update action model

        Nothing ->
            Debug.crash "This should never happen."

    model =
      Signal.foldp update config.model actions.signal
  in
    Signal.map (config.view address) model
