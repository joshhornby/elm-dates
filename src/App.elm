module App exposing (..)

import List exposing (..)
import Date exposing (..)
import Date.Extra exposing (..)
import Html exposing (Html, div, li, text, ul)
import Task
import Time exposing (Time)


type alias Model =
    Float


type Msg
    = OnTime Time


update : Msg -> Model -> ( Model, Cmd msg )
update (OnTime t) model =
    ( t, Cmd.none )


isToday : Date -> Date -> Bool
isToday date now =
    let
        start =
            Date.Extra.floor Date.Extra.Day now

        end =
            Date.Extra.ceiling Date.Extra.Day now
    in
        Date.Extra.isBetween start end date


renderDate : Date -> Date -> String
renderDate date now =
    if (isToday date now) then
        Date.Extra.toFormattedString "h:mm a" date
    else
        Date.Extra.toFormattedString "E" date


{-| Possibly could use Date.Extra.fromIsoString
-}
stringToDate : String -> Date
stringToDate date =
    Date.fromString date
        |> Result.withDefault (Date.fromTime 0)


getTime =
    Time.now
        |> Task.perform OnTime


staticDates =
    [ "2017/01/12", "2017/06/24", "2017/06/25" ]


view : Model -> Html Msg
view model =
    staticDates
        |> map (\l -> li [] [ text (renderDate (stringToDate l) (Date.fromTime model)) ])
        |> ul []


main =
    Html.program
        { init = ( 0, getTime )
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }
