module Jenkins.Jobs.Json exposing (..)

import Jenkins.Jobs.Types exposing (..)
import Json.Decode exposing (succeed, Decoder, map, string, field, list, at, decodeString)
import Json.Decode.Extra exposing ((|:))


jobDecoder : Decoder Job
jobDecoder =
    succeed Job
        |: (field "name" string)


parseJobs : Decoder (List Job)
parseJobs =
    at [ "jobs" ] (Json.Decode.list jobDecoder)
