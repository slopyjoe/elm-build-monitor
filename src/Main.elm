port module Main exposing (main)

import Html exposing (..)
import Html.Events exposing (onInput)
import Html.Attributes as Attr exposing (..)
import Return exposing (Return)
import Time exposing (Time)


type alias Model =
    { reverse : String
    , now : Time
    }


initModel : Model
initModel =
    { reverse = ""
    , now = 0.0
    }


type Msg
    = NewText String
    | Tick Time


{-| Msg -> Model -> (Model, Cmd Msg)
-}
update : Msg -> Model -> Return Msg Model
update msg =
    Return.singleton
        >> (case msg of
                NewText s ->
                    Return.map <| \model -> { model | reverse = s }

                Tick t ->
                    Return.map <| \model -> { model | now = t }
           )
        >> Return.effect_
            (\{ reverse } ->
                if String.length reverse > 1 && String.reverse reverse == reverse then
                    alert reverse
                else
                    Cmd.none
            )


view : Model -> Html Msg
view { reverse, now } =
    div []
        [ p [] [text "hello"]
        , input [ type_ "text", placeholder "Enter some stuff", value reverse, onInput NewText ] []
        , text <| String.reverse reverse
        , div [] [ text <| toString now ]
        ]


port alert : String -> Cmd msg


main : Program Never Model Msg
main =
    Html.program
        { init = Return.singleton initModel
        , update = update
        , view = view
        , subscriptions =
            always <| Time.every Time.second Tick
            -- we can subscribe to javascript stuff or api stuff
        }
