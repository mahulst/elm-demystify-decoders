module Exercise10 exposing (decoder, Person, PersonDetails, Role(..))

import Json.Decode exposing (fail, Decoder, field, string, list)


{- Let's try and do a complicated decoder, this time. No worries, nothing new
   here: applying the techniques you've used in the previous decoders should
   help you through this one.

   A couple of pointers:
    - try working "inside out". Write decoders for the details and role first
    - combine those decoders + the username and map them into the Person constructor
    - finally, wrap it all together to build it into a list of people


   Example input:

        [ { "username": "Phoebe"
          , "role": "regular"
          , "details":
            { "registered": "yesterday"
            , "aliases": [ "Phoebs" ]
            }
          }
        ]
-}


type alias Person =
    { username : String
    , role : Role
    , details : PersonDetails
    }


type alias PersonDetails =
    { registered : String
    , aliases : List String
    }


type Role
    = Newbie
    | Regular
    | OldFart


decoder : Decoder (List Person)
decoder =
    (list personDecoder)


personDecoder: Decoder Person
personDecoder =
    Json.Decode.map3
        Person
        (field "username" string)
        (field "role" string |> Json.Decode.andThen roleDecoder)
        (field "details" detailsDecoder)

detailsDecoder: Decoder PersonDetails
detailsDecoder =
    Json.Decode.map2 PersonDetails (field "registered" string) (field "aliases" (list string))

roleDecoder : String -> Decoder Role
roleDecoder s =
    case s of
        "newbie" -> Json.Decode.succeed Newbie
        "regular" -> Json.Decode.succeed Regular
        "oldfart" -> Json.Decode.succeed OldFart
        _ -> fail "no such role"


{- Once you think you're done, run the tests for this exercise from the root of
   the project:

   - If you have installed `elm-test` globally:
        `elm test tests/Exercise10`

   - If you have installed locally using `npm`:
        `npm run elm-test tests/Exercise10`

   - If you have installed locally using `yarn`:
        `yarn elm-test tests/Exercise10`
-}
