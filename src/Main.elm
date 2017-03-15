port module Main exposing (main)

import Html exposing (..)
import Html.Events exposing (onInput)
import Html.Attributes as Attr exposing (..)
import Return exposing (Return)
import Time exposing (Time)
import Http
import Json.Decode exposing (decodeString)
import Jenkins.Jobs.Types exposing (..)
import Jenkins.Jobs.Json exposing (..)


testJobsReturn : String
testJobsReturn =
    """
    {
      "jobs" : [
        {
          "name" : "job1"
        },
        {
          "name" : "wtf it works"
        }
      ]
    }
  """


listJobs : Result String (List Job)
listJobs =
    decodeString parseJobs testJobsReturn



-- getJenkins : Cmd Msg
-- getJenkins =
--     let
--         url =
--             "https://jenkins.athndev.org/api/json"
--     in
--         Http.send NewText (Http.get url)


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


emptyJob : List Job
emptyJob =
    [ { name = "hi" } ]


renderJobs : Result String (List Job) -> Html Msg
renderJobs jobs =
    ul []
        (List.map (\job -> li [] [ text job.name ]) (Result.withDefault emptyJob jobs))


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
        [ p [] [ text "hello" ]
        , input [ type_ "text", placeholder "Enter some stuff", value reverse, onInput NewText ] []
        , text <| String.reverse reverse
        , div [] [ text <| toString now ]
        , div [] [ (renderJobs listJobs) ]
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
